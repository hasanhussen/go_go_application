import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/auth/logout.dart';
import 'package:go_go/data/datasource/remote/profile/profile.dart';

class ProfileController extends GetxController {
  late String name;
  late String phone;
  late String email;
  late String password;
  late String gender;
  String? file;
  late bool displayNotification = true;

  String token = "";
  String fcm_token = '';
  List<String> roles = [];

  MyServices myServices = Get.find();

  ProfileData profileData = ProfileData(Get.find());
  LogoutData logoutData = LogoutData(Get.find());

  StatusRequest statusRequest = StatusRequest.none;

  gotoEditProfile() {
    Get.toNamed(AppRoute.editProfile, arguments: {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
      "gender": gender,
      "image": file
    });
  }

  @override
  void onInit() {
    getaccount();
    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    roles = myServices.sharedPreferences.getStringList("roles") ?? [];
    fcm_token = myServices.sharedPreferences.getString("fcm_token") ?? "";
    update();
  }

  getaccount() async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await profileData.getdata();
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
      name = response['name'];
      password = myServices.sharedPreferences.getString("password") ?? "";
      phone = response['phone'];
      email = response['email'];
      gender = response['gender'];
      file = response['avatar'];
      Get.offNamed(AppRoute.homescreen);
    }
    update();
  }

  toggelNotification() {
    displayNotification = !displayNotification;
    update();
  }

  logout() async {
    var response = await logoutData.postdata(fcm_token);
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
      FirebaseMessaging.instance.unsubscribeFromTopic("users");
      myServices.sharedPreferences.clear();
      Get.offAllNamed(AppRoute.login);
    }
  }
}
