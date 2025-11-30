import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edusmart/model/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  StudentModel? _student;
  bool _isUploading = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  StudentModel? get student => _student;
  bool get isUploading => _isUploading;

  Future<void> fetchUser() async {
    final user = _auth.currentUser;
    if (user == null) {
      _student = null;
      notifyListeners();
      return;
    }

    final snap = await _firestore.collection("students").doc(user.uid).get();

    if (snap.exists) {
      _student = StudentModel.fromMap({"id": user.uid, ...snap.data()!});
      notifyListeners();
    }
  }

  void setUploading(bool status) {
    _isUploading = status;
    notifyListeners();
  }

  void updateImageInModel(String url) {
    if (_student != null) {
      _student = _student!.copyWith(profileImage: url);
      notifyListeners();
    }
  }

  // --- FUNGSI BARU UNTUK UPDATE PROFIL ---
  Future<void> updateProfileData(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || _student == null) {
      return;
    }

    try {
      // setUploading(true); // Opsional: Aktifkan jika mau ada loading global

      await _firestore.collection("students").doc(currentUser.uid).update(data);

      // Perbarui model lokal di Provider menggunakan copyWith
      _student = _student!.copyWith(
        name: data['name'],
        className: data['className'],
        age: data['age'],
        noTelp: data['noTelp'],
        alamat: data['alamat'],
        tanggalLahir: data['tanggalLahir'],
        namaOrtu: data['namaOrtu'],
        kontakOrtu: data['kontakOrtu'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profil berhasil diperbarui ✔️"),
          backgroundColor: Colors.green.shade600,
        ),
      );

      notifyListeners();
      // Memberi sinyal 'true' ke halaman ProfilePage bahwa update berhasil
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Pembaruan gagal: $e")));
      Navigator.pop(context, false);
    } finally {
      // setUploading(false); // Opsional
    }
  }
  // --- END FUNGSI BARU ---

  Future<void> changePhoto(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || _student == null) {
      return;
    }

    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    setUploading(true);

    final supabase = Supabase.instance.client;
    final userId = currentUser.uid;
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

      await _firestore.collection("students").doc(userId).update({
        "profileImage": url,
      });

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
