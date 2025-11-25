import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/view/attendanceshistory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceSection extends StatefulWidget {
  final StudentModel? student;
  const AttendanceSection({super.key, this.student});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  StudentModel? student;

  bool loading = true;
  bool isCheckedIn = false;
  bool isCheckedOut = false;

  String? todayDocId;
  Map<String, dynamic>? todayRow;
  Map<String, Map<String, dynamic>> weekMap = {};

  double weekPercent = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStudent();
  }

  Future<void> _loadStudent() async {
    final user = auth.currentUser;
    if (user == null) return;

    final doc = await firestore.collection("students").doc(user.uid).get();

    if (doc.exists) {
      student = StudentModel.fromMap({"id": user.uid, ...doc.data()!});
      await _refresh();
    }

    setState(() => loading = false);
  }

  Future<void> _refresh() async {
    await _loadWeek();
    await _loadToday();
  }

  Future<void> _loadWeek() async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final weekDays = List.generate(5, (i) => start.add(Duration(days: i)));

    final startDate = DateFormat("yyyy-MM-dd").format(weekDays.first);
    final endDate = DateFormat("yyyy-MM-dd").format(weekDays.last);

    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: student!.id)
        .where("date", isGreaterThanOrEqualTo: startDate)
        .where("date", isLessThanOrEqualTo: endDate)
        .get();

    Map<String, Map<String, dynamic>> temp = {
      for (var d in snap.docs) d["date"]: d.data(),
    };

    Map<String, Map<String, dynamic>> weekMapped = {};
    for (var d in weekDays) {
      final key = DateFormat("yyyy-MM-dd").format(d);
      weekMapped[key] = temp[key] ?? {};
    }

    weekPercent =
        (weekMapped.values.where((e) => e["check_out"] != null).length / 5) *
        100;

    setState(() => weekMap = weekMapped);
  }

  Future<void> _loadToday() async {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: student!.id)
        .where("date", isEqualTo: today)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      final data = snap.docs.first.data();
      setState(() {
        todayDocId = snap.docs.first.id;
        todayRow = data;
        isCheckedIn = data["check_in"] != null;
        isCheckedOut = data["check_out"] != null;
      });
    } else {
      setState(() {
        todayDocId = null;
        todayRow = null;
        isCheckedIn = false;
        isCheckedOut = false;
      });
    }
  }

  Future<void> checkIn() async {
    final now = DateTime.now();
    final today = DateFormat("yyyy-MM-dd").format(now);
    final time = DateFormat("HH:mm").format(now);

    final ref = await firestore.collection("attendance").add({
      "student_id": student!.id,
      "date": today,
      "check_in": time,
      "check_out": null,
      "status": "Hadir",
    });

    todayDocId = ref.id;
    isCheckedIn = true;
    todayRow = {"check_in": time};

    await _refresh();
  }

  Future<void> checkOut() async {
    if (todayDocId == null) return;

    final time = DateFormat("HH:mm").format(DateTime.now());

    await firestore.collection("attendance").doc(todayDocId).update({
      "check_out": time,
    });

    isCheckedOut = true;
    todayRow?["check_out"] = time;

    await _refresh();
  }

  Widget buildCircle(DateTime date) {
    final key = DateFormat("yyyy-MM-dd").format(date);
    final row = weekMap[key] ?? {};
    final isToday = key == DateFormat("yyyy-MM-dd").format(DateTime.now());

    String status = "none";
    if (row["check_out"] != null)
      status = "done";
    else if (row["check_in"] != null)
      status = "half";

    Color bg;
    IconData? icon;

    if (status == "done")
      bg = Colors.green;
    else if (status == "half")
      bg = Colors.blue;
    else
      bg = Colors.grey.shade300;

    if (status == "done")
      icon = Icons.check;
    else if (status == "half")
      icon = Icons.access_time;

    return Column(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: Colors.blue, width: 2) : null,
          ),
          child: Center(
            child: icon != null
                ? Icon(icon, size: 18, color: Colors.white)
                : Text(DateFormat("E").format(date)[0]),
          ),
        ),
        SizedBox(height: 4),
        Text(DateFormat("E").format(date).substring(0, 3)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Color(0xFF3B82F6)),
                    SizedBox(width: 10),
                    Text(
                      "Attendance",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                HistoryPage(studentId: student!.id!),
                          ),
                        );
                      },
                      child: Text(
                        "Riwayat",
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18),

                /// STATUS CARD
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xFFE8FCEB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Check In: ${todayRow?["check_in"] ?? "-"}"),
                      Text("Check Out: ${todayRow?["check_out"] ?? "-"}"),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                /// PROGRESS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "This Week",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text("${weekPercent.toStringAsFixed(0)}%"),
                  ],
                ),

                SizedBox(height: 6),
                LinearProgressIndicator(
                  value: weekPercent / 100,
                  backgroundColor: Colors.grey.shade300,
                  minHeight: 8,
                ),

                SizedBox(height: 20),

                /// DAYS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    5,
                    (i) => buildCircle(startWeek.add(Duration(days: i))),
                  ),
                ),

                SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isCheckedIn ? null : checkIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3B82F6),
                        ),
                        child: Text(
                          isCheckedIn ? "Sudah Check In" : "Check In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isCheckedIn && !isCheckedOut
                            ? checkOut
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF3B82F6)),
                        ),
                        child: Text(
                          "Check Out",
                          style: TextStyle(color: Color(0xFF3B82F6)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
