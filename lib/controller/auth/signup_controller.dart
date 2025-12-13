import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/auth/signup.dart';

class SignUpController extends GetxController {
  late TextEditingController phoneNumber;
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController password;
  // late TextEditingController birthdate;
  // DateTime addselectedDate = DateTime.now();
  bool isMale = true;
  String gender = "0";
  bool isPassword = true;
  String hintText = "6".tr;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  MyServices myServices = Get.find();

  StatusRequest statusRequest = StatusRequest.none;
  SignupData signupData = SignupData(Get.find());

  @override
  void onInit() {
    username = TextEditingController();
    phoneNumber = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    //birthdate = TextEditingController();
    super.onInit();
  }

  void updateGender(bool male) {
    isMale = male;
    update();
  }

  void checkgender() {
    isMale == true ? gender = "0" : gender = "1";
    update();
  }

  bool isOwner = false;
  String role = "user";
  String status = "1";

  toggelowner() {
    isOwner = !isOwner;
    checkrole();
    checkstatus();
    update();
  }

  void checkrole() {
    isOwner == false ? role = "user" : role = "owner";
    update();
  }

  void checkstatus() {
    isOwner == false ? status = "1" : status = "0";
    update();
  }

  signUp() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      checkgender();
      String? fcm_token = await FirebaseMessaging.instance.getToken();
      print("✅ FCM Token: $fcm_token");
      var response = await signupData.postdata(username.text, password.text,
          email.text, phoneNumber.text, role, status, gender, fcm_token);
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
        myServices.sharedPreferences.setString("password", password.text);
        myServices.sharedPreferences.setInt("id", response['id']);
        //int userid = myServices.sharedPreferences.getInt("id")!;
        myServices.sharedPreferences.setString("username", response['name']);
        myServices.sharedPreferences.setString("email", response['email']);
        myServices.sharedPreferences.setString("phone", response['phone']);
        myServices.sharedPreferences
            .setStringList("role", List<String>.from(response['roles']));
        myServices.sharedPreferences.setString("status", response['status']);
        myServices.sharedPreferences.setString("gender", response['gender']);
        myServices.sharedPreferences.setString("token", response['api_token']);
        myServices.sharedPreferences.setString("step", "2");

        //FirebaseMessaging.instance.subscribeToTopic("users");
        //FirebaseMessaging.instance.subscribeToTopic("users${userid}");

        // String? fcm_token = await FirebaseMessaging.instance.getToken();
        // print("✅ FCM Token: $fcm_token");
        // if (fcm_token != null) {
        //   var fcmresponse = await http.post(
        //     Uri.parse(AppLink.saveFcmToken),
        //     headers: {
        //       'Authorization': 'Bearer ${response["api_token"]}',
        //       'Accept': 'application/json',
        //     },
        //     body: {'fcm_token': fcm_token},
        //   );
        //   print(fcmresponse.body);
        // }

        // Get.offNamed(AppRoute.verfiyCode,
        //     arguments: {'email': response['email']});
        Get.snackbar(
          "150".tr,
          "151".tr,
          backgroundColor: Colors.deepOrangeAccent,
          snackPosition: SnackPosition.TOP,
        );
      }
      update();
    } else {
      Get.snackbar(
        "ُ112".tr,
        "148".tr,
        snackPosition: SnackPosition.TOP,
      );
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  toggelpassword() {
    isPassword = isPassword == true ? false : true;
    update();
  }

  // Future<void> selectDate(BuildContext context) async {
  //   await showDatePicker(
  //     context: context,
  //     initialDate: addselectedDate,
  //     firstDate: DateTime(1930),
  //     lastDate: DateTime(2026),
  //   ).then((pickedDate) {
  //     if (pickedDate != null && pickedDate != addselectedDate) {
  //       addselectedDate = pickedDate;
  //       birthdate.text = DateFormat.yMd().format(addselectedDate);
  //       hintText = birthdate.text;
  //     }
  //   });
  //   update();
  // }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    super.dispose();
  }
}
