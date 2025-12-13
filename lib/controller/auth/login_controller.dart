import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/auth/login.dart';

class LoginController extends GetxController {
  late TextEditingController email;
  late TextEditingController password;
  bool isPassword = true;
  String? status;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  MyServices myServices = Get.find();

  StatusRequest statusRequest = StatusRequest.none;
  LoginData loginData = LoginData(Get.find());

  // void login() {
  //   if (formstate.currentState!.validate()) {
  //     Get.snackbar('نجاح', 'تم تسجيل الدخول بنجاح');
  //     saveaccount(username.text, password.text);
  //     Get.offAllNamed(AppRoute.homescreen);
  //   } else {
  //     Get.snackbar('خطأ', 'يرجى ملء جميع الحقول');
  //   }
  // }

  // saveaccount(String username, String password) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final key1 = 'name';
  //   final key2 = 'password';
  //   final key3 = 'email';
  //   final key4 = 'email';
  //   final key5 = 'birthDate';

  //   prefs.setString(key1, username);
  //   prefs.setString(key2, password);
  //   prefs.setString(key3, "+963 936593248");
  //   prefs.setString(key4, "hasan@example.com");
  //   prefs.setString(key5, "Oct 24, 1980");
  // }

  login() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      update();
      String? fcm_token = await FirebaseMessaging.instance.getToken();
      print("✅ FCM Token: $fcm_token");
      var response = await loginData.postdata(
          email.text.trim(), password.text.trim(), fcm_token);
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
        myServices.sharedPreferences.setString("fcm_token", fcm_token ?? '');
        myServices.sharedPreferences.setString("password", password.text);
        myServices.sharedPreferences.setInt("id", response['id']);
        //int userid = myServices.sharedPreferences.getInt("id")!;
        myServices.sharedPreferences.setString("username", response['name']);
        myServices.sharedPreferences.setString("email", response['email']);
        myServices.sharedPreferences.setString("phone", response['phone']);
        myServices.sharedPreferences.setString("gender", response["gender"]);
        myServices.sharedPreferences
            .setStringList("roles", List<String>.from(response['roles']));
        myServices.sharedPreferences.setString("status", response['status']);
        myServices.sharedPreferences.setString("token", response["api_token"]);
        myServices.sharedPreferences.setString("step", "2");

        // FirebaseMessaging.instance.subscribeToTopic("users${userid}");

        List<String> roles =
            myServices.sharedPreferences.getStringList("roles") ?? [];

        // if (fcm_token != null) {
        //   await http.post(
        //     Uri.parse(AppLink.saveFcmToken),
        //     headers: {
        //       'Authorization': 'Bearer ${response["api_token"]}',
        //       'Accept': 'application/json',
        //     },
        //     body: {'fcm_token': fcm_token},
        //   );
        // }

        if (response['status'] == '1') {
          if (roles.isNotEmpty && roles.contains('delivery')) {
            FirebaseMessaging.instance.subscribeToTopic("delivery");
            FirebaseMessaging.instance.subscribeToTopic("users");
          } else if (roles.isNotEmpty && roles.contains('owner')) {
            FirebaseMessaging.instance.subscribeToTopic("owner");
            FirebaseMessaging.instance.subscribeToTopic("users");
          } else {
            FirebaseMessaging.instance.subscribeToTopic("users");
          }
          if (response['email_verified_at'] != null) {
            Get.offAllNamed(AppRoute.homescreen);
          } else {
            Get.offAllNamed(AppRoute.login);
            Get.snackbar(
              "150".tr,
              "151".tr,
              backgroundColor: Colors.deepOrangeAccent,
              snackPosition: SnackPosition.TOP,
            );
          }
        } else if (response['status'] == '0') {
          statusRequest = StatusRequest.none;
          Get.defaultDialog(
              title: "ُWarning",
              middleText: "The account has not been approved yet");
          Get.offNamed(AppRoute.login);
          update();
        } else if (response['status'] == '2') {
          statusRequest = StatusRequest.none;
          Get.defaultDialog(title: "ُWarning", middleText: "Account banned");
          Get.offNamed(AppRoute.login);
          update();
        } else if (response['message'] == 'account_deleted') {
          Get.offNamed(AppRoute.deletedAccountScreen);
        } else {
          statusRequest = StatusRequest.none;
          Get.offNamed(AppRoute.login);
          update();
        }
      }
      update();
    } else {
      Get.defaultDialog(
          title: "ُWarning", middleText: "email Or Password Not Correct");
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  toggelpassword() {
    isPassword = isPassword == true ? false : true;
    update();
  }

  @override
  void onInit() {
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
      // ignore: unused_local_variable
      String? token = value;
    });
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
