import 'package:edusmart/preferences/preferences_handler.dart';
import 'package:edusmart/providers/grade_provider.dart';
import 'package:edusmart/providers/schedule_provider.dart';
import 'package:edusmart/view/auth/loginedu.dart';
import 'package:edusmart/view/siswa/profile/editprofile.dart';
import 'package:edusmart/widget/WidgetStatistic.dart';
import 'package:edusmart/widget/infotile.dart';
import 'package:edusmart/widget/judulW.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

// Diubah menjadi StatelessWidget
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Fungsi Logout dipisah agar ProfilePage tetap bersih
  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    PreferenceHandler.removeLogin();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginEdu()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch UserProvider untuk data student dan status uploading
    final userProvider = context.watch<UserProvider>();
    final student = userProvider.student;

    // Read UserProvider untuk memanggil fungsi (tanpa listen/rebuild)
    final userProviderRead = context.read<UserProvider>();

    // Status uploading yang diambil dari Provider
    final uploading = userProvider.isUploading;

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
                          // Panggil fungsi Provider (changePhoto)
                          onTap: uploading
                              ? null
                              : () => userProviderRead.changePhoto(context),
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

                              // Menggunakan state uploading dari Provider
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
                  // ... (Bagian statistik tetap sama)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // statCard(
                        //   "92%",
                        //   "Attendance",
                        //   Icons.calendar_today,
                        //   Colors.blue,
                        // ),
                        Consumer2<GradeProvider, UserProvider>(
                          builder: (context, gradeProvider, userProvider, _) {
                            final student = userProvider.student;
                            if (student == null) return SizedBox();

                            return FutureBuilder<double>(
                              future: gradeProvider.getAverageGrade(
                                student.id!,
                              ),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return statCard(
                                    "--", // sementara
                                    "Avg Grade",
                                    Icons.star,
                                    Colors.orange,
                                  );
                                }

                                final avg = snapshot.data!.toStringAsFixed(1);

                                return statCard(
                                  avg, // ⬅️ sekarang dynamic!
                                  "Avg Grade",
                                  Icons.star,
                                  Colors.orange,
                                );
                              },
                            );
                          },
                        ),
                        Consumer<ScheduleProvider>(
                          builder: (context, provider, _) {
                            return StreamBuilder<int>(
                              stream: provider.streamTotalSubjects(),
                              builder: (context, snapshot) {
                                final count = snapshot.hasData
                                    ? snapshot.data.toString()
                                    : "--";

                                return statCard(
                                  count,
                                  "Courses",
                                  Icons.book,
                                  Colors.purple,
                                );
                              },
                            );
                          },
                        ),

                        //statCard("8", "Courses", Icons.book, Colors.purple),
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
                      // Panggil fungsi logout lokal
                      onPressed: () => _logout(context),
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
