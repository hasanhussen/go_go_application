import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/home_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/view/widgets/home_page/Nearby_stores.dart';
import 'package:go_go/view/widgets/home_page/banner2.dart';
import 'package:go_go/view/widgets/home_page/services_grid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetBuilder<HomeController>(
      builder: (controller) {
        return HandlingDataRequest(
          statusRequest: controller.statusRequest,
          widget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Center(
                    child: Text("40".tr,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                  SizedBox(height: 25),
                  CuntomBanner2(),
                  SizedBox(height: 25),
                  NearbyStores(),
                  SizedBox(height: 40),
                  ServicesGrid(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
