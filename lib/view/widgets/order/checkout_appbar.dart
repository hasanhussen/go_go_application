import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';

class CheckoutAppBar extends GetView<CartController> {
  const CheckoutAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => controller.gotoBack(),
                  icon: const Icon(Icons.arrow_back_ios,
                      size: 18, color: Colors.red),
                ),
                // const Text("طلب جديد", style: TextStyle(color: Colors.red, fontSize: 14)),
              ],
            ),
            Text(
              "السلة الشرائية",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
