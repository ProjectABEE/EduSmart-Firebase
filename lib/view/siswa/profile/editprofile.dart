import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/providers/user_provider.dart'; // Import Provider
import 'package:edusmart/widget/textfieldwidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; // Import Provider

class EditProfilePage extends StatefulWidget {
  final StudentModel student;

  const EditProfilePage({super.key, required this.student});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;

  late TextEditingController nameC;
  late TextEditingController classC;
  late TextEditingController ageC;
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
    classC = TextEditingController(text: s.className);
    ageC = TextEditingController(text: s.age.toString());
    telpC = TextEditingController(text: s.noTelp ?? '');
    alamatC = TextEditingController(text: s.alamat ?? '');
    tglLahirC = TextEditingController(text: s.tanggalLahir ?? '');
    namaOrtuC = TextEditingController(text: s.namaOrtu ?? '');
    kontakOrtuC = TextEditingController(text: s.kontakOrtu ?? '');
  }

  Future<void> pickDate() async {
    FocusScope.of(context).unfocus(); // hilangkan keyboard

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 3650)),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        tglLahirC.text = DateFormat("dd/MM/yyyy").format(selectedDate);
      });
    }
  }

  // --- FUNGSI UPDATE BARU ---
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    // 1. Siapkan data yang akan diupdate
    final updateData = {
      "name": nameC.text,
      "className": classC.text,
      "age": int.tryParse(ageC.text) ?? 0,
      "noTelp": telpC.text,
      "alamat": alamatC.text,
      "tanggalLahir": tglLahirC.text,
      "namaOrtu": namaOrtuC.text,
      "kontakOrtu": kontakOrtuC.text,
    };

    // 2. Panggil fungsi update dari UserProvider
    final userProvider = context.read<UserProvider>();
    await userProvider.updateProfileData(context, updateData);

    // Logika pop, SnackBar, dan update Firestore sudah ada di provider,
    // jadi tidak perlu diulang di sini.
  }
  // --- END FUNGSI UPDATE BARU ---

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2567E8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        backgroundColor: primaryColor,
      ),

      // SOLUSI: SingleChildScrollView dengan NeverScrollableScrollPhysics
      body: SingleChildScrollView(
        // Menentukan physics agar pengguna tidak bisa menggulir secara manual
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Textfield(
                  nama: "Nama Lengkap",
                  controler: nameC,
                  icon: Icons.person,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "Kelas",
                  controler: classC,
                  icon: Icons.school,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "Umur",
                  controler: ageC,
                  icon: Icons.cake,
                  keyboardType: TextInputType.number,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "No. Telepon",
                  controler: telpC,
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "Alamat",
                  controler: alamatC,
                  icon: Icons.home,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                GestureDetector(
                  onTap: pickDate,
                  child: AbsorbPointer(
                    child: Textfield(
                      nama: "Tanggal Lahir",
                      controler: tglLahirC,
                      icon: Icons.date_range,
                      validator: requiredField,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "Nama Orang Tua",
                  controler: namaOrtuC,
                  icon: Icons.family_restroom,
                  validator: requiredField,
                ),
                const SizedBox(height: 18),

                Textfield(
                  nama: "Kontak Orang Tua",
                  controler: kontakOrtuC,
                  icon: Icons.phone_in_talk,
                  validator: requiredField,
                ),

                // SizedBox di akhir untuk jarak dari bottomNavigationBar
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.save, color: Colors.white),
          onPressed: updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: const Text(
            "Simpan Perubahan",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Field ini tidak boleh kosong";
    }
    return null;
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
}
