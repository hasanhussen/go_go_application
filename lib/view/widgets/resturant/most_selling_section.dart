import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/linkapi.dart';

class MostSellingSection extends StatelessWidget {
  const MostSellingSection({super.key});
  Widget build(BuildContext context) {
    ResturantProfileController controller = Get.find();
    return GetBuilder<ResturantProfileController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("129".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5),
              controller.mostsellingmeals.isNotEmpty
                  ? SizedBox(
                      height: 225,
                      child: ListView.builder(
                        itemCount: controller.mostsellingmeals.length > 4
                            ? 4
                            : controller.mostsellingmeals.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            controller.showMostSellingDetails(index);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 158, 31, 31)
                                            .withOpacity(0.08))),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: controller
                                              .mostsellingmeals[index].image ==
                                          null
                                      ? Image.asset(
                                          "assets/images/fries.png",
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          "${AppLink.imageststatic}/${controller.mostsellingmeals[index].image}",
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (controller.mostsellingmeals[index]
                                                  .quantity !=
                                              null &&
                                          controller.mostsellingmeals[index]
                                                  .quantity ==
                                              0)
                                        Text('نفذت الكمية',
                                            style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red)),
                                      SizedBox(height: 3),
                                      Text(
                                          controller
                                              .mostsellingmeals[index].name!,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(height: 3),
                                      Text(
                                        controller.mostsellingmeals[index]
                                            .description!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!controller.isOwner)
                                  const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                if (controller.isOwner) ...[
                                  //Spacer(),
                                  Column(
                                    mainAxisSize: MainAxisSize
                                        .min, // يخلي العمود قد المحتوى بس
                                    children: [
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          padding: EdgeInsets
                                              .zero, // يشيل المسافات الداخلية
                                          minimumSize: Size(0,
                                              0), // يلغي الحد الأدنى الافتراضي
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // يصغّر مساحة التاتش
                                        ),
                                        onPressed: () {
                                          controller.gotoEditMeal(
                                              controller.meals[index].id!);
                                        },
                                        icon: const Icon(
                                          Icons.edit_note_outlined,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        label: const SizedBox.shrink(),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton.icon(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "تأكيد الحذف",
                                            middleText:
                                                "هل أنت متأكد أنك تريد حذف هذا المنتج؟",
                                            textCancel: "إلغاء",
                                            textConfirm: "حذف",
                                            confirmTextColor: Colors.white,
                                            buttonColor: Colors.red,
                                            onConfirm: () {
                                              // controller.deleteMeal(
                                              //     controller.meals[index].id!);
                                              Get.back();
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 19,
                                          color: Colors.red,
                                        ),
                                        label: const SizedBox.shrink(),
                                      ),
                                    ],
                                  )
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text('128'.tr),
            ],
          ),
        );
      },
    );
  }
}
