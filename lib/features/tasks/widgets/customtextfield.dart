import 'package:flutter/material.dart';

Widget buildTextField(
    TextEditingController controller, String hint, bool isBold,
    {int maxLines = 1}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    style: TextStyle(
      color: Colors.white,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: 16,
    ),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
