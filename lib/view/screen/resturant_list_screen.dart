import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/controller/resturant_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/widgets/custom_appbar.dart';
import 'package:go_go/view/widgets/resturant_card.dart';

class RestaurantListScreen extends StatelessWidget {
  final RestaurantController controller = Get.put(RestaurantController());
  final HomeScreenControllerImp homeScreenController = Get.find();

  final String? image;
  final String? type;

  RestaurantListScreen({super.key, this.image, this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        CustomAppBar(title: type ?? ''),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // لون الظل مع شفافية
                    blurRadius: 8, // مدى التمويه (Blur)
                    spreadRadius: 2, // انتشار الظل
                    offset: Offset(0, 3), // إزاحة الظل (أفقي, عمودي)
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              width: double.infinity, // جعل العرض يأخذ المساحة بالكامل
              height: 150,
              child: image == '' || image!.isEmpty
                  ? Image.asset(
                      "${AppImageAsset.rootImages}/store.png",
                      fit: BoxFit.contain,
                    )
                  : CachedNetworkImage(
                      imageUrl: '${AppLink.imageststatic}/$image',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        height: 50,
                        width: 50,
                        child: Icon(Icons.store, color: Colors.grey[400]),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        height: 50,
                        width: 50,
                        child:
                            Icon(Icons.broken_image, color: Colors.grey[400]),
                      ),
                    ),
            )),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: GetBuilder<RestaurantController>(
            builder: (controller) {
              return Container(
                margin: EdgeInsets.only(bottom: 30),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: homeScreenController.restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = homeScreenController.restaurants[index];
                    return InkWell(
                        onTap: () {
                          controller.goToProfileDetails(
                            homeScreenController.restaurants[index].id!,
                            //homeScreenController.pendingOrderId
                          );
                        },
                        child: RestaurantCard(restaurant: restaurant));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
