import 'package:go_go/core/constant/apptheme.dart';
import 'package:go_go/core/functions/fcmconfig.dart';
import 'package:go_go/core/services/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  Locale? language;

  MyServices myServices = Get.find();

  ThemeData appTheme = themeArabic;

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    myServices.sharedPreferences.setString("lang", langcode);
    appTheme = langcode == "ar" ? themeArabic : themeEnglish;
    Get.changeTheme(appTheme);
    Future.delayed(Duration(milliseconds: 180), () {
      Get.updateLocale(locale);
    });
  }

  // requestPerLocation() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Get.snackbar("تنبيه", "الرجاء تشغيل خدمو تحديد الموقع");
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Get.snackbar("تنبيه", "الرجاء اعطاء صلاحية الموقع للتطبيق");
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Get.snackbar("تنبيه", "لا يمكن استعمال التطبيق من دون اللوكيشين");
  //   }
  // }

 @override
void onInit() {
  requestPermissionNotification();
  fcmconfig();
  requestPermissions();

  String? sharedPrefLang = myServices.sharedPreferences.getString("lang");

  // اللغات المدعومة فقط
  const supportedLangs = ["ar", "en"];

  if (sharedPrefLang != null && supportedLangs.contains(sharedPrefLang)) {
    // لغة محفوظة وصحيحة
    language = Locale(sharedPrefLang);
    appTheme = sharedPrefLang == "ar" ? themeArabic : themeEnglish;
  } else {
    // لغة الجهاز
    String deviceLang = Get.deviceLocale?.languageCode ?? "en";

    // إذا مو مدعومة → إنكليزي افتراضي
    if (!supportedLangs.contains(deviceLang)) {
      deviceLang = "en";
    }

    language = Locale(deviceLang);
    appTheme = deviceLang == "ar" ? themeArabic : themeEnglish;

    // حفظها للمرة القادمة
    myServices.sharedPreferences.setString("lang", deviceLang);
  }

  super.onInit();
}

}
