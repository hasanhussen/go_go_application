import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/view/widgets/language_button.dart';
import 'package:go_go/view/widgets/welcom_screen_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImageAsset.background, // استبدلها بالصورة المناسبة
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Spacer(),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "2".tr,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  AppImageAsset.logo, // استبدلها بشعارك
                  height: 120,
                ),
                SizedBox(height: 60),
                Text(
                  '1'.tr,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LanguageButton(
                      text: 'عربي',
                      language: "ar",
                    ),
                    SizedBox(width: 10),
                    LanguageButton(
                      text: 'EN',
                      language: "en",
                    ),
                  ],
                ),
                SizedBox(height: 80),
                // SocialButton(icon: Icons.apple, text: '3'.tr),
                // SocialButton(
                //     icon: Icons.facebook, text: '4'.tr, color: Colors.blue),
                // SocialButton(
                //     icon: Icons.android,
                //     text: 'Google Play',
                //     color: Colors.white,
                //     textColor: Colors.black),
                // Spacer(),
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    WelcomButton(
                      onPressed: () {
                        Get.toNamed(AppRoute.signUp);
                      },
                      text: '9'.tr,
                      color: Colors.white,
                      textColor: Colors.black,
                      // child: Text(
                      //   '9'.tr,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: const Color.fromARGB(255, 128, 99, 99),
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 10),
                    WelcomButton(
                      onPressed: () {
                        Get.toNamed(AppRoute.login);
                      },
                      text: '15'.tr,
                      color: Colors.white,
                      textColor: Colors.black,
                      // child: Text(
                      //   '15'.tr,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
