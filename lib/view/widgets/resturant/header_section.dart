import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'package:go_go/linkapi.dart';

import '../../../controller/resruant_profile_controller.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResturantProfileController>();

    return GetBuilder<ResturantProfileController>(
      builder: (controller) => SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            // الخلفية: صورة الغلاف
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: controller.stores.cover != null &&
                          controller.stores.cover!.isNotEmpty
                      ? NetworkImage(
                          "${AppLink.imageststatic}/${controller.stores.cover!}",
                        )
                      : AssetImage("assets/images/restaurant_cover.jpg"),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),

            // طبقة فوق الصورة لتعتيمها
            Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                color: Colors.black.withOpacity(0.4), // الشفافية
              ),
            ),

            // المحتوى الأساسي
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: controller.isOwner
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    IconButton(
                                      tooltip: "سلة المحذوفات",
                                      onPressed: () {
                                        controller.gotoMealTrash();
                                      },
                                      icon: const Icon(
                                        Icons.delete_sweep_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    if (controller.trashCount > 0)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                                9), // نصف الـ height لتظل دائرية
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 18, // أقل عرض للدائرة
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${controller.trashCount}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                height: 1,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      if (controller.stores.bayesianScore !=
                                              null &&
                                          controller.stores.bayesianScore! > 0)
                                        // النجوم
                                        RatingBarIndicator(
                                          rating: double.tryParse(controller
                                                  .stores.bayesianScore
                                                  .toString()) ??
                                              0.0,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 15,
                                          unratedColor: Colors.white38,
                                          direction: Axis.horizontal,
                                        ),
                                      const SizedBox(width: 6),
                                      // النص بجانب النجوم
                                      Text(
                                        controller.stores.bayesianScore !=
                                                    null &&
                                                controller
                                                        .stores.bayesianScore! >
                                                    0
                                            ? controller.stores.bayesianScore
                                                .toString()
                                            : "لم يقيم بعد",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!controller.isOwner)
                                  ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                    ),
                                    onPressed: () {
                                      Get.dialog(
                                        AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          title: const Text(
                                            "قيّم هذا المتجر",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "اختر تقييمك من 1 إلى 5 نجوم",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(height: 16),
                                              RatingBar.builder(
                                                initialRating: 0,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                glow: true,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  controller.rateStore(
                                                      rating); // استدعِ دالة حفظ التقييم
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Get.back(),
                                              child: const Text("إغلاق"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.star,
                                        color: Colors.amber),
                                    label: const Text(
                                      "قيّم المتجر",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                    ),

                    const SizedBox(height: 16),

                    // الصورة الشخصية
                    // للصورة الشخصية - استخدم نفس طريقة صورة الغلاف
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: controller.stores.image != null &&
                              controller.stores.image!.isNotEmpty
                          ? ClipOval(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      "${AppLink.imageststatic}/${controller.stores.image!}",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Image.asset(
                              "assets/images/chef_hat.png",
                              width: 60,
                              height: 60,
                            ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      controller.stores.name ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.stores.special ?? '',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
