import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart'; // Sesuaikan dengan path StudentModel Anda
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  // ===================== STATE =====================
  StudentModel? _student;
  bool _isUploading = false; // State untuk mengelola status upload foto

  // Akses ke Firebase
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // ===================== GETTER =====================
  StudentModel? get student => _student;
  bool get isUploading => _isUploading;

  // ===================== FUNGSI UTAMA =====================

  /// 🔥 Load user data sekali saat login / buka aplikasi (Sudah ada)
  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      _student = null; // Clear student jika user logout
      notifyListeners();
      return;
    }

    // Ambil data dari Firestore
    final snap = await _firestore.collection("students").doc(user.uid).get();

    if (snap.exists) {
      _student = StudentModel.fromMap({"id": user.uid, ...snap.data()!});
      notifyListeners();
    }
  }

  // ===================== FUNGSI FOTO DAN PROSES =====================

  // Setter untuk mengubah status upload (dipindahkan dari ProfilePage)
  void setUploading(bool status) {
    _isUploading = status;
    notifyListeners();
  }

  /// 🔥 Update profile image ke Firestore + update UI real time (Sudah ada, diperkuat)
  void updateImageInModel(String url) {
    // Mengubah nama agar tidak bentrok dengan logika Firebase
    if (_student != null) {
      _student = _student!.copyWith(profileImage: url);
      notifyListeners();
    }
  }

  /// 📷 Upload ke Supabase + update Firestore + notify Provider (Logika Baru)
  Future<void> changePhoto(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || _student == null) {
      // Handle user not logged in
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setUploading(true); // Memanggil setter baru

    final supabase = Supabase.instance.client;
    final userId = currentUser.uid;
    final ext = file.path.split('.').last;
    final filePath = "profile/$userId.$ext";

    try {
      final bytes = await File(file.path).readAsBytes();

      // 1. Upload ke Supabase Storage
      await supabase.storage
          .from('students')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      final url = supabase.storage.from('students').getPublicUrl(filePath);

      // 2. Update Firestore (memanggil logika update Firestore yang sudah ada)
      await _firestore.collection("students").doc(userId).update({
        "profileImage": url,
      });

      // 3. Update Provider State (UI akan auto refresh)
      updateImageInModel(url);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto berhasil diperbarui 🎉")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload gagal: $e")));
    } finally {
      setUploading(false);
    }
  }
}
