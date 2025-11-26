import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/view/auth/loginedu.dart';
import 'package:edusmart/view/siswa/profile/editprofile.dart';
import 'package:edusmart/widget/WidgetStatistic.dart';
import 'package:edusmart/widget/infotile.dart';
import 'package:edusmart/widget/judulW.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool uploading = false;

  /// 📷 Upload ke Supabase + update Firestore + notify Provider
  Future<void> changePhoto() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setState(() => uploading = true);

    final supabase = Supabase.instance.client;
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final ext = file.path.split('.').last;
    final filePath = "profile/$userId.$ext";

    try {
      final bytes = await File(file.path).readAsBytes();

      await supabase.storage
          .from('students')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = supabase.storage.from('students').getPublicUrl(filePath);

      await FirebaseFirestore.instance
          .collection("students")
          .doc(userId)
          .update({"profileImage": url});

      // 🔥 Provider update foto agar auto refresh UI
      if (mounted) {
        context.read<UserProvider>().updateImage(url);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto berhasil diperbarui 🎉")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload gagal: $e")));
    } finally {
      setState(() => uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = context.watch<UserProvider>().student;

    return Scaffold(
      backgroundColor: const Color(0xfff7f9fc),
      body: student == null
          ? const Center(child: CircularProgressIndicator())
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
                        GestureDetector(
                          onTap: changePhoto,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    (student.profileImage != null &&
                                        student.profileImage!.isNotEmpty)
                                    ? NetworkImage(student.profileImage!)
                                    : const AssetImage('assets/images/abe2.png')
                                          as ImageProvider,
                              ),

                              if (uploading)
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          student.name ?? "-",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          student.className ?? "-",
                          style: const TextStyle(color: Colors.white70),
                        ),

                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(student: student),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2567E8),
                          ),
                          child: const Text("Edit Profile"),
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
                  infoTile(Icons.email, student.email ?? "-", "Email"),
                  infoTile(Icons.person, student.className ?? "-", "Class"),
                  infoTile(Icons.location_on, student.alamat ?? "-", "Address"),
                  infoTile(
                    Icons.cake,
                    student.tanggalLahir ?? "-",
                    "Birth Date",
                  ),

                  const SizedBox(height: 24),

                  sectionTitle("Parent/Guardian"),
                  infoTile(Icons.person, student.namaOrtu ?? "-", "Name"),
                  infoTile(
                    Icons.phone_android,
                    student.kontakOrtu ?? "-",
                    "Contact",
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        PreferenceHandler.removeLogin();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginEdu()),
                        );
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
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
