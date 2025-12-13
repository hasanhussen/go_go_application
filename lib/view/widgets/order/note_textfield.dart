import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';

class NoteTextField extends GetView<CartController> {
  const NoteTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: TextField(
          controller: controller.noteController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: "اكتب تفاصيل إضافية",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
