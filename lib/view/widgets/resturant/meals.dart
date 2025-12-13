import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/linkapi.dart';

class Meals extends StatelessWidget {
  const Meals({super.key});

  @override
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
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header row
              Row(
                children: [
                  Text(
                    "126".tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Owner: show a prominent add button
                  if (controller.isOwner == true)
                    ElevatedButton.icon(
                      onPressed: controller.gotoAddMeal,
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        "127".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 10),
              // meals list
              controller.meals.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.meals.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final meal = controller.meals[index];
                        return _MealCard(
                          quantity: meal.quantity,
                          mealIndex: index,
                          mealName: meal.name ?? '',
                          mealDesc: meal.description ?? '',
                          mealImg: meal.image,
                          isOwner: controller.isOwner,
                          onTap: () => controller.showMealDetails(index),
                          onEdit: () => controller.gotoEditMeal(meal.id!),
                          onHide: () async {
                            // show confirm and call controller.hideMeal
                            final result = await Get.defaultDialog<bool>(
                              title: "تأكيد الإخفاء",
                              middleText:
                                  "هل تريد إخفاء هذا المنتج من الواجهة؟ (يمكن استرجاعه من سلة المحذوفات)",
                              textCancel: "إلغاء",
                              textConfirm: "إخفاء",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.redAccent,
                              onConfirm: () {
                                Get.back(result: true);
                              },
                            );
                            if (result == true) {
                              controller.hideMeal(meal.id!);
                            }
                          },
                          onDeletePermanent: () async {
                            final result = await Get.defaultDialog<bool>(
                              title: "حذف نهائي",
                              content: Text(
                                "هل أنت متأكد من الحذف النهائي لهذا المنتج؟ \n  لن يمكنك استرجاعه إلا بعد التواصل مع الإدارة . ",
                                textDirection:
                                    TextDirection.rtl, // هاد بيحل المشكلة
                                style: TextStyle(fontSize: 13),
                              ),
                              textCancel: "إلغاء",
                              textConfirm: "حذف نهائي",
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                Get.back(result: true);
                              },
                            );
                            if (result == true) {
                              controller.deleteMealPermanent(meal.id!);
                            }
                          },
                        );
                      },
                    )
                  : Text('128'.tr),
            ],
          ),
        );
      },
    );
  }
}

class _MealCard extends StatelessWidget {
  final int? quantity;
  final int mealIndex;
  final String mealName;
  final String mealDesc;
  final String? mealImg;
  final bool isOwner;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onHide;
  final VoidCallback onDeletePermanent;

  const _MealCard({
    required this.quantity,
    required this.mealIndex,
    required this.mealName,
    required this.mealDesc,
    required this.mealImg,
    required this.isOwner,
    required this.onTap,
    required this.onEdit,
    required this.onHide,
    required this.onDeletePermanent,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    const Color.fromARGB(255, 158, 31, 31).withOpacity(0.08))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: mealImg == null
                  ? Image.asset(
                      "assets/images/fries.png",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "${AppLink.imageststatic}/$mealImg",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),
            // title & desc
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (quantity != null && quantity == 0)
                    Text('نفذت الكمية',
                        style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  SizedBox(height: 3),
                  Text(
                    mealName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    mealDesc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  if (isOwner) ...[
                    IconButton(
                      onPressed: onHide,
                      icon: const Icon(Icons.visibility_off, size: 20),
                      tooltip: "إخفاء",
                      color: Colors.orangeAccent,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(width: 12),
            // owner controls
            if (isOwner)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // edit button (rounded)
                  Material(
                    color: Colors.transparent,
                    child: IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_note_rounded, size: 25),
                      tooltip: "تعديل",
                    ),
                  ),
                  const SizedBox(height: 15),
                  IconButton(
                    onPressed: onDeletePermanent,
                    icon: const Icon(Icons.delete_forever, size: 20),
                    tooltip: "حذف نهائي",
                    color: Colors.redAccent,
                  ),
                ],
              )
            else
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
