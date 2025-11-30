import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  final Map<String, String> dayMap = {
    "Monday": "Senin",
    "Tuesday": "Selasa",
    "Wednesday": "Rabu",
    "Thursday": "Kamis",
    "Friday": "Jumat",
    "Saturday": "Sabtu",
  };

  Map<String, String> get dayMapping => dayMap;

  Stream<QuerySnapshot> getSubjectsFor(String englishDay) {
    final firestore = FirebaseFirestore.instance;
    final indoDay = dayMap[englishDay] ?? "";

    if (indoDay.isEmpty) {
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
