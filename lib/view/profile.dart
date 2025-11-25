import 'package:edusmart/database/db_helper.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/EditProfile.dart';
import 'package:edusmart/view/loginedu.dart';
import 'package:edusmart/widget/WidgetStatistic.dart';
import 'package:edusmart/widget/infotile.dart';
import 'package:edusmart/widget/judulW.dart';
import 'package:edusmart/widget/menu.dart';
import 'package:edusmart/widget/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  StudentModel? student;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email'); // ambil email user login

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
  Widget build(BuildContext context) {
    Future<void> onEdit(StudentModel student) async {
      final editNameC = TextEditingController(text: student.name);
      final editAgeC = TextEditingController(text: student.age.toString());
      final editClasssC = TextEditingController(text: student.classs);
      final editEmailC = TextEditingController(text: student.email);
      final editPassC = TextEditingController(text: student.password);
      final res = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Edit Data"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Textfield(nama: "Name", controler: editNameC),
                Textfield(nama: "Email", controler: editEmailC),
                Textfield(nama: "Age", controler: editAgeC),
                Textfield(nama: "Classs", controler: editClasssC),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Batal"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text("Simpan"),
              ),
            ],
          );
        },
      );

      if (res == true) {
        final updated = StudentModel(
          id: student.id,
          name: editNameC.text,
          email: editEmailC.text,
          classs: editClasssC.text,
          age: int.parse(editAgeC.text),
          password: editPassC.text,
        );
        DbHelper.updateStudent(updated);
        getData();
        ScaffoldMessenger(child: Text("data berhasil di perbarui"));
      }
    }

    // Future<void> onDelete(StudentModel student) async {
    //   final res = await showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text("Hapus Data"),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           spacing: 12,
    //           children: [
    //             Text(
    //               "Apakah anda yakin ingin menghapus data ${student.name}?",
    //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //             ),
    //           ],
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: Text("Jangan"),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context, true);
    //             },
    //             child: Text("Ya, hapus aja"),
    //           ),
    //         ],
    //       );
    //     },
    //   );

    //   if (res == true) {
    //     DbHelper.deleteStudent(student.id!);
    //     getData();
    //     ScaffoldMessenger(child: Text("data berhasil di hapus"));
    //   }
    // }

    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage(
                      'assets/images/abe2.png',
                    ), // ganti path asset kamu
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    student?.name ?? '-',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Class ${student?.classs ?? '-'}",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: student == null ? null : () => onEdit(student!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2567E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Edit Profile"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 3 Statistik (Attendance, Grade, Courses)
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
                    "Average Grade",
                    Icons.bar_chart,
                    Colors.green,
                  ),
                  statCard("8", "Courses", Icons.book, Colors.purple),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Personal Information
            sectionTitle("Personal Information"),
            infoTile(Icons.email, student?.email ?? '-', "Email"),
            infoTile(Icons.phone, student?.noTelp ?? '-', "Phone"),
            infoTile(Icons.location_on, student?.alamat ?? '-', "Address"),
            infoTile(Icons.cake, student?.tanggalLahir ?? '-', "Birth Date"),

            const SizedBox(height: 24),

            // 🔹 Parent/Guardian
            sectionTitle("Parent/Guardian"),
            infoTile(Icons.person, student?.namaOrtu ?? '-', "Name"),
            infoTile(
              Icons.phone_android,
              student?.kontakOrtu ?? '-',
              "Contact",
            ),

            const SizedBox(height: 24),

            // 🔹 Settings / Logout
            MenuItemWidget(
              icon: Icons.edit,
              title: "Edit Profile",
              route: student == null
                  ? null
                  : EditProfilePage(student: student!),
              onReturn: () => getData(),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextButton(
                onPressed: () {
                  PreferenceHandler.removeLogin();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginEdu()),
                    (route) => false,
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 14),
                    Text("Logout", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
