import 'package:edusmart/providers/grade_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherGradePage extends StatelessWidget {
  const TeacherGradePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan final color untuk konsistensi
    const primaryColor = Color(0XFF256BE8);
    final provider = context.watch<GradeProvider>();
    final providerRead = context.read<GradeProvider>();

    return Scaffold(
      // Hapus AppBar dan ganti dengan Custom Header di Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header (Menggantikan AppBar)
            Container(
              height: 100,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: primaryColor, // Gunakan warna yang sama
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Align(
                alignment:
                    Alignment.bottomLeft, // Sesuaikan alignment jika perlu
                child: Text(
                  "Input Nilai",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),

            // Konten Form Input
            Padding(
              padding: const EdgeInsets.all(20), // Tambah padding simetris
              child: Column(
                children: [
                  /// Mata Pelajaran
                  FutureBuilder(
                    future: providerRead.fetchSubjects(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const LinearProgressIndicator();

                      final subjects = snapshot.data!;
                      return DropdownButtonFormField<String>(
                        initialValue: provider.selectedSubject,
                        decoration: const InputDecoration(
                          labelText: "Pilih Mata Pelajaran",
                          border: OutlineInputBorder(),
                        ),
                        items: subjects.map<DropdownMenuItem<String>>((e) {
                          return DropdownMenuItem<String>(
                            value: e["id"] as String,
                            child: Text(e["subject_name"]),
                          );
                        }).toList(),
                        onChanged: (value) => provider.selectedSubject = value,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Pilih Siswa
                  FutureBuilder(
                    future: providerRead.fetchStudents(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const LinearProgressIndicator();

                      final students = snapshot.data!;
                      return DropdownButtonFormField(
                        initialValue: provider.selectedStudent,
                        decoration: const InputDecoration(
                          labelText: "Pilih Siswa",
                          border: OutlineInputBorder(),
                        ),
                        items: students.map((s) {
                          return DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name ?? "-"),
                          );
                        }).toList(),
                        onChanged: (value) => provider.selectedStudent = value,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Input Nama Penilaian
                  TextField(
                    controller: provider.assessmentController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nama Penilaian (UTS, UAS, Tugas...)",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Input Nilai
                  TextField(
                    controller: provider.scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nilai (0 - 100)",
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tombol Simpan Nilai (Gaya baru)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Gunakan warna primer yang konsisten
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white, // Teks putih
                      padding: const EdgeInsets.all(14),
                      minimumSize: const Size(double.infinity, 50),
                      // Tambahkan BorderRadius agar konsisten dengan desain modern
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: provider.saving
                        ? null
                        : () => providerRead.saveGrades(context),
                    child: provider.saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Simpan Nilai",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ), // Perbesar dan tebalkan sedikit
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
