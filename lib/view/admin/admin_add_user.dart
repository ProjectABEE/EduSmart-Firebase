import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/services/firebase.dart';
import 'package:flutter/material.dart';

class AdminAddUserPage extends StatefulWidget {
  const AdminAddUserPage({super.key});

  @override
  State<AdminAddUserPage> createState() => _AdminAddUserPageState();
}

class _AdminAddUserPageState extends State<AdminAddUserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  String? selectedRole;
  bool isLoading = false;

  Future<void> addUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Isi semua data yang diperlukan")));
      return;
    }

    if (selectedRole == "siswa" && classController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Kelas wajib diisi untuk siswa")));
      return;
    }

    setState(() => isLoading = true);

    try {
      final student = StudentModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: selectedRole,
        className: selectedRole == "siswa" ? classController.text.trim() : null,
      );

      await FirebaseServices.registerUser(student, "siswa123");

      nameController.clear();
      emailController.clear();
      classController.clear();
      selectedRole = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("User berhasil dibuat 🎉 Password: siswa123"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menambahkan user: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah User")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama Lengkap"),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),

            DropdownButtonFormField(
              decoration: InputDecoration(labelText: "Role"),
              initialValue: selectedRole,
              items: const [
                DropdownMenuItem(value: "siswa", child: Text("Siswa")),
                DropdownMenuItem(value: "guru", child: Text("Guru")),
                DropdownMenuItem(value: "admin", child: Text("Admin")),
              ],
              onChanged: (value) {
                setState(() => selectedRole = value);
              },
            ),

            if (selectedRole == "siswa") ...[
              SizedBox(height: 20),
              TextField(
                controller: classController,
                decoration: InputDecoration(
                  labelText: "Kelas (contoh: XI atau 12)",
                ),
              ),
            ],

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : addUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Tambah User",
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
