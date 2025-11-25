import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  const Textfield({super.key, required this.nama, required this.controler});
  final nama;
  final controler;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: nama),
    );
  }
}
