import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: Colors.blue)),
    );
  }
}
