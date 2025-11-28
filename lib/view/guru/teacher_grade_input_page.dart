import 'package:edusmart/providers/grade_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherGradePage extends StatelessWidget {
  const TeacherGradePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GradeProvider>();
    final providerRead = context.read<GradeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Nilai — Guru"),
        backgroundColor: const Color(0xFF256BE8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Mata Pelajaran
            FutureBuilder(
              future: providerRead.fetchSubjects(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const LinearProgressIndicator();

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
                if (!snapshot.hasData) return const LinearProgressIndicator();

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

            TextField(
              controller: provider.assessmentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nama Penilaian (UTS, UAS, Tugas...)",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: provider.scoreController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nilai (0 - 100)",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF256BE8),
                padding: const EdgeInsets.all(14),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: provider.saving
                  ? null
                  : () => providerRead.saveGrades(context),
              child: provider.saving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Simpan Nilai", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
