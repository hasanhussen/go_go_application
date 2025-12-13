import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/profile_conroller.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:share_plus/share_plus.dart';

class SettingsList extends GetView<ProfileController> {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget _buildSettingItem(
      String title,
      IconData icon,
      VoidCallback onTap,
    ) {
      return ListTile(
        leading: Icon(icon, color: AppColor.grey),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColor.secondColor,
        ),
        onTap: onTap,
      );
    }

    return GetBuilder<ProfileController>(
      builder: (controller) => Expanded(
        child: ListView(
          children: [
            // -------------------- القسم الأول --------------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSettingItem(
                    "153".tr,
                    Icons.info,
                    () => Get.toNamed(AppRoute.aboutContactScreen),
                  ),
                  _buildSettingItem(
                    "155".tr,
                    Icons.favorite,
                    () => Get.toNamed(AppRoute.followedStores),
                  ),
                  controller.roles.contains('owner')
                      ? _buildSettingItem(
                          "93".tr,
                          Icons.store,
                          () => Get.toNamed(AppRoute.myStoresScreen),
                        )
                      : controller.roles.contains('delivery')
                          ? _buildSettingItem(
                              "152".tr,
                              Icons.delivery_dining,
                              () => Get.toNamed(AppRoute.myDeliverScreen),
                            )
                          : Container(),
                ],
              ),
            ),

            // -------------------- القسم الثاني --------------------
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildSettingItem(
                    "62".tr,
                    Icons.language,
                    () => Get.toNamed(AppRoute.language),
                  ),
                  _buildSettingItem(
                    "63".tr,
                    Icons.share,
                    () {
                      Share.share(
                        "حمّل تطبيق Go Go من الرابط التالي:\nhttps://example.com/app",
                        subject: "تطبيق Go Go",
                      );
                    },
                  ),
                  _buildSettingItem(
                    "64".tr,
                    Icons.support,
                    () => Get.toNamed(AppRoute.supportPage),
                  ),
                  _buildSettingItem(
                    "66".tr,
                    Icons.logout,
                    () => controller.logout(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
