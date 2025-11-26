import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/student_model.dart';

class UserProvider with ChangeNotifier {
  StudentModel? _student;
  StudentModel? get student => _student;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // 🔥 Load user data sekali saat login / buka aplikasi
  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snap = await _firestore.collection("students").doc(user.uid).get();

    if (snap.exists) {
      _student = StudentModel.fromMap({"id": user.uid, ...snap.data()!});
      notifyListeners();
    }
  }

  // 🔥 Update profile image ke Firestore + update UI real time
  Future<void> updateImage(String url) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection("students").doc(user.uid).update({
      "profileImage": url,
    });

    if (_student != null) {
      _student = _student!.copyWith(profileImage: url);
      notifyListeners();
    }
  }
}
