import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/widgets/resturant/banned_meals_section.dart';
import 'package:go_go/view/widgets/resturant/meals.dart';
import 'package:go_go/view/widgets/resturant/pending_meals_section.dart';

import '../../controller/resruant_profile_controller.dart';
import '../widgets/resturant/coupon_section.dart';
import '../widgets/resturant/header_section.dart';
import '../widgets/resturant/most_selling_section.dart';
import '../widgets/resturant/restaurant_info_section.dart';

class RestaurantProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ResturantProfileController controller =
        Get.put(ResturantProfileController());
    return WillPopScope(
      onWillPop: () async {
        /// أغلق كل الصفحات ورجع المستخدم للصفحة الرئيسية
        Get.offAllNamed(AppLink.homepage); // أو المسار يلي بدك ياه
        return false; // حتى ما يرجع بشكل تلقائي
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GetBuilder<ResturantProfileController>(
          builder: (controller) => HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(),
                  if (!controller.isOwner) ...[
                    RestaurantInfoSection(),
                    // CouponSection(),
                    MostSellingSection(),
                  ],
                  Meals(),
                  if (controller.isOwner) ...[
                    SizedBox(height: 10),
                    PendingMealsSection(),
                    SizedBox(height: 10),
                    BannedMealsSection(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
