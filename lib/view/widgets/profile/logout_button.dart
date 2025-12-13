import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/profile_conroller.dart';

class LogoutButton extends GetView<ProfileController> {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Padding(
        padding: const EdgeInsets.only(
            top: 16.0, right: 16.0, bottom: 30.0, left: 16.0),
        child: ElevatedButton(
          onPressed: () {
            controller.logout();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text("66".tr, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
