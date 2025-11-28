import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  Future<Map<String, List<Map<String, dynamic>>>> fetchGrades() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final gradeSnapshot = await FirebaseFirestore.instance
        .collection("grades")
        .where("student_id", isEqualTo: user.uid)
        .orderBy("date", descending: true)
        .get();

    final subjectSnapshot = await FirebaseFirestore.instance
        .collection("subjects")
        .get();

    // mapping: subject_id → subject_name
    Map<String, String> subjectMap = {
      for (var doc in subjectSnapshot.docs) doc.id: doc['subject_name'],
    };

    Map<String, List<Map<String, dynamic>>> groupedData = {};

    for (var gradeDoc in gradeSnapshot.docs) {
      final grade = gradeDoc.data();

      final subjectName =
          subjectMap[grade['subject_id']] ?? "Unknown Subject"; // FIX HERE

      groupedData.putIfAbsent(subjectName, () => []);
      groupedData[subjectName]!.add(grade);
    }

    return groupedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              height: 100,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Color(0XFF2567E8),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Grades",
                  style: TextStyle(fontSize: 28, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),

            FutureBuilder(
              future: fetchGrades(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(50),
                    child: CircularProgressIndicator(),
                  );
                }

                final grades = snapshot.data!;

                if (grades.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(50),
                    child: Text(
                      "Belum ada nilai 😢",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: grades.entries.map((entry) {
                    final subjectName = entry.key;
                    final subjectGrades = entry.value;

                    final average =
                        subjectGrades
                            .map((e) => e['score'] as num)
                            .reduce((a, b) => a + b) /
                        subjectGrades.length;

                    final highest = subjectGrades
                        .map((e) => e['score'])
                        .reduce((a, b) => a > b ? a : b);

                    final lowest = subjectGrades
                        .map((e) => e['score'])
                        .reduce((a, b) => a < b ? a : b);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 15,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // 1. Average Score Container
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  average.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),

                              // 🎯 SOLUSI: Bungkus Column dengan Expanded agar mengambil sisa ruang
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      subjectName,
                                      overflow: TextOverflow.ellipsis,
                                      // Hilangkan overflow: TextOverflow.ellipsis dari style
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Tests: ${subjectGrades.length}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),

                              // Hapus Spacer() karena Expanded sudah mengisi sisa ruang
                              // Spacer(), // <--- DIHAPUS

                              // 3. Min/Max Container
                              Container(
                                constraints: BoxConstraints(maxWidth: 110),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Min: $lowest | Max: $highest",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: average / 100,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.black87,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Column(
                            children: subjectGrades.map((g) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(g["assessment_name"]),
                                subtitle: Text(g["date"]),
                                trailing: Text(
                                  g["score"].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
