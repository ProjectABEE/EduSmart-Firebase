import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  // Map untuk konversi Hari dari English (kunci) ke Indonesia (nilai)
  final Map<String, String> dayMap = {
    "Monday": "Senin",
    "Tuesday": "Selasa",
    "Wednesday": "Rabu",
    "Thursday": "Kamis",
    "Friday": "Jumat",
    "Saturday": "Sabtu",
  };

  // Getter untuk mengakses Map di UI
  Map<String, String> get dayMapping => dayMap;

  // Fungsi untuk mendapatkan Stream Mata Pelajaran
  // Fungsi ini kini menjadi bagian dari Provider
  Stream<QuerySnapshot> getSubjectsFor(String englishDay) {
    final firestore = FirebaseFirestore.instance;
    final indoDay = dayMap[englishDay] ?? "";

    if (indoDay.isEmpty) {
      // Mengembalikan stream kosong jika hari tidak valid
      return const Stream<QuerySnapshot>.empty();
    }

    return firestore
        .collection("subjects")
        .where("day", isEqualTo: indoDay)
        .orderBy("start_time", descending: false)
        .snapshots();
  }

  Stream<int> streamTotalSubjects() {
    return FirebaseFirestore.instance
        .collection("subjects")
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
