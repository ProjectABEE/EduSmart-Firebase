import 'package:flutter/material.dart';

class DayBox extends StatelessWidget {
  final String day;
  final bool checked;
  const DayBox({super.key, required this.day, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: checked ? const Color(0xff22c55e) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            checked ? Icons.check : Icons.check,
            color: checked ? Colors.white : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          day,
          style: TextStyle(
            color: checked ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
