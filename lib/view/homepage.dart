import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/view/AttendanceSection.dart';
import 'package:edusmart/widget/announcementsW.dart';
import 'package:edusmart/widget/nilai.dart';
import 'package:edusmart/widget/schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  void initState() {
    super.initState();
    _getFirebaseUser().then((value) {
      setState(() {
        student = value;
      });
    });
  }

  Future<StudentModel?> _getFirebaseUser() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final user = auth.currentUser;
    if (user == null) return null;

    final doc = await firestore.collection("students").doc(user.uid).get();

    if (!doc.exists) return null;

    return StudentModel.fromMap({"id": user.uid, ...doc.data()!});
  }

  // Future<void> getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final email = prefs.getString('email');

  //   if (email != null) {
  //     final db = await DbHelper.db();
  //     final result = await db.query(
  //       DbHelper.tableStudent,
  //       where: 'email = ?',
  //       whereArgs: [email],
  //     );

  //     if (result.isNotEmpty) {
  //       setState(() {
  //         student = StudentModel.fromMap(result.first);
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(left: 16),
              //   child: TextButton(
              //     onPressed: () {
              //       PreferenceHandler.removeLogin();
              //       FirebaseAuth.instance.signOut();
              //       Navigator.pushAndRemoveUntil(
              //         context,
              //         MaterialPageRoute(builder: (_) => LoginEdu()),
              //         (_) => false,
              //       );
              //     },
              //     child: Row(
              //       children: [
              //         Icon(Icons.logout, color: Colors.red),
              //         SizedBox(width: 8),
              //         Text("Logout", style: TextStyle(color: Colors.red)),
              //       ],
              //     ),
              //   ),
              // ),
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
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage('assets/images/abe2.png'),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome back,",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              student?.name ?? '-',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.notifications_none_outlined, size: 26),
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
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 20,
              //         offset: const Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   child:
              FutureBuilder<StudentModel?>(
                future: _getFirebaseUser(), // 🔥 fungsi baru
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox(
                      height: 220,
                      child: Center(child: Text('Tidak ada data siswa')),
                    );
                  }

                  return AttendanceSection(student: snapshot.data);
                },
              ),
              // ),

              // Container Attendance
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 20,
              //         offset: const Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   child: FutureBuilder<StudentModel?>(
              //     future: DbHelper.getStudentFromPrefs(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return const SizedBox(
              //           height: 220,
              //           child: Center(child: CircularProgressIndicator()),
              //         );
              //       }
              //       if (!snapshot.hasData || snapshot.data == null) {
              //         return const SizedBox(
              //           height: 220,
              //           child: Center(child: Text('Tidak ada data siswa')),
              //         );
              //       }
              //       // ✅ kirim student yang sudah pasti tidak null
              //       return AttendanceSection(student: snapshot.data);
              //     },
              //   ),
              // ),

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 15),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 20,
              //         offset: const Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   child: AttendanceSection(student: student),
              // ),

              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 15),
              //   height: 500,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(30),
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 20,
              //         offset: const Offset(0, 8),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(20.0),
              //         child: Row(
              //           children: [
              //             Container(
              //               padding: const EdgeInsets.all(8),
              //               decoration: BoxDecoration(
              //                 color: const Color(0xffeaf0ff),
              //                 borderRadius: BorderRadius.circular(12),
              //               ),
              //               child: const Icon(
              //                 Icons.calendar_today,
              //                 color: Color(0xff3b82f6),
              //                 size: 20,
              //               ),
              //             ),
              //             SizedBox(width: 10),
              //             Text("Attendance", style: TextStyle(fontSize: 18)),
              //             Spacer(),
              //             InkWell(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) =>
              //                         HomePageGuruEdu(name: 'name'),
              //                   ),
              //                 );
              //               },
              //               child: Row(
              //                 children: [
              //                   Icon(Icons.access_time),
              //                   SizedBox(width: 4),
              //                   Text("History"),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),

              //       SizedBox(height: 4),
              //       Container(
              //         width: 320,
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 16,
              //           vertical: 14,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Color(0xfff8fbff),
              //           borderRadius: BorderRadius.circular(16),
              //         ),
              //         child: isCheckedIn
              //             ? Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       const Text(
              //                         "Status Absensi Hari Ini",
              //                         style: TextStyle(
              //                           fontWeight: FontWeight.bold,
              //                           fontSize: 16,
              //                         ),
              //                       ),
              //                       const SizedBox(height: 6),
              //                       Text(
              //                         "Check In: ${todayAttendance?['check_in'] ?? '-'}",
              //                       ),
              //                       Text(
              //                         "Check Out: ${todayAttendance?['check_out'] ?? '-'}",
              //                       ),
              //                       // Text(
              //                       //   "This Week",
              //                       //   style: TextStyle(
              //                       //     color: Colors.black87,
              //                       //     fontWeight: FontWeight.w500,
              //                       //   ),
              //                       // ),
              //                       // Spacer(),
              //                       // Text(
              //                       //   "92%",
              //                       //   style: TextStyle(
              //                       //     color: Color(0xff3b82f6),
              //                       //     fontWeight: FontWeight.w600,
              //                       //   ),
              //                       // ),
              //                     ],
              //                   ),
              //                   const SizedBox(height: 10),
              //                   Stack(
              //                     children: [
              //                       Container(
              //                         height: 8,
              //                         decoration: BoxDecoration(
              //                           color: Colors.grey.shade300,
              //                           borderRadius: BorderRadius.circular(8),
              //                         ),
              //                       ),
              //                       FractionallySizedBox(
              //                         widthFactor: 0.92, // 92%
              //                         child: Container(
              //                           height: 8,
              //                           decoration: BoxDecoration(
              //                             color: Colors.black87,
              //                             borderRadius: BorderRadius.circular(
              //                               8,
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                   const SizedBox(height: 16),
              //                   Row(
              //                     mainAxisAlignment:
              //                         MainAxisAlignment.spaceBetween,
              //                     children: const [
              //                       DayBox(day: "Mon", checked: true),
              //                       DayBox(day: "Tue", checked: true),
              //                       DayBox(day: "Wed", checked: true),
              //                       DayBox(day: "Thu", checked: false),
              //                       DayBox(day: "Fri", checked: true),
              //                     ],
              //                   ),
              //                 ],
              //               )
              //             : const Text("Belum Check In"),
              //       ),
              //       const SizedBox(height: 20),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 24),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: ElevatedButton.icon(
              //                 onPressed: isCheckedIn
              //                     ? null
              //                     : () async {
              //                         final now = DateTime.now()
              //                             .toIso8601String()
              //                             .substring(11, 16);
              //                         final today = DateTime.now()
              //                             .toIso8601String()
              //                             .split('T')
              //                             .first;

              //                         final id =
              //                             await DbHelper.insertAttendance({
              //                               'student_id': student?.id,
              //                               'date': today,
              //                               'check_in': now,
              //                               'check_out': null,
              //                             });

              //                         setState(() {
              //                           isCheckedIn = true;
              //                           todayAttendanceId = id;
              //                         });

              //                         await _refreshAttendance();
              //                       },

              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: const Color(0xff3b82f6),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                   ),
              //                   padding: const EdgeInsets.symmetric(
              //                     vertical: 14,
              //                   ),
              //                 ),
              //                 icon: const Icon(
              //                   Icons.access_time,
              //                   color: Colors.white,
              //                 ),
              //                 label: Text(
              //                   isCheckedIn ? "Sudah Check In" : "Check In",
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(width: 12),
              //             Expanded(
              //               child: OutlinedButton(
              //                 onPressed: isCheckedIn && !isCheckedOut
              //                     ? () async {
              //                         final now = DateTime.now()
              //                             .toIso8601String()
              //                             .substring(11, 16);
              //                         await DbHelper.updateCheckOut(
              //                           todayAttendanceId!,
              //                           now,
              //                         );

              //                         setState(() {
              //                           isCheckedOut = true;
              //                         });

              //                         await _refreshAttendance();
              //                       }
              //                     : null,

              //                 style: OutlinedButton.styleFrom(
              //                   side: const BorderSide(
              //                     color: Color(0xff3b82f6),
              //                     width: 2,
              //                   ),
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(12),
              //                   ),
              //                   padding: const EdgeInsets.symmetric(
              //                     vertical: 14,
              //                   ),
              //                 ),
              //                 child: Text(
              //                   isCheckedOut ? "Sudah Check Out" : "Check Out",
              //                   style: const TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     color: Color(0xff3b82f6),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),

              //       // Padding(
              //       //   padding: const EdgeInsets.symmetric(horizontal: 24),
              //       //   child: Row(
              //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       //     children: [
              //       //       Expanded(
              //       //         child: ElevatedButton.icon(
              //       //           onPressed: () {},
              //       //           style: ElevatedButton.styleFrom(
              //       //             backgroundColor: const Color(0xff3b82f6),
              //       //             shape: RoundedRectangleBorder(
              //       //               borderRadius: BorderRadius.circular(12),
              //       //             ),
              //       //             padding: const EdgeInsets.symmetric(
              //       //               vertical: 14,
              //       //             ),
              //       //           ),
              //       //           icon: const Icon(
              //       //             Icons.access_time,
              //       //             color: Colors.white,
              //       //           ),
              //       //           label: const Text(
              //       //             "Check In",
              //       //             style: TextStyle(
              //       //               fontWeight: FontWeight.w600,
              //       //               color: Colors.white,
              //       //             ),
              //       //           ),
              //       //         ),
              //       //       ),
              //       //       const SizedBox(width: 12),
              //       //       Expanded(
              //       //         child: OutlinedButton(
              //       //           onPressed: () {},
              //       //           style: OutlinedButton.styleFrom(
              //       //             side: const BorderSide(
              //       //               color: Color(0xff3b82f6),
              //       //               width: 2,
              //       //             ),
              //       //             shape: RoundedRectangleBorder(
              //       //               borderRadius: BorderRadius.circular(12),
              //       //             ),
              //       //             padding: const EdgeInsets.symmetric(
              //       //               vertical: 14,
              //       //             ),
              //       //           ),
              //       //           child: const Text(
              //       //             "Check Out",
              //       //             style: TextStyle(
              //       //               fontWeight: FontWeight.w600,
              //       //               color: Color(0xff3b82f6),
              //       //             ),
              //       //           ),
              //       //         ),
              //       //       ),
              //       //     ],
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
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
}
