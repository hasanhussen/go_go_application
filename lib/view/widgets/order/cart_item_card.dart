import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/linkapi.dart';
import '../../../controller/cart/cart_controller.dart';

class CartItemCard extends GetView<CartController> {
  const CartItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.cartItems.length,
        itemBuilder: (context, index) {
          final item = controller.cartItems[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row الصورة + اسم المنتج + الكمية
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة المنتج
                    item.meal!.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${AppLink.imageststatic}/${item.meal!.image!}', // حط رابط الصورة هنا
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, color: Colors.white),
                          ),
                    const SizedBox(width: 10),
                    // الاسم والكمية
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.meal!.name!,
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'الكمية: ${item.quantity!}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                if (item.variant != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'المقاس: ${item.variant!.name}',
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
                // الإضافات
                if (item.additionalItems != null &&
                    item.additionalItems!.isNotEmpty)
                  Row(
                    children: item.additionalItems!
                        .map((e) => Row(
                              children: [
                                Text('${e.name}',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                const SizedBox(width: 3),
                                Text('(${e.pivot!.quantity})   ',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ))
                        .toList(),
                  ),
                if (item.meal != null && item.meal!.store != null) ...[
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'من: ${item.meal!.store!.name}',
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                // تعديل + حذف + السعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () {
                          controller.gotoEdit(
                              item.mealId!,
                              item.id!,
                              item.quantity!,
                              item.additionalItems!,
                              item.variantId);
                        },
                        child: const Text("تعديل",
                            style: TextStyle(color: Colors.red))),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.deleteItem(item.id.toString());
                      },
                    ),
                    item.price == item.oldPrice
                        ? Text(
                            '${item.price!} \$',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                '${item.oldPrice!} \$',
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
                          ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
