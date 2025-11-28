import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/providers/grade_provider.dart';
import 'package:edusmart/providers/user_provider.dart';
import 'package:edusmart/view/siswa/absen/attendancesection.dart';
import 'package:edusmart/widget/announcementsW.dart';
import 'package:edusmart/widget/nilai.dart';
import 'package:edusmart/widget/profileavatar.dart';
import 'package:edusmart/widget/schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePageEdu extends StatefulWidget {
  const HomePageEdu({super.key});
  @override
  State<HomePageEdu> createState() => _HomePageEduState();
}

class _HomePageEduState extends State<HomePageEdu> {
  StudentModel? student;
  bool isCheckedIn = false;
  bool isCheckedOut = false;

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
                height: 200,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Color(0XFF2567E8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
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
                    Padding(padding: EdgeInsetsGeometry.all(8)),
                    Row(
                      children: [
                        const ProfileAvatar(size: 30),
                        const SizedBox(width: 10),

                        Consumer<UserProvider>(
                          builder: (context, provider, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome back,",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  provider.student?.name ?? "Loading...",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),

                        const Spacer(),
                        const Icon(Icons.notifications_none_outlined, size: 26),
                      ],
                    ),

                    SizedBox(height: 10),
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Color(0X605DB6DF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Student ID",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Class",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "2024-001",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "XI IPA 2",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Consumer<UserProvider>(
                builder: (context, provider, _) {
                  final student = provider.student;

                  if (student == null) {
                    return const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return AttendanceSection(studentId: student.id!);
                },
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
                          Spacer(),
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
                          // TextButton(
                          //   onPressed: () {
                          //     PreferenceHandler.removeLogin();
                          //     Navigator.pushAndRemoveUntil(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => LoginEdu(),
                          //       ),
                          //       (route) => false,
                          //     );
                          //   },
                          //   child: Text("Logout"),
                          // ),
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
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// -------- HEADER --------
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
                          SizedBox(width: 8),
                          Text(
                            "Today's Schedule",
                            style: TextStyle(fontSize: 16.9),
                          ),
                          Spacer(),

                          /// Auto detect hari dari WIB
                          StreamBuilder(
                            stream: Stream.periodic(Duration(seconds: 1)),
                            builder: (_, __) {
                              final now = DateTime.now().toUtc().add(
                                Duration(hours: 7),
                              );
                              final eng = DateFormat('EEEE').format(now);

                              final mapping = {
                                "Monday": "Senin",
                                "Tuesday": "Selasa",
                                "Wednesday": "Rabu",
                                "Thursday": "Kamis",
                                "Friday": "Jumat",
                                "Saturday": "Sabtu",
                                "Sunday": "Libur",
                              };

                              return Text(
                                mapping[eng] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    /// -------- STREAM FIRESTORE --------
                    Expanded(
                      child: StreamBuilder(
                        stream: (() {
                          final now = DateTime.now().toUtc().add(
                            Duration(hours: 7),
                          );
                          final eng = DateFormat('EEEE').format(now);
                          final mapping = {
                            "Monday": "Senin",
                            "Tuesday": "Selasa",
                            "Wednesday": "Rabu",
                            "Thursday": "Kamis",
                            "Friday": "Jumat",
                            "Saturday": "Sabtu",
                            "Sunday": "Libur",
                          };

                          final today = mapping[eng] ?? "Unknown";

                          return FirebaseFirestore.instance
                              .collection("subjects")
                              .where("day", isEqualTo: today)
                              .orderBy("start_time")
                              .snapshots();
                        })(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final docs = snapshot.data!.docs;

                          if (docs.isEmpty) {
                            return Center(
                              child: Text("Tidak ada jadwal hari ini 😊"),
                            );
                          }

                          final colors = [
                            Colors.purple,
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.teal,
                            Colors.redAccent,
                            Colors.indigo,
                          ];

                          return ListView.builder(
                            padding: EdgeInsets.all(4),
                            itemCount: docs.length,
                            itemBuilder: (context, i) {
                              final data = docs[i].data();
                              return ScheduleTile(
                                color: colors[i % colors.length],
                                subject: data["subject_name"],
                                teacher: data["teacher_name"],
                                room: data["room"],
                                time:
                                    "${data["start_time"]} - ${data["end_time"]}",
                              );
                            },
                          );
                        },
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
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// 🔹 Header Recent Grades + Average
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
                          SizedBox(width: 8),
                          Text(
                            "Recent Grades",
                            style: TextStyle(fontSize: 16.9),
                          ),
                          Spacer(),

                          /// 🔹 Ambil rata-rata dari Provider
                          Consumer2<GradeProvider, UserProvider>(
                            builder: (context, gradeProvider, userProvider, _) {
                              final student = userProvider.student;
                              if (student == null) return SizedBox();

                              return FutureBuilder<double>(
                                future: gradeProvider.getAverageGrade(
                                  student.id!,
                                ),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Text(
                                      "--",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                      ),
                                    );
                                  }

                                  final avg = snapshot.data!.toStringAsFixed(1);
                                  return Column(
                                    children: [
                                      Text(
                                        "Average",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        avg,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    /// 🔹 LIST NILAI DARI FIREBASE
                    Expanded(
                      child: Consumer2<GradeProvider, UserProvider>(
                        builder: (context, gradeProvider, userProvider, _) {
                          final student = userProvider.student;
                          if (student == null) {
                            return Center(child: CircularProgressIndicator());
                          }

                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: gradeProvider.fetchRecentGrades(
                              student.id!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final grades = snapshot.data ?? [];

                              if (grades.isEmpty) {
                                return Center(
                                  child: Text("Belum ada nilai 📄"),
                                );
                              }

                              return ListView.builder(
                                itemCount: grades.length,
                                itemBuilder: (context, index) {
                                  final item = grades[index];

                                  return GradeTile(
                                    subject:
                                        item["subject_name"] ??
                                        "Unknown Subject",
                                    score: item["score"] ?? 0,
                                    color: Colors.blue,
                                    change:
                                        0, // next bisa tambahin algoritma perubahan nilai
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
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
}
