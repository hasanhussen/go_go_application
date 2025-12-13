import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/linkapi.dart';

class MealDetailsSheet extends GetView<ResturantProfileController> {
  final int index;
  const MealDetailsSheet({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResturantProfileController>(
      builder: (controller) => WillPopScope(
        onWillPop: () => controller.handleWillPop(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _buildProductHeader(),
              const SizedBox(height: 16),
              _buildVariantsSelector(),
              const SizedBox(height: 16),
              _buildDivider(),
              const SizedBox(height: 16),
              _buildActionItems(),
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: controller.meals[index].image == null
                ? Image.asset(
                    "assets/images/store.png",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    "${AppLink.imageststatic}/${controller.meals[index].image}",
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.meals[index].name!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 4),
              Text(controller.meals[index].description ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              SizedBox(height: 5),
              controller.selectedVariantId == null
                  ? controller.mostsellingmeals[index].variants!.isNotEmpty
                      ? Text('يرجى اختيار مقاس',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                          ))
                      : Text(
                          'متوفر ${controller.meals[index].quantity ?? 'دائماَ'} ',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                          ))
                  : Text('متوفر ${controller.variantQuantity ?? 'دائماَ'} '),
            ],
          ),
        ),
        Column(
          children: [
            controller.meals[index].price != null &&
                    controller.selectedVariantId == null
                ? Text('${controller.meals[index].price}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ))
                : controller.variantPrice == null
                    ? Text('يرجى اختيار مقاس',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ))
                    : Text('${controller.variantPrice}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        )),
            SizedBox(height: 8),
            IconButton(
              icon: Icon(Icons.add_circle, size: 32),
              color: Colors.orange,
              onPressed: () {
                controller.meals[index].variants!.isNotEmpty &&
                        controller.selectedVariantId == null
                    ? () {
                        Get.snackbar(
                          "تنبيه",
                          "يجب اختيار مقاس أولاً",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 12,
                          duration: const Duration(seconds: 2),
                        );
                      }
                    : controller.increasecount(controller.meals[index].id!);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildActionItems() {
    return Column(
      children: controller.meals[index].additionals!
          .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 8, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(item.name!,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('${item.price!}',
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'متوفر ${item.quantity ?? 'دائماَ'}',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                height: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20, color: Colors.orange),
                    onPressed: () {
                      controller.increaseAdditionalsCount(
                          item.id!, controller.meals[index].id!);
                    },
                  ),
                  Text(
                    '${controller.additionalscount[item.id] ?? 0}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle,
                        size: 20, color: Colors.red),
                    onPressed: () {
                      controller.decreaseAdditionalsCount(
                          item.id!, controller.meals[index].id!);
                    },
                  ),
                ],
              )))
          .toList(),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dropdown لاختيار الطلب
          if (controller.pendingOrderId != null &&
              controller.boolPendingOrder == true) ...[
            InkWell(
                onTap: () {
                  if (controller.meals[index].variants != null &&
                      controller.meals[index].variants!.isNotEmpty &&
                      controller.selectedVariantId == null) {
                    Get.snackbar("تنبيه", "يرجى اختيار المقاس أولاً",
                        backgroundColor: Colors.orange,
                        colorText: Colors.white);

                    return;
                  }

                  controller.addtocart(controller.meals[index].id!,
                      controller.pendingOrderId.toString()
                      // هون منمرر الطلب المختار
                      );
                },
                child: Text('إضافة إلى الطلب رقم${controller.pendingOrderId}')),

            // DropdownButton<int>(
            //   value: controller.selectedOrderId,
            //   hint: const Text("اختر طلب لإضافة المنتج"),
            //   items: controller.pendingOrders
            //       .map((order) => DropdownMenuItem<int>(
            //             value: order.id,
            //             child: Text("طلب رقم ${order.id}"),
            //           ))
            //       .toList(),
            //   onChanged: (value) {
            //     controller.selectedOrderId = value;
            //     controller.update();
            //   },
            // ),
            const SizedBox(height: 12),
          ],

          // باقي الأكشنات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 20, color: Colors.red),
                          onPressed: () {
                            controller.meals[index].variants!.isNotEmpty &&
                                    controller.selectedVariantId == null
                                ? () {
                                    Get.snackbar(
                                      "تنبيه",
                                      "يجب اختيار مقاس أولاً",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(12),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                : controller
                                    .decreasecount(controller.meals[index].id!);
                          },
                        ),
                        Text('${controller.countMeals}',
                            style: TextStyle(fontSize: 16)),
                        IconButton(
                          icon: Icon(Icons.add, size: 20, color: Colors.orange),
                          onPressed: () {
                            controller.meals[index].variants!.isNotEmpty &&
                                    controller.selectedVariantId == null
                                ? () {
                                    Get.snackbar(
                                      "تنبيه",
                                      "يجب اختيار مقاس أولاً",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor:
                                          Colors.red.withOpacity(0.8),
                                      colorText: Colors.white,
                                      margin: const EdgeInsets.all(12),
                                      borderRadius: 12,
                                      duration: const Duration(seconds: 2),
                                    );
                                  }
                                : controller
                                    .increasecount(controller.meals[index].id!);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        controller.addtocart(
                          controller.meals[index].id!,
                          '0', // هون منمرر الطلب المختار
                        );
                      },
                      child: const Text("إضافة",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          )),
                    ),
                  ],
                ),
              ),
              Text('${controller.totalPrice}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantsSelector() {
    final meal = controller.meals[index];

    if (meal.variants == null || meal.variants!.isEmpty) {
      return SizedBox(); // المنتج بدون مقاسات
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "اختر المقاس",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...meal.variants!.map((variant) {
          bool isSelected = controller.selectedVariantId == variant.id;

          return InkWell(
            onTap: () {
              controller.selectVariant(
                variant.id!,
                variant.price!,
                variant.quantity,
              );
            },
            child: Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    variant.name!,
                    style: TextStyle(fontSize: 16),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${variant.price} ل.س",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "متوفر: ${variant.quantity ?? 'دائماً'}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
