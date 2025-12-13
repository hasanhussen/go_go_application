import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/resruant_profile_controller.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResturantProfileController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD2F6E6), // تحسين اللون الأخضر
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Text("78".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          title: Text("${"79".tr} ${controller.couponCode}", style: const TextStyle(color: Colors.green)),
          trailing: const Icon(Icons.card_giftcard, color: Colors.green),
        ),
      ),
    );
  }
}
