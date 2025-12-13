import 'package:flutter/material.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
//import 'package:go_go/data/datasource/remote/forgetpassword/checkemail.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_go/data/datasource/remote/forgetpassword/checkemail.dart';

abstract class ForgetPasswordController extends GetxController {
  checkemail();
}

class ForgetPasswordControllerImp extends ForgetPasswordController {
  CheckEmailData checkEmailData = CheckEmailData(Get.find());

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  StatusRequest statusRequest = StatusRequest.none;

  late TextEditingController email;

  @override
  // checkemail() {
  //   Get.offNamed(AppRoute.verfiyCode, arguments: {"email": email.text});
  // }
  checkemail() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await checkEmailData.postdata(email.text);
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
        if (response['status'] == "success") {
          Get.offNamed(AppRoute.verfiyCode, arguments: {"email": email.text});
        } else {
          Get.defaultDialog(title: "ُWarning", middleText: "Email Not Found");
          statusRequest = StatusRequest.failure;
        }
      }
      update();
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }
}
