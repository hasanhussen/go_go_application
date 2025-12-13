// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:go_go/controller/orders/old_details_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrdersDetails extends StatelessWidget {
  const OrdersDetails({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OldOrdersDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: Text('85'.tr),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: GetBuilder<OldOrdersDetailsController>(
            builder: ((controller) => HandlingDataView(
                statusRequest: controller.statusRequest,
                widget: ListView(children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          Table(
                            children: [
                              TableRow(children: [
                                Text("86".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold)),
                                Text("87".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold)),
                                Text("88".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.primaryColor,
                                        fontWeight: FontWeight.bold)),
                              ]),
                              ...List.generate(
                                  2
                                  //controller.data.length
                                  ,
                                  (index) => TableRow(children: [
                                        Text("89".tr,
                                            textAlign: TextAlign.center),
                                        Text("2", textAlign: TextAlign.center),
                                        Text("30", textAlign: TextAlign.center),
                                      ]))
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("${'90'.tr}: 40\$",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if (controller.ordersModel.ordersType == "0")
                  Card(
                    child: Container(
                        child: ListTile(
                      title: Text("91".tr,
                          style: TextStyle(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text("92".tr),
                    )),
                  ),
                ])))),
      ),
    );
  }
}
