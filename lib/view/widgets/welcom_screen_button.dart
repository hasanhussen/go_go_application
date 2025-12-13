import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WelcomButton extends StatelessWidget {
  void Function()? onPressed;
  final String text;
  final Color color;
  final Color textColor;

  WelcomButton({
    required this.onPressed,
    required this.text,
    this.color = Colors.black,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icon(icon, color: textColor),
            // SizedBox(width: 10),
            Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
