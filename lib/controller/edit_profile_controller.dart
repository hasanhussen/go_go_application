import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/functions/uploadfile.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/profile/edit_profile_data.dart';

class EditProfileController extends GetxController {
  late String name;
  late String phone;
  late String email;
  late String gender;

  String token = "";
  File? file;
  String? imageName;

  MyServices myServices = Get.find();

  EditProfileData editProfileData = EditProfileData(Get.find());

  StatusRequest statusRequest = StatusRequest.none;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  updateProfile() async {
    print('111ooooooooooooooooooo');
    var response;
    statusRequest = StatusRequest.loading;
    print('222ooooooooooooooooooo');
    update();
    if (file == null) {
      print('333ooooooooooooooooooo');
      response = await editProfileData.editData(nameController.text,
          phoneController.text, emailController.text, "0", token);
      print('444ooooooooooooooooooo');
    } else {
      print('555ooooooooooooooooooo');
      response = await editProfileData.editDatawithfile(nameController.text,
          phoneController.text, emailController.text, "0", token, file);
      print('666ooooooooooooooooooo');
    }

    print("=============================== Controller $response ");

    statusRequest = handlingData(response);

    if (StatusRequest.success == statusRequest) {
      // Start backend
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
          textConfirm: "إعادة المحاولة",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
            updateProfile(); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      print('DoneDoneDoneDoneDone');
      Get.offAllNamed(AppRoute.homescreen);
      update();

      // End
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
    update();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  chooseImage() async {
    file = await fileUploadGallery();
    update();
  }

  @override
  void onInit() {
    gettoken();
    name = Get.arguments['name'];
    phone = Get.arguments['phone'];
    email = Get.arguments['email'];
    gender = Get.arguments['gender'];
    imageName = Get.arguments['image'];
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;

    super.onInit();
  }
}
