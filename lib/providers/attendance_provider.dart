import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceProvider extends ChangeNotifier {
  final firestore = FirebaseFirestore.instance;

  bool isCheckedIn = false;
  bool isCheckedOut = false;

  String? todayDocId;
  String formattedCheckIn = "-";
  String formattedCheckOut = "-";

  List<Map<String, dynamic>> weeklyData = [];
  double weekPercent = 0;

  String _fmt(DateTime t) => DateFormat("HH:mm").format(t);
  String _date(DateTime t) => DateFormat("yyyy-MM-dd").format(t);

  /// ==== GET SERVER TIME ====
  Future<DateTime?> getServerTime() async {
    final doc = await firestore.collection("server_time_check").add({
      "timestamp": FieldValue.serverTimestamp(),
    });

    final snapshot = await doc.get();
    await doc.delete();

    if (snapshot.data()?["timestamp"] is Timestamp) {
      return (snapshot.data()?["timestamp"] as Timestamp).toDate();
    }
    return null;
  }

  /// ==== LOAD TODAY DATA ====
  Future<void> loadToday(String studentId) async {
    final now = await getServerTime();
    if (now == null) return;

    final today = _date(now);

    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: studentId)
        .where("date", isEqualTo: today)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      isCheckedIn = false;
      isCheckedOut = false;
      formattedCheckIn = "-";
      formattedCheckOut = "-";
      todayDocId = null;
    } else {
      final data = snap.docs.first.data();
      todayDocId = snap.docs.first.id;

      formattedCheckIn = data["check_in"] ?? "-";
      formattedCheckOut = data["check_out"] ?? "-";

      isCheckedIn = data["check_in"] != null;
      isCheckedOut = data["check_out"] != null;
    }

    notifyListeners();
  }

  /// ==== LOAD WEEK STATUS ====
  Future<void> loadWeek(String studentId) async {
    final now = await getServerTime();
    if (now == null) return;

    final monday = now.subtract(Duration(days: now.weekday - 1));

    final dates = List.generate(5, (i) => _date(monday.add(Duration(days: i))));

    final snap = await firestore
        .collection("attendance")
        .where("student_id", isEqualTo: studentId)
        .get();

    weeklyData.clear();
    int completed = 0;

    for (var day in dates) {
      final found = snap.docs.where((d) => d.data()["date"] == day).toList();
      if (found.isEmpty) {
        weeklyData.add({"date": day, "status": "none"});
      } else {
        final d = found.first.data();
        final s = d["check_out"] != null ? "done" : "half";
        if (s == "done") completed++;
        weeklyData.add({"date": day, "status": s});
      }
    }

    weekPercent = (completed / 5) * 100;
    notifyListeners();
  }

  /// ==== CHECK IN ====
  Future<void> checkIn(String studentId) async {
    final now = await getServerTime();
    if (now == null) return;

    final day = _date(now);
    final time = _fmt(now);

    final ref = await firestore.collection("attendance").add({
      "student_id": studentId,
      "date": day,
      "check_in": time,
      "check_out": null,
      "status": "Hadir",
    });

    todayDocId = ref.id;
    formattedCheckIn = time;
    isCheckedIn = true;

    notifyListeners();
  }

  /// ==== CHECK OUT ====
  Future<void> checkOut(String studentId) async {
    if (todayDocId == null) return;

    final now = await getServerTime();
    if (now == null) return;

    final time = _fmt(now);

    await firestore.collection("attendance").doc(todayDocId).update({
      "check_out": time,
    });

    formattedCheckOut = time;
    isCheckedOut = true;

    notifyListeners();
  }
}
