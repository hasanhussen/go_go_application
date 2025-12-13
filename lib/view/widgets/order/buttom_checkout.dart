import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';
import 'package:go_go/core/constant/approute.dart';

class BottomCheckoutBar extends GetView<CartController> {
  const BottomCheckoutBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                controller.priceAfterDiscount == null
                    ? '${controller.totalPrice}'
                    : '${controller.priceAfterDiscount}',
                style: TextStyle(color: Colors.white)),
            InkWell(
              onTap: () {
                controller.gotoDetails();
              },
              child: Text("التالي",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
