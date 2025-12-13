import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/linkapi.dart';

class BannedMealsSection extends StatelessWidget {
  const BannedMealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResturantProfileController>();
    return GetBuilder<ResturantProfileController>(
      builder: (controller) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
              Row(
                children: [
                  const Icon(Icons.block, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  const Text(
                    "منتجات محظورة",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      controller.getbanedMeal(controller.id);
                    },
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    tooltip: "تحديث",
                  ),
                ],
              ),
              const SizedBox(height: 10),
              controller.banedmeals.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.banedmeals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final meal = controller.banedmeals[index];
                        return _BannedMealCard(
                          mealName: meal.name ?? '',
                          mealDesc: meal.description ?? '',
                          mealImg: meal.image,
                          onDelete: () =>
                              controller.deleteMealPermanent(meal.id!),
                          onTap: () => controller.showMealDetails(index),
                          onEdit: () => controller.gotoEditMeal(meal.id!),
                        );
                      },
                    )
                  : const Text(
                      "لا يوجد منتجات محظورة حالياً",
                      style: TextStyle(color: Colors.grey),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _BannedMealCard extends StatelessWidget {
  final String mealName;
  final String mealDesc;
  final String? mealImg;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onTap;

  const _BannedMealCard({
    required this.mealName,
    required this.mealDesc,
    required this.mealImg,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
        ),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealName,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    mealDesc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Column(children: [
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_forever,
                    color: Colors.redAccent, size: 20),
                tooltip: "حذف",
              ),
              IconButton(
                onPressed: onEdit,
                icon: const Icon(
                  Icons.edit_document,
                  color: Colors.orange,
                  size: 18,
                ),
                tooltip: "حذف",
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
