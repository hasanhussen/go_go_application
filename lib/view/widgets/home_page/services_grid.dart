import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/home_controller.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';

// ignore: must_be_immutable
class ServicesGrid extends StatelessWidget {
  ServicesGrid({super.key});
  HomeScreenControllerImp homeScreenControllerImp = Get.find();
  HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("56".tr,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  height: 0.2)),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: homeController.services.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  homeScreenControllerImp.toggleShowCategoryList(
                      homeController.services[index].id!, index);
                  //Get.toNamed(AppRoute.resturantList);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      homeController.services[index].image == '' ||
                              homeController.services[index].image!.isEmpty
                          ? Image.asset(
                              "${AppImageAsset.rootImages}/category.jpg",
                              fit: BoxFit.contain,
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  "${AppLink.imageststatic}/${homeController.services[index].image!}",
                              height: 50),
                      SizedBox(height: 5),
                      Text(homeController.services[index].type!,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
