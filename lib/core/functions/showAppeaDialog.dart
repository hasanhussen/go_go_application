// 🧠 Dialog الاعتراض
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/meal_trash_controller.dart';
import 'package:go_go/controller/my_stores_controller.dart';

void showAppealDialog(BuildContext context,
    {MyStoresController? controller,
    int? storeId,
    MealTrashController? mealController,
    int? mealId}) {
  final TextEditingController reasonController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "تقديم اعتراض",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "يرجى كتابة سبب اعتراضك على الحذف أو الرفض:",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "اكتب السبب هنا...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                Get.snackbar("تنبيه", "يرجى إدخال سبب الاعتراض",
                    backgroundColor: Colors.red.shade100,
                    colorText: Colors.red.shade700);
              } else {
                Get.back();
                if (mealController != null && mealId != null) {
                  mealController.sendAppeal(
                      mealId, reasonController.text.trim());
                } else if (controller != null && storeId != null) {
                  controller.sendAppeal(storeId, reasonController.text.trim());
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("إرسال", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
