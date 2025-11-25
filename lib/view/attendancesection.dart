import 'package:edusmart/database/db_helper.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/view/attendanceshistory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceSection extends StatefulWidget {
  final StudentModel? student;
  const AttendanceSection({super.key, this.student});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  StudentModel? student;
  Map<String, Map<String, dynamic>> weekMap = {}; // date -> row
  Map<String, dynamic>? todayRow;
  bool loading = true;
  bool isCheckedIn = false;
  bool isCheckedOut = false;
  int? todayId;
  double weekPercent = 0.0;

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');

    if (email != null) {
      final db = await DbHelper.db();
      final result = await db.query(
        DbHelper.tableStudent,
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        setState(() {
          student = StudentModel.fromMap(result.first);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await getData(); // ambil data student dari SharedPreferences
    await _refreshAll(); // setelah student tidak null, refresh data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshAll(); // supaya data di-refresh lagi saat kembali ke halaman ini
  }

  Future<void> _refreshAll() async {
    if (student == null) {
      print('⚠️ student null, skip refresh');
      setState(() => loading = false);
      return;
    }
    try {
      await _loadWeek();
      await _loadToday();
    } catch (e) {
      print('⚠️ Attendance load error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadWeek() async {
    final now = DateTime.now();
    // show Monday..Friday as in design (5 days)
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    // gather 5 days Mon..Fri
    final days = List.generate(5, (i) => startOfWeek.add(Duration(days: i)));
    final startDate = DateFormat('yyyy-MM-dd').format(days.first);
    final endDate = DateFormat('yyyy-MM-dd').format(days.last);

    final results = await DbHelper.getAttendanceByStudent(student!.id!);
    // build map from results (only between startDate..endDate)
    Map<String, Map<String, dynamic>> map = {};
    for (final r in results) {
      final d = (r['date'] ?? '').toString();
      if (d.compareTo(startDate) >= 0 && d.compareTo(endDate) <= 0) {
        map[d] = r;
      }
    }

    // ensure all 5 days exist (if not, set null)
    Map<String, Map<String, dynamic>> week = {};
    for (final day in days) {
      final key = DateFormat('yyyy-MM-dd').format(day);
      week[key] = map.containsKey(key) ? map[key]! : {};
    }

    // compute percent (e.g., count done / 5)
    int done = 0;
    for (final e in week.entries) {
      final row = e.value;
      if (row.isNotEmpty && row['check_out'] != null) done++;
    }
    final percent = (done / 5) * 100;

    setState(() {
      weekMap = week;
      weekPercent = percent;
    });
  }

  Future<void> _loadToday() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final results = await DbHelper.getAttendanceByStudent(student!.id!);
    final found = results.firstWhere(
      (r) => (r['date'] ?? '') == today,
      orElse: () => {},
    );
    if (found.isNotEmpty) {
      setState(() {
        todayRow = found;
        isCheckedIn = found['check_in'] != null;
        isCheckedOut = found['check_out'] != null;
        todayId = found['id'] as int?;
      });
    } else {
      setState(() {
        todayRow = null;
        isCheckedIn = false;
        isCheckedOut = false;
        todayId = null;
      });
    }
  }

  Future<void> _doCheckIn() async {
    if (widget.student == null) return;
    final now = DateTime.now();
    final day = DateFormat('yyyy-MM-dd').format(now);
    final time = DateFormat('HH:mm').format(now);

    final insertedId = await DbHelper.insertAttendance({
      'student_id': widget.student!.id,
      'date': day,
      'check_in': time,
      'check_out': null,
      'status': 'Hadir',
    });

    // update local quickly and reload
    setState(() {
      isCheckedIn = true;
      todayId = insertedId;
      todayRow = {
        'date': day,
        'check_in': time,
        'check_out': null,
        'id': insertedId,
      };
      weekMap[day] = todayRow!;
    });

    await _loadWeek(); // recalc percent & state
  }

  Future<void> _doCheckOut() async {
    if (todayId == null) return;
    final now = DateTime.now();
    final time = DateFormat('HH:mm').format(now);

    await DbHelper.updateCheckOut(todayId!, time);

    // update local state
    setState(() {
      isCheckedOut = true;
      if (todayRow != null) {
        todayRow = Map<String, dynamic>.from(todayRow!);
        todayRow!['check_out'] = time;
      }

      final dayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (weekMap.containsKey(dayKey)) {
        final mutableDay = Map<String, dynamic>.from(weekMap[dayKey]!);
        mutableDay['check_out'] = time;
        weekMap[dayKey] = mutableDay;
      }
    });

    await _loadWeek();
  }

  // small helper to render circle day widget
  Widget _buildDayCircle(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    final row = weekMap[key] ?? {};
    final bool isToday = DateFormat('yyyy-MM-dd').format(DateTime.now()) == key;

    // status: none / half (check_in) / done (check_out)
    String status = 'none';
    if (row.isNotEmpty) {
      if (row['check_out'] != null)
        status = 'done';
      else if (row['check_in'] != null)
        status = 'half';
    }

    Color bg;
    Widget child;
    switch (status) {
      case 'done':
        bg = const Color(0xFF16A34A); // green
        child = const Icon(Icons.check, color: Colors.white, size: 16);
        break;
      case 'half':
        bg = const Color(0xFF3B82F6); // blue
        child = const Icon(Icons.access_time, color: Colors.white, size: 14);
        break;
      default:
        bg = Colors.grey.shade200;
        child = Text(
          DateFormat('E').format(date).substring(0, 1),
          style: TextStyle(
            color: isToday ? Colors.black : Colors.black54,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
          ),
        );
    }

    // highlight today with subtle border
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: isToday
                ? Border.all(color: const Color(0xFF3B82F6), width: 2)
                : null,
          ),
          width: 40,
          height: 40,
          child: Center(child: child),
        ),
        const SizedBox(height: 6),
        Text(
          DateFormat('E').format(date).substring(0, 3),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // monday

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: loading
          ? const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header + history
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Attendance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
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
                      child: const Text(
                        "Riwayat",
                        style: TextStyle(
                          color: Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // status card (green rounded)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFCF3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFDFF6E8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Color(0xFF16A34A),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Status Absensi Hari Ini",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Check In",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    todayRow?['check_in'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Check Out",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    todayRow?['check_out'] ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // This Week + progress
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "This Week",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${weekPercent.toStringAsFixed(0)}%",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (weekPercent / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(const Color(0xFF111827)),
                  ),
                ),

                const SizedBox(height: 12),

                // days row (Mon..Fri)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(5, (i) {
                      final date = startOfWeek.add(Duration(days: i));
                      return _buildDayCircle(date);
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isCheckedIn ? null : () => _doCheckIn(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.login, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              isCheckedIn ? "Sudah Check In" : "Check In",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (isCheckedIn && !isCheckedOut)
                            ? () => _doCheckOut()
                            : null,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF3B82F6),
                            width: 2,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Sudah Check Out",
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
