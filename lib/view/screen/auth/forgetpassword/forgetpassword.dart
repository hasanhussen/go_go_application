import 'package:go_go/controller/forgetpassword/forgetpassword_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/view/widgets/auth/custombuttonauth.dart';
import 'package:go_go/view/widgets/auth/customtextbodyauth.dart';
import 'package:go_go/view/widgets/auth/customtextformauth.dart';
import 'package:go_go/view/widgets/auth/customtexttitleauth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgetPasswordControllerImp());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.backgroundcolor,
        elevation: 0.0,
        // title: Text('14'.tr,
        //     style: Theme.of(context)
        //         .textTheme
        //         .displayLarge!
        //         .copyWith(color: AppColor.grey)),
      ),
      body: GetBuilder<ForgetPasswordControllerImp>(
          builder: (controller) => HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Form(
                  key: controller.formstate,
                  child: ListView(children: [
                    const SizedBox(height: 20),
                    CustomTextTitleAuth(text: "27".tr),
                    const SizedBox(height: 10),
                    CustomTextBodyAuth(
                        // please Enter Your Email Address To Recive A verification code
                        text: "29".tr),
                    const SizedBox(height: 40),
                    CustomTextFormAuth(
                      isNumber: false,
                      // ignore: body_might_complete_normally_nullable
                      valid: (val) {},
                      mycontroller: controller.email,
                      hinttext: "3".tr,
                      iconData: Icons.email_outlined,
                      labeltext: "18".tr,
                      // mycontroller: ,
                    ),
                    CustomButtomAuth(
                        text: "30".tr,
                        onPressed: () {
                          controller.checkemail();
                        }),
                    const SizedBox(height: 40),
                  ]),
                ),
              ))),
    );
  }
}
