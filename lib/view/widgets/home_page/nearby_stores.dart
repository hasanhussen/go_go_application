import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/home_controller.dart';
import 'package:go_go/linkapi.dart';

class NearbyStores extends GetView<HomeController> {
  const NearbyStores({super.key});

  @override
  Widget build(BuildContext context) {
    // List<String> stores = [
    //   "shawarma",
    //   "kfc",
    //   "burgerking",
    //   "kudu",
    //   "mcdonalds"
    // ];
    return GetBuilder<HomeController>(
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("43".tr,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: controller.bestStores
                .map((store) => Expanded(
                      child: store.image != null && store.image!.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                Get.toNamed("resturantprofile",
                                    arguments: {"id": store.id});
                              },
                              child: CachedNetworkImage(
                                  imageUrl:
                                      "${AppLink.imageststatic}/${store.image!}",
                                  height: 50),
                            )
                          : Image.asset(
                              "assets/images/store.png",
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
