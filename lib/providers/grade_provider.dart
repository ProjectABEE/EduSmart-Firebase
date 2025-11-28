import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:edusmart/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GradeProvider extends ChangeNotifier {
  String? _selectedSubject;
  String? _selectedStudent;

  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController scoreController = TextEditingController();

  bool _saving = false;

  List<Map<String, dynamic>>? _subjectsCache;
  List<StudentModel>? _studentsCache;

  String? get selectedSubject => _selectedSubject;
  String? get selectedStudent => _selectedStudent;
  bool get saving => _saving;

  set selectedSubject(String? val) {
    _selectedSubject = val;
    notifyListeners();
  }

  set selectedStudent(String? val) {
    _selectedStudent = val;
    notifyListeners();
  }

  void setSaving(bool status) {
    _saving = status;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    if (_subjectsCache != null) return _subjectsCache!;
    _subjectsCache = await FirebaseServices.getAllSubjects();
    return _subjectsCache!;
  }

  Future<List<StudentModel>> fetchStudents() async {
    if (_studentsCache != null) return _studentsCache!;
    _studentsCache = await FirebaseServices.getAllStudents();
    return _studentsCache!;
  }

  Future<void> saveGrades(BuildContext context) async {
    if (_selectedSubject == null ||
        _selectedStudent == null ||
        assessmentController.text.isEmpty ||
        scoreController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("⚠️ Isi semua field dulu")));
      return;
    }

    setSaving(true);

    final date = DateFormat("yyyy-MM-dd").format(DateTime.now());

    try {
      await FirebaseServices.insertGrade({
        "subject_id": _selectedSubject,
        "student_id": _selectedStudent,
        "assessment_name": assessmentController.text.trim(),
        "score": int.parse(scoreController.text.trim()),
        "date": date,
      });

      /// Reset
      assessmentController.clear();
      scoreController.clear();
      _selectedStudent = null;
      _selectedSubject = null;

      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("🎉 Nilai berhasil disimpan!"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("❌ Gagal menyimpan nilai: $e"),
        ),
      );
    } finally {
      setSaving(false);
    }
  }

  @override
  void dispose() {
    assessmentController.dispose();
    scoreController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchRecentGrades(String studentId) async {
    final result = await FirebaseFirestore.instance
        .collection("grades")
        .where("student_id", isEqualTo: studentId)
        .orderBy("date", descending: true)
        .limit(5)
        .get();

    List<Map<String, dynamic>> grades = [];

    for (var doc in result.docs) {
      final data = doc.data();
      String subjectId = data["subject_id"];

      // Ambil mapel berdasarkan subject_id
      final subjectDoc = await FirebaseFirestore.instance
          .collection("subjects")
          .doc(subjectId)
          .get();

      final subjectName = subjectDoc.exists
          ? subjectDoc["subject_name"]
          : "Unknown Subject";

      grades.add({
        "id": doc.id,
        ...data,
        "subject_name": subjectName, // ⬅️ sekarang muncul aman
      });
    }

    return grades;
  }

  Future<double> getAverageGrade(String studentId) async {
    final data = await fetchRecentGrades(studentId);

    if (data.isEmpty) return 0;

    double total = data.fold(0, (sum, g) => sum + (g["score"] as num));
    return total / data.length;
  }
}
