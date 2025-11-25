import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/absen_model.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseServices {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const studentsCollection = "students";
  static const subjectsCollection = "subjects";
  static const gradesCollection = "grades";
  static const attendanceCollection = "attendance";

  // ================= AUTH =================

  static Future<StudentModel> registerUser(
    StudentModel user,
    String password,
  ) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: user.email!,
      password: password,
    );

    final firebaseUser = cred.user!;
    user = user.copyWith(id: firebaseUser.uid);

    await firestore
        .collection(studentsCollection)
        .doc(firebaseUser.uid)
        .set(user.toMap());

    return user;
  }

  static Future<StudentModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user == null) return null;

      // Ambil dokumen user dari firestore
      final snapshot = await firestore
          .collection("students")
          .doc(user.uid)
          .get();

      if (!snapshot.exists) return null;

      return StudentModel.fromMap({"id": user.uid, ...snapshot.data()!});
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password" || e.code == "user-not-found") {
        return null;
      }
      rethrow;
    }
  }

  // ================= CRUD STUDENT =================

  static Future<List<StudentModel>> getAllStudents() async {
    final result = await firestore.collection(studentsCollection).get();
    return result.docs
        .map((doc) => StudentModel.fromMap({"id": doc.id, ...doc.data()}))
        .toList();
  }

  static Future<void> updateStudent(StudentModel student) async {
    await firestore
        .collection(studentsCollection)
        .doc(student.id.toString())
        .update(student.toMap());
  }

  static Future<void> deleteStudent(String id) async {
    await firestore.collection(studentsCollection).doc(id).delete();
  }

  static Future<StudentModel?> getStudentByName(String name) async {
    final result = await firestore
        .collection(studentsCollection)
        .where("name", isEqualTo: name)
        .get();

    if (result.docs.isNotEmpty) {
      return StudentModel.fromMap({
        "id": result.docs.first.id,
        ...result.docs.first.data(),
      });
    }
    return null;
  }

  // ================= CRUD SUBJECTS =================

  static Future<void> insertSubject(Map<String, dynamic> subject) async {
    await firestore.collection(subjectsCollection).add(subject);
  }

  static Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final result = await firestore.collection(subjectsCollection).get();
    return result.docs.map((e) => {"id": e.id, ...e.data()}).toList();
  }

  static Future<void> updateSubject(
    String id,
    Map<String, dynamic> subject,
  ) async {
    await firestore.collection(subjectsCollection).doc(id).update(subject);
  }

  static Future<void> deleteSubject(String id) async {
    await firestore.collection(subjectsCollection).doc(id).delete();
  }

  // ================= CRUD GRADES =================

  static Future<void> insertGrade(Map<String, dynamic> grade) async {
    await firestore.collection(gradesCollection).add(grade);
  }

  static Future<List<Map<String, dynamic>>> getGradesByStudent(
    String studentId,
  ) async {
    final result = await firestore
        .collection(gradesCollection)
        .where("student_id", isEqualTo: studentId)
        .get();

    return result.docs.map((e) => {"id": e.id, ...e.data()}).toList();
  }

  static Future<void> updateGrade(String id, Map<String, dynamic> grade) async {
    await firestore.collection(gradesCollection).doc(id).update(grade);
  }

  static Future<void> deleteGrade(String id) async {
    await firestore.collection(gradesCollection).doc(id).delete();
  }

  // ================= CRUD ATTENDANCE =================

  static Future<String> insertAttendance(AttendanceModel attendance) async {
    final ref = await firestore
        .collection(attendanceCollection)
        .add(attendance.toMap());
    return ref.id;
  }

  static Future<void> updateAttendanceCheckout(
    String docId,
    String checkOut,
  ) async {
    await firestore.collection(attendanceCollection).doc(docId).update({
      "check_out": checkOut,
    });
  }

  static Future<List<AttendanceModel>> getAttendance(String studentId) async {
    final result = await firestore
        .collection(attendanceCollection)
        .where("student_id", isEqualTo: studentId)
        .orderBy("date", descending: true)
        .get();

    return result.docs.map((doc) {
      return AttendanceModel.fromMap({"id": doc.id, ...doc.data()});
    }).toList();
  }

  static Future<void> deleteAttendance(String id) async {
    await firestore.collection(attendanceCollection).doc(id).delete();
  }

  // ================= GET USER FROM PREFS (Optional) =================

  static Future<StudentModel?> getStudentFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email == null) return null;

    final result = await firestore
        .collection(studentsCollection)
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      return StudentModel.fromMap({
        "id": result.docs.first.id,
        ...result.docs.first.data(),
      });
    }
    return null;
  }
}
