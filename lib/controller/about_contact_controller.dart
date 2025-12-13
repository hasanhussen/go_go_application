import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/profile/about_us_data.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutContactController extends GetxController {
  String appDescription = "";
  String phone = "";
  String email = "";
  String address = "";
  String facebook = "";
  String instagram = "";
  String whatsapp = "";

  //bool isLoading = true;

  StatusRequest statusRequest = StatusRequest.none;
  AboutUsData aboutUsData = AboutUsData(Get.find());

  MyServices myServices = Get.find();

  String token = "";

  @override
  void onInit() {
    super.onInit();
    fetchContactInfo();
  }

  fetchContactInfo() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await aboutUsData.getContactInfo();
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response is Map && response['error'] != null) {
        statusRequest = StatusRequest.failure;
        Get.defaultDialog(
          title: "خطأ",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.red,
          ),
          middleText: response['error'],
          middleTextStyle: const TextStyle(fontSize: 16),
          backgroundColor: Colors.white,
          radius: 12,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      // Start backend
      appDescription = response['description'] ?? "نص افتراضي عن التطبيق.";
      phone = response['phone'] ?? "+963 000000000";
      email = response['email'] ?? "support@example.com";
      address = response['address'] ?? "دمشق - سوريا";
      facebook = response['facebook'] ?? "";
      instagram = response['instagram'] ?? "";
      whatsapp = "https://wa.me/${response['whatsapp'] ?? ""}";

      // End
    } else {
      setDefaultValues();
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void setDefaultValues() {
    appDescription =
        "نحن منصة تهدف لتقديم أفضل الخدمات للمستخدمين من خلال تجربة سلسة وسهلة الاستخدام.";
    phone = "+963 987 654 321";
    email = "support@example.com";
    address = "دمشق - سوريا";
    facebook = "https://www.facebook.com/example";
    instagram = "https://www.instagram.com/example";
    whatsapp = "https://wa.me/963987654321";
  }

  void open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri,
          mode: LaunchMode
              .platformDefault); // جرب هذا بدلاً من externalApplication
    } else {
      Get.snackbar("خطأ", "لا يمكن فتح الرابط");
    }
  }

  // فتح رقم الهاتف
  Future<void> callNumber(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    await launchUrl(uri);
  }

  // إرسال إيميل
  Future<void> sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(uri);
  }

  // فتح العنوان في خرائط Google
  Future<void> openMap(String address) async {
    final Uri uri =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$address");
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
