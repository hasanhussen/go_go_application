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
  final MyServices services = Get.find();

  // ⏳ استنى تحميل الحالة
  if (!services.statusLoaded) {
    return null; // خلي المستخدم على Welcome
  }

  final step = services.sharedPreferences.getString("step");
  final status = services.sharedPreferences.getString("status");

  if (status == "error_auth" || status == "offline") {
    return const RouteSettings(name: AppRoute.login);
  }

  if (status == "3") {
    return const RouteSettings(name: AppRoute.deletedAccountScreen);
  }

  if (status == "0" || status == "2" || status == "4") {
    return const RouteSettings(name: AppRoute.login);
  }

  if (step == "2" && status == "1") {
    return const RouteSettings(name: AppRoute.homescreen);
  }

  return const RouteSettings(name: AppRoute.login);
}

}
