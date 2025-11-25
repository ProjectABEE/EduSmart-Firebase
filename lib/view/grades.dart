import 'package:edusmart/view/add_grade_page.dart';
import 'package:edusmart/widget/taksitem.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGradePage()),
          );
          setState(() {}); // refresh setelah balik
        },
        backgroundColor: const Color(0xFF2567E8),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              // Grade atas biru
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
                      "Grades",
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Academic Performance
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Academic Performance",
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          "Current Semester",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0x1000C950),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Color(0xff00C950),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Container Overal avarage
              Container(
                padding: EdgeInsets.only(left: 20),
                margin: EdgeInsets.symmetric(horizontal: 15),
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xff00AAFF),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 16),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Overal Avarage",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "90",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xff38bdff),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.bar_chart,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: 145,
                            decoration: BoxDecoration(
                              color: Color(0xff38bdff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Highest",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "95",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 70,
                            width: 145,
                            decoration: BoxDecoration(
                              color: Color(0xff38bdff),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lowest",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "40",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
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
              ),
              // 1
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "95",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mathematics",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 14,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Improving",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3 tests",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          widthFactor: 0.95, // 92%
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
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          LessonPerformance(
                            subject: "Quiz 1",
                            date: "Oct 15",
                            score: "90",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Mid-Term",
                            date: "Oct 20",
                            score: "95",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Assignment",
                            date: "Oct 24",
                            score: "98",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 2
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "80",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Physics",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 14,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Improving",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3 tests",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          widthFactor: 0.88, // 92%
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
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          LessonPerformance(
                            subject: "Lab Report",
                            date: "Oct 16",
                            score: "85",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Quiz 2",
                            date: "Oct 21",
                            score: "88",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Practical",
                            date: "Oct 25",
                            score: "90",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 3
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff00C950),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "92",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "English Literature",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_downward,
                                  size: 14,
                                  color: Colors.redAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Needs attention",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3 tests",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          LessonPerformance(
                            subject: "Essay 1",
                            date: "Oct 14",
                            score: "95",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Quiz",
                            date: "Oct 19",
                            score: "92",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Presentation",
                            date: "Oct 23",
                            score: "89",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 4
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "85",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Chemistry",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 14,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Improving",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3 tests",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          widthFactor: 0.85, // 92%
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
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          LessonPerformance(
                            subject: "Quiz 1",
                            date: "Oct 13",
                            score: "78",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Lab Work",
                            date: "Oct 18",
                            score: "85",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Mid Term",
                            date: "Oct 22",
                            score: "92",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // 5
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff00C950),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "88",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Biology",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 14,
                                  color: Colors.greenAccent,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Improving",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "3 tests",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                          widthFactor: 0.88, // 92%
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
                    Padding(
                      padding: EdgeInsets.all(4),
                      child: Column(
                        children: [
                          LessonPerformance(
                            subject: "Practical",
                            date: "Oct 12",
                            score: "88",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Quiz 2",
                            date: "Oct 17",
                            score: "86",
                          ),
                          SizedBox(height: 4),
                          LessonPerformance(
                            subject: "Assignment",
                            date: "Oct 23",
                            score: "90",
                          ),
                        ],
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
