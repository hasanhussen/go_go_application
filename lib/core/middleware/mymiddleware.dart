import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyMiddleWare extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final MyServices services = Get.find();
    final step = services.sharedPreferences.getString("step");

    // إذا كان مسجل دخول ويحاول الذهاب لصفحة البداية، وجهه للرئيسية
    if (step == "2") {
      return const RouteSettings(name: AppRoute.homescreen);
    }
    return null;
  }
}
