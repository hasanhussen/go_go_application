import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/core/services/services.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _startLogic();
  }

  void _startLogic() async {
    MyServices services = Get.find();

    // 1. تنفيذ جلب البيانات والانتظار
    await services.checkApiData();

    // 2. قراءة القيم بعد التحديث
    final step = services.sharedPreferences.getString("step");
    final status = services.sharedPreferences.getString("status");
    final token = services.sharedPreferences.getString("token") ?? "";

    // 3. منطق التوجيه (Navigation Logic)
    if (token.isEmpty) {
      Get.offAllNamed("/welcome"); // أو صفحة الـ Welcome
    } else if (status == "3") {
      Get.offAllNamed(AppRoute.deletedAccountScreen);
    } else if (status == "error_auth" || status == "offline") {
      Get.offAllNamed('/welcome');
    } else if (status == "1" && step == "2") {
      Get.offAllNamed(AppRoute.homescreen);
    } else {
      Get.offAllNamed('/welcome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ضع هنا لوغو التطبيق الخاص بك
            Image.asset(
              AppImageAsset.logo, // استبدلها بشعارك
              height: 120,
            ),
            SizedBox(height: 25),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
