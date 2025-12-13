import 'package:flutter/material.dart';
import 'package:go_go/core/constant/color.dart';

class CustomButtonCoupon extends StatelessWidget {
  final String? textbutton;
  final void Function()? onPressed;
  const CustomButtonCoupon({Key? key, required this.textbutton, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: MaterialButton(
        color: AppColor.primaryColor,
        textColor: Colors.white,
        onPressed: onPressed,
        child: textbutton != null
            ? Text(textbutton!,
                style: const TextStyle(fontWeight: FontWeight.bold))
            : SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
