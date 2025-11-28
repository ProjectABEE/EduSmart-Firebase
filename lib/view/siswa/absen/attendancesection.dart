import 'package:edusmart/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceSection extends StatefulWidget {
  final String studentId;

  const AttendanceSection({super.key, required this.studentId});

  @override
  State<AttendanceSection> createState() => _AttendanceSectionState();
}

class _AttendanceSectionState extends State<AttendanceSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final p = context.read<AttendanceProvider>();
      p.loadToday(widget.studentId);
      p.loadWeek(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AttendanceProvider>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Color(0xFF3B82F6)),
              SizedBox(width: 8),
              Text(
                "Attendance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          SizedBox(height: 16),

          /// CARD STATUS
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFEFFCF3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFDFF6E8)),
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.check_circle, color: Color(0xFF16A34A)),
                    SizedBox(width: 6),
                    Text(
                      "Status Absensi Hari Ini",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _statusBox("Check In", p.formattedCheckIn)),
                    SizedBox(width: 10),
                    Expanded(
                      child: _statusBox("Check Out", p.formattedCheckOut),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("This Week", style: TextStyle(fontWeight: FontWeight.w600)),
              Text(
                "${p.weekPercent.toStringAsFixed(0)}%",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),

          SizedBox(height: 10),

          LinearProgressIndicator(
            value: (p.weekPercent / 100).clamp(0, 1),
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(Color(0xFF111827)),
          ),

          SizedBox(height: 16),

          /// WEEK CIRCLES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: p.weeklyData.map((e) {
              final day = DateFormat(
                'E',
              ).format(DateTime.parse(e["date"])).substring(0, 3);
              return _dayCircle(day, e["status"]);
            }).toList(),
          ),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: p.isCheckedIn
                      ? null
                      : () => p.checkIn(widget.studentId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                  ),
                  child: Text(
                    p.isCheckedIn ? "Sudah Check-in" : "Check-in",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: p.isCheckedIn && !p.isCheckedOut
                      ? () => p.checkOut(widget.studentId)
                      : null,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  child: Text(
                    p.isCheckedOut ? "Sudah Check-out" : "Check-out",
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

  Widget _statusBox(String label, String value) => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 13)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _dayCircle(String day, String status) {
    Color bg;
    Icon? icon;

    switch (status) {
      case "done":
        bg = Color(0xFF16A34A);
        icon = Icon(Icons.check, color: Colors.white, size: 18);
        break;
      case "half":
        bg = Color(0xFF3B82F6);
        icon = Icon(Icons.access_time, color: Colors.white, size: 18);
        break;
      default:
        bg = Colors.grey.shade200;
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: bg,
          child:
              icon ??
              Text(day[0], style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 4),
        Text(day, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
