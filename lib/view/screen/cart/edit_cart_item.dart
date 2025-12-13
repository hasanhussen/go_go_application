import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/edit_cart_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/imgaeasset.dart';
import 'package:go_go/linkapi.dart';
import 'package:lottie/lottie.dart';

class EditCartItem extends StatelessWidget {
  EditCartItem({super.key});
  final EditCartController controller = Get.put(EditCartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.red),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              controller.fromOrder ? 'تعديل طلبك ' : "تعديل السلة الشرائية",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
      body: GetBuilder<EditCartController>(
        builder: (controller) {
          if (controller.meal == null) {
            return Center(
                child: Lottie.asset(AppImageAsset.loading,
                    width: 250, height: 250));
          }
          return HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Padding(
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
                  if (controller.meal!.additionals != null &&
                      controller.meal!.additionals!.isNotEmpty)
                    _buildActionItems(),
                  const SizedBox(height: 16),
                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              controller.meal!.image == null || controller.meal!.image!.isEmpty
                  ? Image.asset(
                      "assets/images/store.png",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "${AppLink.imageststatic}/${controller.meal!.image}",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.meal!.name ?? "",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 4),
              Text(controller.meal!.description ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  )),
              SizedBox(height: 8),
              controller.variantId == null
                  ? Text('متوفر ${controller.meal!.quantity ?? 'دائماَ'} ',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                      ))
                  : controller.variant?.deletedAt != null
                      ? Container()
                      : Text(
                          'متوفر ${controller.variantQuantity ?? 'دائماَ'} '),
            ],
          ),
        ),
        controller.variant != null && controller.variant!.deletedAt != null
            ? Text(
                'غير متوفر',
                style: TextStyle(fontSize: 12, color: Colors.red),
              )
            : Column(
                children: [
                  controller.fromOrder &&
                          !controller.pricesAreEqual(
                              controller.cartItem.oldMealPrice,
                              controller.variantId != null
                                  ? controller.variantPrice
                                  : controller.meal!.price)
                      ? Row(
                          children: [
                            Text(
                              '${controller.cartItem.oldMealPrice ?? ''} \$',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${controller.meal!.price ?? controller.variantPrice} \$',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '${controller.meal!.price ?? controller.variantPrice}',
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
                      controller.increasecount();
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
    return SizedBox(
      height: 150,
      child: ListView.builder(
        itemCount: controller.meal!.additionals!.length,
        itemBuilder: (context, index) {
          final item = controller.meal!.additionals![index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.grey),
                const SizedBox(width: 12),
                Row(
                  children: [
                    Text(item.name!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 6),
                    controller.fromOrder &&
                            controller.cartItem.additionalItems != null &&
                            controller.cartItem.additionalItems!.length >
                                index &&
                            controller.cartItem.additionalItems![index].pivot
                                    ?.oldAdditionalPrice !=
                                item.price
                        ? Row(
                            children: [
                              Text(
                                '${controller.cartItem.additionalItems?[index].pivot?.oldAdditionalPrice ?? ''} \$',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${item.price!} \$',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : Text('${item.price!}',
                            style: const TextStyle(fontSize: 16)),
                    if (item.deletedAt != null) ...[
                      SizedBox(width: 8),
                      Text(
                        'غير متوفر',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ]
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, size: 20, color: Colors.orange),
                  onPressed: () {
                    controller.increaseAdditionalsCount(
                        item.id!, controller.meal!.id!);
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
                        item.id!, controller.meal!.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 22,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove, size: 20, color: Colors.red),
                      onPressed: () {
                        controller.decreasecount();
                      },
                    ),
                    Text('${controller.countmeal}',
                        style: TextStyle(fontSize: 16)),
                    IconButton(
                      icon: Icon(Icons.add, size: 20, color: Colors.orange),
                      onPressed: () {
                        controller.increasecount();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4),
                InkWell(
                  onTap: () {
                    controller.updateCart();
                  },
                  child: Text("تعديل",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      )),
                ),
              ],
            ),
          ),
          Text('${controller.totalPrice}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              )),
        ],
      ),
    );
  }

  Widget _buildVariantsSelector() {
    final cartItem = controller.cartItem;

    if (controller.variant == null) {
      return SizedBox(); // المنتج بدون مقاسات
    }

    if (controller.variant != null && controller.variant!.deletedAt != null) {
      return Column(
        children: [
          Text(controller.variant!.name ?? '', style: TextStyle(fontSize: 16)),
          SizedBox(height: 6),
          Text(
            'المقاس المختار لم يعد متوفر',
            style: TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      );
    }

    return Text(controller.variant?.name ?? '', style: TextStyle(fontSize: 16));
  }
}
