import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/edit_profile_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/widgets/profile/text_field.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EditProfileController controller = Get.put(EditProfileController());
    return Scaffold(
      appBar: AppBar(title: Text("57".tr), actions: [
        GetBuilder<EditProfileController>(
          builder: (controller) => TextButton(
              onPressed: () {
                controller.updateProfile();
              },
              child: Text(
                "71".tr,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              )),
        )
      ]),
      body: GetBuilder<EditProfileController>(
        builder: (controller) {
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment:
                          Alignment.bottomRight, // وضع الأيقونة في الأسفل يمين
                      children: [
                        controller.file != null
                            ? ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16)),
                                child: Image.file(
                                  controller.file!,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ))
                            : controller.imageName != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.red, width: 1.5),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(40)),
                                        child: CachedNetworkImage(
                                          imageUrl: AppLink.imageststatic +
                                              "/" +
                                              controller.imageName!,
                                          // controller.file!,
                                          fit: BoxFit.cover,
                                          height: 80,
                                          width: 80,
                                        )),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        AssetImage(AppImageAsset.avatar),
                                  ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: GestureDetector(
                            onTap: () {
                              controller
                                  .chooseImage(); // استدعاء دالة اختيار الصورة
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white, // لون خلفية الأيقونة
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.camera_alt,
                                  color: Colors.black, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildTextField("67".tr, controller.nameController),
                    // buildTextField("68".tr, controller.passwordController,
                    //     obscureText: true),
                    buildTextField("69".tr, controller.phoneController),
                    buildTextField("70".tr, controller.emailController),
                    //buildTextField("6".tr, controller.birthDateController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
