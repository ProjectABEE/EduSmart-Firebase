import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/view/editprofile.dart';
import 'package:edusmart/view/loginedu.dart';
import 'package:edusmart/widget/WidgetStatistic.dart';
import 'package:edusmart/widget/infotile.dart';
import 'package:edusmart/widget/judulW.dart';
import 'package:edusmart/widget/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StudentModel? student;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  /// 🔥 Ambil data student berdasarkan UID Firestore
  Future<void> loadUser() async {
    final user = auth.currentUser;
    if (user == null) return;

    final snap = await firestore.collection("students").doc(user.uid).get();

    if (snap.exists) {
      setState(() {
        student = StudentModel.fromMap({"id": user.uid, ...snap.data()!});
      });
    }
  }

  /// 🔧 Update profile ke Firebase
  Future<void> onEdit(StudentModel student) async {
    final nameC = TextEditingController(text: student.name);
    final classC = TextEditingController(text: student.className);
    final ageC = TextEditingController(text: student.age.toString());

    final res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              TextField(
                controller: nameC,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: ageC,
                decoration: InputDecoration(labelText: "Age"),
              ),
              TextField(
                controller: classC,
                decoration: InputDecoration(labelText: "Class"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Save"),
            ),
          ],
        );
      },
    );

    if (res == true) {
      await firestore.collection("students").doc(student.id).update({
        "name": nameC.text,
        "age": int.tryParse(ageC.text) ?? student.age,
        "class_name": classC.text,
      });

      loadUser();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: student == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2567E8),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage('assets/images/abe2.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          student?.name ?? "-",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student?.className ?? "-",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => onEdit(student!),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color(0xFF2567E8),
                          ),
                          child: Text("Edit Profile"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔹 Stats Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statCard(
                          "92%",
                          "Attendance",
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                        statCard(
                          "89.5",
                          "Avg Grade",
                          Icons.star,
                          Colors.orange,
                        ),
                        statCard("8", "Courses", Icons.book, Colors.purple),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  sectionTitle("Personal Info"),
                  infoTile(Icons.email, student?.email ?? '-', "Email"),
                  infoTile(Icons.person, student?.className ?? '-', "Class"),

                  const SizedBox(height: 24),

                  MenuItemWidget(
                    icon: Icons.edit,
                    title: "Edit Profile",
                    route: EditProfilePage(student: student!),
                    onReturn: () => loadUser(),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginEdu()),
                          (_) => false,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text("Logout", style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30),
                ],
              ),
            ),
    );
  }
}
