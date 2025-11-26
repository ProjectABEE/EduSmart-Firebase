import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  const Textfield({
    super.key,
    required this.nama,
    required this.controler,
    this.keyboardType,
    this.icon,
    this.validator,
    this.onTap,
    this.readOnly = false,
  });

  final String nama;
  final TextEditingController controler;
  final TextInputType? keyboardType;
  final IconData? icon;

  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2567E8);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controler,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
          labelText: nama,
          labelStyle: TextStyle(
            color: primaryColor.withOpacity(0.7),
            fontSize: 14,
          ),
          hintText: nama,
          hintStyle: TextStyle(color: Colors.grey.shade400),

          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),

          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
