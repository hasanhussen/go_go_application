import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/home_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/linkapi.dart';
import 'package:shimmer/shimmer.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        if (controller.statusRequest == StatusRequest.loading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 160,
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

        return Column(
          children: [
            SizedBox(
              height: 160, // ارتفاع مناسب للصورة + النص
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.sliderData.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  final banner = controller.sliderData[index];
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12), // padding أصغر شوي
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  banner.slidertitle ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${AppLink.imageststatic}/${banner.image ?? ''}",
                            height: 120, // حجم الصورة مضبوط
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.sliderData.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  width: controller.currentPage.value == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: controller.currentPage.value == index
                        ? Colors.redAccent
                        : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
