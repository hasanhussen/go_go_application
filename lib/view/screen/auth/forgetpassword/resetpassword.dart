import 'package:go_go/controller/forgetpassword/resetpassword_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/view/widgets/auth/custombuttonauth.dart';
import 'package:go_go/view/widgets/auth/customtextbodyauth.dart';
import 'package:go_go/view/widgets/auth/customtextformauth.dart';
import 'package:go_go/view/widgets/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ResetPasswordControllerImp());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        title: Text('39'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: AppColor.grey)),
      ),
      body: GetBuilder<ResetPasswordControllerImp>(
          builder: (controller) => HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Form(
                  key: controller.formstate,
                  child: ListView(children: [
                    const SizedBox(height: 20),
                    CustomTextTitleAuth(text: "35".tr),
                    const SizedBox(height: 10),
                    CustomTextBodyAuth(text: "35".tr),
                    const SizedBox(height: 15),
                    CustomTextFormAuth(
                      isNumber: false,
                      valid: (val) {
                        return validInput(val!, 3, 40, "password");
                      },
                      mycontroller: controller.password,
                      hinttext: "13".tr,
                      iconData: Icons.lock_outline,
                      obscureText: controller.isPassword,
                      onTapIcon: () {
                        controller.toggelpassword();
                      },
                      labeltext: "19".tr,
                      // mycontroller: ,
                    ),
                    CustomTextFormAuth(
                      isNumber: false,

                      valid: (val) {
                        return validInput(val!, 3, 40, "password");
                      },
                      mycontroller: controller.repassword,
                      hinttext: "4".tr,
                      iconData: Icons.lock_outline,
                      labeltext: "19".tr,
                      obscureText: controller.isPassword,
                      onTapIcon: () {
                        controller.toggelpassword();
                      },
                      // mycontroller: ,
                    ),
                    CustomButtomAuth(
                        text: "33".tr,
                        onPressed: () {
                          controller.goToSuccessResetPassword();
                        }),
                    const SizedBox(height: 40),
                  ]),
                ),
              ))),
    );
  }
}
