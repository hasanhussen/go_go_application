import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/constant/approute.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final HomeScreenControllerImp homeScreenController = Get.find();

  CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.offNamed(AppRoute.homescreen);
              homeScreenController.toggleShowHomePage();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.chevron_left, color: Colors.red, size: 30),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 48), // للحفاظ على التوسيط
        ],
      ),
    );
  }
}
