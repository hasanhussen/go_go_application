import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeletedAccountScreen extends StatelessWidget {
  const DeletedAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.block,
                color: Colors.red,
                size: 100,
              ),
              const SizedBox(height: 24),
              Text(
                'حسابك محذوف',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'تم حذف حسابك. إذا كنت تعتقد أن هذا خطأ، يرجى التواصل مع الدعم.',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // ممكن ترجع المستخدم لشاشة تسجيل الدخول أو صفحة الدعم
                  Get.offAllNamed('/login'); // مثال على الرجوع للـ login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'العودة لتسجيل الدخول',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
