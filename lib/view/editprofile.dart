import 'package:edusmart/database/db_helper.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/widget/textfieldwidget.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final StudentModel student;

  const EditProfilePage({super.key, required this.student});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameC;
  late TextEditingController emailC;
  late TextEditingController classC;
  late TextEditingController ageC;
  late TextEditingController passwordC;
  late TextEditingController telpC;
  late TextEditingController alamatC;
  late TextEditingController tglLahirC;
  late TextEditingController namaOrtuC;
  late TextEditingController kontakOrtuC;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nameC = TextEditingController(text: s.name);
    emailC = TextEditingController(text: s.email);
    classC = TextEditingController(text: s.classs);
    ageC = TextEditingController(text: s.age.toString());
    passwordC = TextEditingController(text: s.password);
    telpC = TextEditingController(text: s.noTelp ?? '');
    alamatC = TextEditingController(text: s.alamat ?? '');
    tglLahirC = TextEditingController(text: s.tanggalLahir ?? '');
    namaOrtuC = TextEditingController(text: s.namaOrtu ?? '');
    kontakOrtuC = TextEditingController(text: s.kontakOrtu ?? '');
  }

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    classC.dispose();
    ageC.dispose();
    passwordC.dispose();
    telpC.dispose();
    alamatC.dispose();
    tglLahirC.dispose();
    namaOrtuC.dispose();
    kontakOrtuC.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    final updated = StudentModel(
      id: widget.student.id,
      name: nameC.text,
      email: emailC.text,
      classs: classC.text,
      age: int.tryParse(ageC.text) ?? 0,
      password: passwordC.text,
      noTelp: telpC.text,
      alamat: alamatC.text,
      tanggalLahir: tglLahirC.text,
      namaOrtu: namaOrtuC.text,
      kontakOrtu: kontakOrtuC.text,
    );

    await DbHelper.updateStudent(updated);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui!')),
      );
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF2567E8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Textfield(nama: "Nama Lengkap", controler: nameC),
            const SizedBox(height: 12),
            Textfield(nama: "Email", controler: emailC),
            const SizedBox(height: 12),
            Textfield(nama: "Kelas", controler: classC),
            const SizedBox(height: 12),
            Textfield(nama: "Umur", controler: ageC),
            const SizedBox(height: 12),
            Textfield(nama: "Password", controler: passwordC),
            const SizedBox(height: 12),
            Textfield(nama: "No. Telepon", controler: telpC),
            const SizedBox(height: 12),
            Textfield(nama: "Alamat", controler: alamatC),
            const SizedBox(height: 12),
            Textfield(nama: "Tanggal Lahir", controler: tglLahirC),
            const SizedBox(height: 12),
            Textfield(nama: "Nama Orang Tua", controler: namaOrtuC),
            const SizedBox(height: 12),
            Textfield(nama: "Kontak Orang Tua", controler: kontakOrtuC),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: updateProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2567E8),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.save),
              label: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}
