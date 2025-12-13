import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/profile/support_data.dart';
import 'package:image_picker/image_picker.dart';

class SupportController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final subjectC = TextEditingController();
  final messageC = TextEditingController();
  String selectedType = 'general'; // or map to user-facing labels
  File? pickedImage;
  //bool isLoading = false;

  String token = "";
  List<String> roles = [];

  MyServices myServices = Get.find();

  SupportData supportData = SupportData(Get.find());

  StatusRequest statusRequest = StatusRequest.none;

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (file != null) {
      pickedImage = File(file.path);
      update();
    }
  }

  void removeImage() {
    pickedImage = null;
    update();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    roles = myServices.sharedPreferences.getStringList("roles") ?? [];
    update();
  }

  Future<void> sendSupport() async {
    if (!formKey.currentState!.validate()) return;

    statusRequest = StatusRequest.loading;
    gettoken();
    update();

    try {
      var response = await supportData.postdata(
          roles[0], subjectC.text.trim(), messageC.text.trim(), pickedImage);
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
        subjectC.clear();
        messageC.clear();
        pickedImage = null;
        Get.back();
        Get.snackbar('نجاح', 'تم إرسال الرسالة بنجاح',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('خطأ',
            'حدث خطأ أثناء الإرسال. رمز الاستجابة: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
        statusRequest = StatusRequest.failure;
        update();
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل الإتصال: $e',
          snackPosition: SnackPosition.BOTTOM);
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  @override
  void onInit() {
    gettoken();
    super.onInit();
  }
}
