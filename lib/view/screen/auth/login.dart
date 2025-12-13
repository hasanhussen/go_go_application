import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/auth/login_controller.dart'; // تأكد من إنشاء هذا المتحكم
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/core/functions/alertexitapp.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/view/widgets/auth/custom_textfield.dart'; // استخدم نفس الـ CustomTextField

class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: alertExitApp,
        child: GetBuilder<LoginController>(
          builder: (controller) => HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppImageAsset.background, // نفس خلفية التسجيل
                  fit: BoxFit.cover,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 40),
                  child: SingleChildScrollView(
                    // أضف SingleChildScrollView هنا
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Future.delayed(Duration(milliseconds: 110), () {
                              Get.back();
                            });
                          },
                        ),
                        Form(
                          key: controller.formstate,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 80),
                                Text(
                                  '11'.tr,
                                  style: TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '12'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 60),
                                CustomTextField(
                                  hint: '18'.tr,
                                  icon: Icons.email,
                                  controller: controller.email,
                                  valid: (val) {
                                    return validInput(val!, 10, 100, "email");
                                  },
                                ),
                                SizedBox(height: 10),
                                GetBuilder<LoginController>(
                                  builder: (controller) => CustomTextField(
                                    hint: '19'.tr,
                                    icon: Icons.lock,
                                    isPassword: controller.isPassword,
                                    onPressed: () {
                                      controller.toggelpassword();
                                    },
                                    controller: controller.password,
                                    valid: (val) {
                                      return validInput(
                                          val!, 3, 30, "password");
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                Column(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Get.toNamed(AppRoute.forgetPassword);
                                      },
                                      child: Text(
                                        '14'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // الانتقال إلى شاشة التسجيل
                                        Get.toNamed(AppRoute
                                            .signUp); // تأكد من استيراد شاشة التسجيل
                                      },
                                      child: Text(
                                        '16'.tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    controller
                                        .login(); // استدعاء دالة تسجيل الدخول من المتحكم
                                  },
                                  child: Text('15'.tr,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
