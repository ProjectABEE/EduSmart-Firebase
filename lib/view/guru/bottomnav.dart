import 'package:edusmart/view/guru/GuruProfilePage.dart';
import 'package:edusmart/view/guru/homepage2.dart';
import 'package:edusmart/view/guru/teacher_grade_input_page.dart';
import 'package:flutter/material.dart';

class BottomNavGuru extends StatefulWidget {
  const BottomNavGuru({super.key});

  @override
  State<BottomNavGuru> createState() => _BottomNavGuruState();
}

class _BottomNavGuruState extends State<BottomNavGuru> {
  int index = 0;

  final pages = [
    HomePageGuruEdu(),
    TeacherGradePage(), // ⬅️ page input nilai masuk sini
    TeacherProfilePage(), // ProfileGuruPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: "Input Nilai",
          ), // ⬅️
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
