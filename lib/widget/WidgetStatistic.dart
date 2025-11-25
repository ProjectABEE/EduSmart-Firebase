// 🔸 Widget Helper untuk Statistik
import 'package:flutter/material.dart';

Widget statCard(String value, String title, IconData icon, Color color) {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.15),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
  );
}
