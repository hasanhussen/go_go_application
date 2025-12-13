import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/profile_conroller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/view/widgets/profile/profile_header.dart';
import 'package:go_go/view/widgets/profile/settings_list.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return GetBuilder<ProfileController>(
      builder: (controller) => HandlingDataRequest(
        statusRequest: controller.statusRequest,
        widget: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, left: 10.0, top: 2),
                          child: Text(
                            "72".tr,
                            style: TextStyle(fontSize: 25, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    ProfileHeader(),
                  ],
                ),
              ),
              SettingsList(),
              //LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
