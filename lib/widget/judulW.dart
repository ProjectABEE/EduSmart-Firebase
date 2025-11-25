// 🔸 Widget untuk Judul Section
import 'package:flutter/widgets.dart';

Widget sectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
