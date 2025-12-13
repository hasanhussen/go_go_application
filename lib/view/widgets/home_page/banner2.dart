import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/home_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';
import 'package:shimmer/shimmer.dart'; // أضف هذه المكتبة لاستخدام Timer

class CuntomBanner2 extends StatelessWidget {
  const CuntomBanner2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.statusRequest == StatusRequest.loading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 150,
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        } else if (controller.statusRequest == StatusRequest.failure) {
          return Center(child: Text('حدث خطأ في تحميل البيانات'));
        } else if (controller.sliderData.isEmpty) {
          return Center(child: Text('لا توجد بيانات متاحة'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            child: CarouselSlider(
              options: CarouselOptions(
                // height: 150,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 1000),
                viewportFraction: 1.0,
              ),
              items: controller.sliderData.map((item) {
                final banner = item;
                return Container(
                  //margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical, // تمرير عمودي
                            child: Text(
                              banner.slidertitle ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: banner.image != null
                              ? CachedNetworkImage(
                                  imageUrl: AppLink.imageststatic +
                                      "/" +
                                      (banner.image ?? ''),
                                  height: 100,
                                  width: 90,
                                  //fit: BoxFit.cover,
                                  // errorBuilder: (context, error, stackTrace) =>
                                  //     Icon(Icons.error),
                                )
                              : Image.asset(
                                  AppImageAsset.delivery,
                                  height: 100,
                                  width: 90,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
