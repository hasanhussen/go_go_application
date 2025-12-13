import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/auth/signup_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/view/widgets/auth/custom_textfield.dart';
import 'package:go_go/view/widgets/gender_button.dart';

class SignUp extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SignUpController>(
        builder: (controller) => HandlingDataRequest(
          statusRequest: controller.statusRequest,
          widget: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                AppImageAsset.background,
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                child: SingleChildScrollView(
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
                              SizedBox(height: 20),
                              Text(
                                "2".tr,
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '5'.tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 60),
                              // Stack(
                              //   children: [
                              //     CircleAvatar(
                              //       radius: 40,
                              //       backgroundColor: Colors.white,
                              //     ),
                              //     Positioned(
                              //       bottom: 0,
                              //       right: 0,
                              //       child: CircleAvatar(
                              //         radius: 12,
                              //         backgroundColor: Colors.green,
                              //         child: Icon(Icons.add,
                              //             color: Colors.white, size: 16),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              SizedBox(height: 20),
                              CustomTextField(
                                hint: '21'.tr,
                                icon: Icons.phone,
                                controller: controller.phoneNumber,
                                valid: (val) {
                                  return validInput(val!, 7, 11, "phone");
                                },
                              ),
                              CustomTextField(
                                hint: '20'.tr,
                                icon: Icons.person,
                                controller: controller.username,
                                valid: (val) {
                                  return validInput(val!, 3, 20, "username");
                                },
                              ),
                              CustomTextField(
                                hint: '18'.tr,
                                icon: Icons.email,
                                controller: controller.email,
                                valid: (val) {
                                  return validInput(val!, 3, 40, "email");
                                },
                              ),
                              GetBuilder<SignUpController>(
                                builder: (controller) => CustomTextField(
                                  hint: '19'.tr,
                                  icon: Icons.lock,
                                  isPassword: controller.isPassword,
                                  onPressed: () {
                                    controller.toggelpassword();
                                  },
                                  controller: controller.password,
                                  valid: (val) {
                                    return validInput(val!, 8, 30, "password");
                                  },
                                ),
                              ),
                              // CustomTextField(
                              //   readOnly: true,
                              //   hint: controller.hintText,
                              //   icon: Icons.calendar_today,
                              //   controller: controller.birthdate,
                              //   valid: (val) {
                              //     return validInput(val!, 3, 40, "birthdate");
                              //   },
                              //   onPressed: () {
                              //     controller.selectDate(context);
                              //   },
                              // ),
                              SizedBox(height: 40),
                              GetBuilder<SignUpController>(
                                builder: (controller) => Column(
                                  children: [
                                    // أزرار اختيار الجنس
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GenderButton(
                                          text: '7'.tr,
                                          isSelected: controller.isMale,
                                          onTap: () =>
                                              controller.updateGender(true),
                                        ),
                                        SizedBox(width: 10),
                                        GenderButton(
                                          text: '8'.tr,
                                          isSelected: !controller.isMale,
                                          onTap: () =>
                                              controller.updateGender(false),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 15),

                                    // ✅ Checkbox لتحديد حساب التاجر
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: controller.isOwner,
                                          activeColor: Colors.white,
                                          checkColor: Colors.black,
                                          onChanged: (value) {
                                            controller
                                                .toggelowner(); // تنفذ كل مرة يتغير فيها
                                          },
                                        ),
                                        Text(
                                          "هل هذا حساب تاجر؟",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 30),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  controller.signUp();
                                },
                                child: Text('10'.tr,
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
    );
  }
}
