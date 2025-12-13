import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword;
  void Function()? onPressed;
  final String? Function(String?) valid;
  final TextEditingController controller;
  final bool readOnly;

  CustomTextField(
      {required this.hint,
      required this.icon,
      this.isPassword = false,
      this.onPressed,
      required this.controller,
      required this.valid,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      validator: valid,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: IconButton(
          icon: Icon(icon, color: Colors.white70),
          onPressed: onPressed,
        ),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      ),
    );
  }
}
