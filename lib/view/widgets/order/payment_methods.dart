// widgets/order/payment_methods.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart/cart_controller.dart';

class PaymentMethods extends GetView<CartController> {
  const PaymentMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Text("طريقة الدفع", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 22,
              children: [
                // const SizedBox(width: 30),

                paymentOption('card', Icons.credit_card,
                    selected:
                        controller.paymentMethod == 'card' ? true : false),
                paymentOption('cash', Icons.money,
                    selected:
                        controller.paymentMethod == 'cash' ? true : false),
                // const SizedBox(width: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentOption(String label, IconData icon, {bool selected = false}) {
    return InkWell(
      onTap: () {
        controller.changePaymentMethod(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffffeded) : const Color(0xfff9f6fa),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
