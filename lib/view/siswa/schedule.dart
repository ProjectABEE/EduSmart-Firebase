import 'package:edusmart/widget/schedule.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddGSubjectPage()),
      //     );
      //     setState(() {}); // refresh setelah balik
      //   },
      //   backgroundColor: const Color(0xFF2567E8),
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Schedule atas biru
              Container(
                height: 100,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      "Schedule",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Class Schedule", style: TextStyle(fontSize: 24)),
                        Text(
                          "Week of Oct 27-31, 2025",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xffeaf0ff),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xff3b82f6),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Container Monday
              Container(
                padding: EdgeInsets.only(left: 20),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text("Monday", style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("4 classes"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
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
              // Container Tuesday
              Container(
                padding: EdgeInsets.only(left: 20),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text("Tuesday", style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("3 classes"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ScheduleTile(
                            color: Colors.green,
                            subject: "Biology",
                            teacher: "Dr. Sarah Lee",
                            room: "Lab 3",
                            time: "08:00 - 09:30",
                          ),
                          ScheduleTile(
                            color: Colors.orange,
                            subject: "History",
                            teacher: "Mr. James Wilson",
                            room: "Room 302",
                            time: "09:45 - 11:15",
                          ),
                          ScheduleTile(
                            color: Colors.purple,
                            subject: "English Literature",
                            teacher: "Mr. Robert Wilson",
                            room: "Room 201",
                            time: "12:00 - 13:30",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Wednesday
              Container(
                padding: EdgeInsets.only(left: 20),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text("Wednesday", style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("4 classes"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ScheduleTile(
                            color: Colors.orange,
                            subject: "Chemistry",
                            teacher: "Mr. Michael Brown",
                            room: "Lab 2",
                            time: "08:00 - 09:30",
                          ),
                          ScheduleTile(
                            color: Colors.green,
                            subject: "English Literature",
                            teacher: "Ms. Lisa Anderson",
                            room: "Room 105",
                            time: "09:45 - 11:15",
                          ),
                          ScheduleTile(
                            color: Colors.blue,
                            subject: "Physics",
                            teacher: "Mrs. Emily Davis",
                            room: "Lab 1",
                            time: "12:00 - 13:30",
                          ),
                          ScheduleTile(
                            color: Colors.orange,
                            subject: "Physical Education",
                            teacher: "Coach Martinez",
                            room: "Gym",
                            time: "13:45 - 15:15",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Thursday
              Container(
                padding: EdgeInsets.only(left: 20),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text("Thursday", style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("3 classes"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
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
                            color: Colors.green,
                            subject: "Biology",
                            teacher: "Dr. Sarah Lee",
                            room: "Lab 3",
                            time: "09:45 - 11:15",
                          ),
                          ScheduleTile(
                            color: Colors.pink,
                            subject: "Art & Design",
                            teacher: "Ms. Clara White",
                            room: "Art Studio",
                            time: "12:00 - 13:30",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container Friday
              Container(
                padding: EdgeInsets.only(left: 20),
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
                      padding: const EdgeInsets.only(
                        top: 20,
                        left: 8,
                        right: 24,
                      ),
                      child: Row(
                        children: [
                          Text("Friday", style: TextStyle(fontSize: 18)),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xffeaf0ff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text("3 classes"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          ScheduleTile(
                            color: Colors.blue,
                            subject: "Physics",
                            teacher: "Mrs. Emily Davis",
                            room: "Lab 1",
                            time: "08:00 - 09:30",
                          ),
                          ScheduleTile(
                            color: Colors.orange,
                            subject: "Chemistry",
                            teacher: "Dr. Michael Brown",
                            room: "Lab 2",
                            time: "09:45 - 11:15",
                          ),
                          ScheduleTile(
                            color: Colors.deepPurpleAccent,
                            subject: "Computer Science",
                            teacher: "Mr. David Kim",
                            room: "Lab",
                            time: "12:00 - 13:30",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
