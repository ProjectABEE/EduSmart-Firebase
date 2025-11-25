import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/loginedu.dart';
import 'package:edusmart/widget/announcementsW.dart';
import 'package:edusmart/widget/daybox.dart';
import 'package:edusmart/widget/nilai.dart';
import 'package:edusmart/widget/schedule.dart';
import 'package:flutter/material.dart';

class HomePageGuruEdu extends StatefulWidget {
  const HomePageGuruEdu({super.key});
  @override
  State<HomePageGuruEdu> createState() => _HomePageGuruEduState();
}

class _HomePageGuruEduState extends State<HomePageGuruEdu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Profil Atas Biru
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFF2567E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/abe2.png',
                              ),
                              radius: 25,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Pak Budi Santoso',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.school, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statCard('Total Siswa', '156'),
                        _statCard('Kelas Aktif', '5'),
                        _statCard('Mata Pelajaran', '3'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Container Attendance
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 325,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Color(0xff3b82f6),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("Attendance", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 320,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xfff8fbff),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "This Week",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "92%",
                                style: TextStyle(
                                  color: Color(0xff3b82f6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: 0.92, // 92%
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              DayBox(day: "Mon", checked: true),
                              DayBox(day: "Tue", checked: true),
                              DayBox(day: "Wed", checked: true),
                              DayBox(day: "Thu", checked: false),
                              DayBox(day: "Fri", checked: true),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3b82f6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              icon: const Icon(
                                Icons.access_time,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Check In",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xff3b82f6),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Check Out",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff3b82f6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Annoucements
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x10FF6900),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_none_outlined,
                              color: Color(0xffFF6900),
                              size: 20,
                            ),
                          ),
                          // Icon(
                          //   Icons.notifications_none_outlined,
                          //   color: Color(0xffFF6900),
                          //   size: 26,
                          // ),
                          SizedBox(width: 8),
                          Text(
                            'Announcements',
                            style: TextStyle(fontSize: 16.9),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 12.8,
                                color: Color(0xff2F80ED),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              PreferenceHandler.removeLogin();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginEdu(),
                                ),
                                (route) => false,
                              );
                            },
                            child: Text("Logout"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          AnnouncementItem(
                            label: "Important",
                            date: "Oct 25, 2025",
                            title: "Mid-Term Exam Schedule Released",
                            author: "Mrs. Sarah Johnson",
                          ),
                          AnnouncementItem(
                            label: "Notice",
                            date: "Oct 20, 2025",
                            title: "Library Will Be Closed on Friday",
                            author: "Admin Office",
                          ),
                          AnnouncementItem(
                            label: "Update",
                            date: "Oct 18, 2025",
                            title: "New Course Materials Available Online",
                            author: "Mr. David Lee",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Today Schedule
              Container(
                padding: EdgeInsets.only(left: 20, top: 16),
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 474,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x103b82f6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Color(0xff3b82f6),
                              size: 20,
                            ),
                          ),
                          // Icon(
                          //   Icons.notifications_none_outlined,
                          //   color: Color(0xffFF6900),
                          //   size: 26,
                          // ),
                          SizedBox(width: 8),
                          Text(
                            "Today's Schadule",
                            style: TextStyle(fontSize: 16.9),
                          ),
                          Spacer(),
                          Text(
                            "Monday",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ScheduleTile(
                            color: Colors.purple,
                            subject: "Mathematics",
                            teacher: "Mr. Robert Wilson",
                            room: "Room 201",
                            time: "08:00 - 09:30",
                          ),
                          ScheduleTile(
                            color: Colors.blue,
                            subject: "Physics",
                            teacher: "Mrs. Emily Davis",
                            room: "Lab 1",
                            time: "09:45 - 11:15",
                          ),
                          ScheduleTile(
                            color: Colors.green,
                            subject: "English Literature",
                            teacher: "Ms. Lisa Anderson",
                            room: "Room 105",
                            time: "12:00 - 13:30",
                          ),
                          ScheduleTile(
                            color: Colors.orange,
                            subject: "Chemistry",
                            teacher: "Dr. Michael Brown",
                            room: "Lab 2",
                            time: "13:45 - 15:15",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Recent Grades
              Container(
                padding: EdgeInsets.only(left: 20, top: 16),
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 474,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x1000C950),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              color: Color(0xff00C950),
                              size: 20,
                            ),
                          ),
                          // Icon(
                          //   Icons.notifications_none_outlined,
                          //   color: Color(0xffFF6900),
                          //   size: 26,
                          // ),
                          SizedBox(width: 8),
                          Text(
                            "Recent Grades",
                            style: TextStyle(fontSize: 16.9),
                          ),
                          Spacer(),
                          Column(
                            children: [
                              Text(
                                "Avarage",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "90",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GradeTile(
                      subject: "Mathematics",
                      score: 95,
                      color: Colors.purple,
                      change: 5,
                    ),
                    GradeTile(
                      subject: "Physics",
                      score: 88,
                      color: Colors.blue,
                      change: 3,
                    ),
                    GradeTile(
                      subject: "English",
                      score: 92,
                      color: Colors.green,
                      change: -2,
                    ),
                    GradeTile(
                      subject: "Chemistry",
                      score: 85,
                      color: Colors.orange,
                      change: 8,
                    ),
                    GradeTile(
                      subject: "Ngoding",
                      score: 20,
                      color: Colors.red,
                      change: -40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0x803b82f6),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
