import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTextFormField({
  required TextEditingController controller,
  required String labelText,
  required TextInputType keyboardType,
  required String? Function(String?) validator,
  required IconData icon,
  required Color iconColor,
  bool obscureText = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: iconColor),
      ),
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
    ),
  );
}
