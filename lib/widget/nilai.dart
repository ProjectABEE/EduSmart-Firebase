import 'package:flutter/material.dart';

class GradeTile extends StatelessWidget {
  final String subject;
  final int score;
  final Color color;
  final int change;

  const GradeTile({
    super.key,
    required this.subject,
    required this.score,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUp = change > 0;
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Kotak warna nilai
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              "$score",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nama + progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation(Colors.black87),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Perubahan naik/turun
          Row(
            children: [
              Icon(
                isUp ? Icons.trending_up : Icons.trending_down,
                color: isUp ? Colors.green : Colors.red,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                "${isUp ? '+' : ''}$change",
                style: TextStyle(
                  color: isUp ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
