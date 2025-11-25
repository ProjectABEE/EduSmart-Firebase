import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/widget/textfieldwidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final StudentModel student;

  const EditProfilePage({super.key, required this.student});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameC;
  late TextEditingController classC;
  late TextEditingController ageC;
  late TextEditingController telpC;
  late TextEditingController alamatC;
  late TextEditingController tglLahirC;
  late TextEditingController namaOrtuC;
  late TextEditingController kontakOrtuC;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nameC = TextEditingController(text: s.name);
    classC = TextEditingController(text: s.className);
    ageC = TextEditingController(text: s.age.toString());
    telpC = TextEditingController(text: s.noTelp ?? '');
    alamatC = TextEditingController(text: s.alamat ?? '');
    tglLahirC = TextEditingController(text: s.tanggalLahir ?? '');
    namaOrtuC = TextEditingController(text: s.namaOrtu ?? '');
    kontakOrtuC = TextEditingController(text: s.kontakOrtu ?? '');
  }

  Future<void> updateProfile() async {
    await firestore.collection("students").doc(widget.student.id).update({
      "name": nameC.text,
      "className": classC.text,
      "age": int.tryParse(ageC.text) ?? 0,
      "noTelp": telpC.text,
      "alamat": alamatC.text,
      "tanggalLahir": tglLahirC.text,
      "namaOrtu": namaOrtuC.text,
      "kontakOrtu": kontakOrtuC.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diperbarui ✔️")),
    );

    /// kirim data baru ke halaman sebelumnya
    Navigator.pop(
      context,
      widget.student.copyWith(
        name: nameC.text,
        className: classC.text,
        age: int.tryParse(ageC.text) ?? 0,
        noTelp: telpC.text,
        alamat: alamatC.text,
        tanggalLahir: tglLahirC.text,
        namaOrtu: namaOrtuC.text,
        kontakOrtu: kontakOrtuC.text,
      ),
    );
  }

  @override
  void dispose() {
    nameC.dispose();
    classC.dispose();
    ageC.dispose();
    telpC.dispose();
    alamatC.dispose();
    tglLahirC.dispose();
    namaOrtuC.dispose();
    kontakOrtuC.dispose();
    super.dispose();
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
            Textfield(nama: "Kelas", controler: classC),
            const SizedBox(height: 12),
            Textfield(nama: "Umur", controler: ageC),
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
