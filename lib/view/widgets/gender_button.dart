import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  GenderButton(
      {required this.text, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        side: BorderSide(color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
