import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/resruant_profile_controller.dart';

class RestaurantInfoSection extends StatelessWidget {
  const RestaurantInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResturantProfileController>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: GetBuilder<ResturantProfileController>(
              builder: (controller) => Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_alt_outlined,
                            size: 18, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text("${controller.followers ?? ''} ${'73'.tr} ",
                            style: const TextStyle(color: Colors.black87)),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        controller.togglefollow(controller.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9F1C),
                        shape: const StadiumBorder(),
                      ),
                      child: Text(
                        controller.isfollow == "0" ? "74".tr : "125".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     // Text("75".tr, style: TextStyle(fontWeight: FontWeight.w500)),
          //     controller.stores.isOpenNow == true
          //         ? Text('🟢 مفتوح الآن',
          //             style: TextStyle(fontWeight: FontWeight.w500))
          //         : Text('🔴 مغلق الآن',
          //             style: TextStyle(fontWeight: FontWeight.w500))
          //   ],
          // ),
          SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  controller.stores.address ?? '',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 3, // إذا بدك تقتصر على سطر واحد
                  overflow: TextOverflow.ellipsis, // لتجنب overflow
                ),
              ),
              SizedBox(width: 8),
              controller.stores.isOpenNow == true
                  ? Text('🟢 مفتوح الآن',
                      style: TextStyle(fontWeight: FontWeight.w500))
                  : Text('🔴 مغلق الآن',
                      style: TextStyle(
                          fontWeight: FontWeight.w500)) // مسافة بدل Spacer
              // Icon(Icons.timer, size: 16, color: Colors.grey),
              // SizedBox(width: 4),
              // Text("77".tr, style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}
