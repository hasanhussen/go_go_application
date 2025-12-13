import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  final MyServices myServices = Get.find();

  @override
  RouteSettings? redirect(String? route) {
    final step = myServices.sharedPreferences.getString("step");
    final status = myServices.sharedPreferences.getString("status");

    // ✅ حساب مفعّل وواصل للخطوة الثانية
    if (step == "2" && status == "1") {
      return const RouteSettings(name: AppRoute.homescreen);
    }

    // ⚠️ الحساب بانتظار الموافقة
    if (status == "0") {
      return const RouteSettings(name: AppRoute.login);
    }

    // 🚫 الحساب محظور
    if (status == "2") {
      return const RouteSettings(name: AppRoute.login);
    }

    if (status == "3") {
      return const RouteSettings(name: AppRoute.deletedAccountScreen);
    }

    if (status == "3") {
      return const RouteSettings(name: AppRoute.login);
    }

    // 🧭 إذا المستخدم بعده بالخطوة الأولى
    if (step == "1") {
      return const RouteSettings(name: AppRoute.login);
    }

    return null;
  }
}
