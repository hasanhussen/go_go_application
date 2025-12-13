import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/orders/checkout_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/widgets/order/order_coupon_button.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});
  final CheckoutController controller = Get.put(CheckoutController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            automaticallyImplyLeading: false, // لإلغاء زر الرجوع تلقائي
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "تفاصيل الطلب",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 17,
                  ),
                ),
                controller.fromOrder && controller.pendingOrder
                    ? ElevatedButton.icon(
                        onPressed: () {
                          // الانتقال لشاشة إضافة منتج جديد
                          controller.addnewProduct();
                        },
                        icon: const Icon(Icons.add,
                            color: Colors.white, size: 20),
                        label: const Text(
                          "إضافة منتج",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          Get.back(); // أو أي وظيفة للرجوع
                        },
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 18, color: Colors.red),
                      ),
              ],
            ),
          ),

          body: HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.isitemdelet == true)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(
                        "⚠ هناك عناصر محذوفة في طلبك",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // 🔹 المنتجات
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.cartItems.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = controller.cartItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // الصورة (ثابتة الحجم)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 70,
                                  height: 70,
                                  child: product.meal!.image == null
                                      ? Image.asset("assets/images/store.png",
                                          fit: BoxFit.cover)
                                      : Image.network(
                                          "${AppLink.imageststatic}/${product.meal!.image!}",
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // الاسم + الإضافات + حالة التوفر
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // اسم المنتج + الكمية
                                        Expanded(
                                          child: Text(
                                            '${product.meal!.name!} x${product.quantity}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        // أزرار Edit/Delete
                                        // if (controller.fromOrder &&
                                        //     controller.pendingOrder) ...[
                                        //   if (controller.cartItems[index].meal!
                                        //           .isActive ==
                                        //       1)
                                        //     IconButton(
                                        //       padding: EdgeInsets.zero,
                                        //       constraints: const BoxConstraints(),
                                        //       onPressed: () {
                                        //         controller.gotoEdit(
                                        //           controller
                                        //               .cartItems[index].mealId!,
                                        //           controller.cartItems[index].id!,
                                        //           controller
                                        //               .cartItems[index].quantity!,
                                        //           controller.cartItems[index]
                                        //               .additionalItems!,
                                        //           controller.cartItems[index],
                                        //           controller
                                        //               .cartItems[index].variantId,
                                        //         );
                                        //       },
                                        //       icon: const Icon(
                                        //           Icons.edit_outlined,
                                        //           size: 18),
                                        //     ),
                                        //   IconButton(
                                        //     padding: EdgeInsets.zero,
                                        //     constraints: const BoxConstraints(),
                                        //     onPressed: () {
                                        //       Get.defaultDialog(
                                        //         title: "تأكيد الحذف",
                                        //         middleText:
                                        //             "هل تريد حذف هذا المنتج من طلبك؟",
                                        //         textCancel: "إلغاء",
                                        //         textConfirm: "حذف",
                                        //         confirmTextColor: Colors.white,
                                        //         buttonColor: Colors.red,
                                        //         onConfirm: () {
                                        //           controller.deletorderItem(
                                        //             controller.cartItems[index].id
                                        //                 .toString(),
                                        //           );
                                        //         },
                                        //       );
                                        //     },
                                        //     icon: const Icon(Icons.delete_outline,
                                        //         size: 18, color: Colors.red),
                                        //   ),
                                        // ],
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    // عرض المقاس المختار إذا موجود
                                    if (product.variant != null) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "المقاس: ${product.variant!.name}", // اسم المقاس
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    // الإضافات
                                    if (product.additionalItems != null &&
                                        product
                                            .additionalItems!.isNotEmpty) ...[
                                      Wrap(
                                        spacing: 4,
                                        runSpacing: 2,
                                        children: product.additionalItems!
                                            .map(
                                              (e) => Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${e.name} (${e.pivot!.quantity})',
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    if (product.meal != null &&
                                        product.meal!.store != null) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          "من: ${product.meal!.store!.name}", // اسم المتجر
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                    if (controller
                                            .cartItems[index].meal!.isActive !=
                                        1)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Text(
                                          "غير متوفر",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 10),

                              // السعر
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // السعر
                                  Text(
                                    controller.fromOrder == true
                                        ? "\$${(product.oldPrice!.toStringAsFixed(2))}"
                                        : "\$${(product.price!.toStringAsFixed(2))}",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  // أزرار Edit/Delete تحت السعر
                                  if (controller.fromOrder &&
                                      controller.pendingOrder)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (controller.cartItems[index].meal!
                                                .isActive ==
                                            1)
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              controller.gotoEdit(
                                                controller
                                                    .cartItems[index].mealId!,
                                                controller.cartItems[index].id!,
                                                controller
                                                    .cartItems[index].quantity!,
                                                controller.cartItems[index]
                                                    .additionalItems!,
                                                controller.cartItems[index],
                                                controller
                                                    .cartItems[index].variantId,
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.edit_outlined,
                                                size: 18),
                                          ),
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "تأكيد الحذف",
                                              middleText:
                                                  "هل تريد حذف هذا المنتج من طلبك؟",
                                              textCancel: "إلغاء",
                                              textConfirm: "حذف",
                                              confirmTextColor: Colors.white,
                                              buttonColor: Colors.red,
                                              onConfirm: () {
                                                controller.deletorderItem(
                                                    controller.cartItems[index]
                                                        .mealId!,
                                                    cartVariantId: controller
                                                        .cartItems[index]
                                                        .variantId);
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.delete_outline,
                                              size: 18, color: Colors.red),
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
                  ),
                  const SizedBox(height: 20),

                  // 🔹 في حال وجود طلبات قيد التحضير
                  if (controller.processingOrders.isNotEmpty) ...[
                    const Text(
                      "في حال كنت تريد هذا الطلب إلى عنوان طلب سابق يتم تحضيره لك يرجى الضغط على رقم الطلب:",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🔹 عرض أرقام الطلبات بشكل جميل
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.processingOrders.map((order) {
                        final isSelected = controller.linkedOrder != null &&
                            controller.linkedOrder!.id == order.id;

                        return GestureDetector(
                          onTap: () {
                            controller.togglelinkedWithOrder(order.id!);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.red.shade100
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? Colors.red
                                    : Colors.grey.shade300,
                                width: 1.2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              "#${order.id}",
                              style: TextStyle(
                                color: isSelected ? Colors.red : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                  ],

                  // 🔹 العنوان
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("العنوان:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.secondColor,
                                  fontSize: 16)),
                          const SizedBox(height: 10),
                          controller.isEditingAddress
                              ? TextField(
                                  controller: controller.addresscontroller,
                                  decoration: InputDecoration(
                                    hintText: "أدخل عنوان التوصيل",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.indigo),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.deepOrange,
                                          width: 2), // اللون عند الكتابة
                                    ),
                                  ),
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty) {
                                      controller.setAddress(value);
                                    }
                                  },
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.address ?? "",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    if (controller.pendingOrder == true)
                                      TextButton(
                                        onPressed:
                                            controller.toggleAddressEditing,
                                        child: Text("تعديل"),
                                      ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔹 تفاصيل الأسعار
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          _buildRow(
                              "سعر المنتجات",
                              "\$${controller.productsPrice.toStringAsFixed(2)}",
                              () {}),
                          _buildRow("سعر التوصيل",
                              "\$${controller.deliveryPrice}", () {}),
                          if (controller.couponname != null ||
                              controller.fromOrder == true)
                            _buildRow("الكوبون",
                                controller.couponname ?? 'الطلب لا يملك كوبون',
                                () {
                              controller.editCoupon();
                            }, canEdit: true),
                          if (controller.couponname != null)
                            _buildRow(
                                "الخصم",
                                "-\$${controller.discount!.toStringAsFixed(2)}",
                                () {}),
                          _buildRow(
                              "طريقة الدفع", "-\$${controller.paymentMethod!}",
                              () {
                            controller.togglePaymentEditing();
                          }, canEdit: true),
                          const Divider(),
                          _buildRow(
                              "السعر الإجمالي",
                              "\$${controller.totalPrice.toStringAsFixed(2)}",
                              () {},
                              isTotal: true),
                        ],
                      ),
                    ),
                  ),

                  if (controller.showCouponField == true) OrderCouponButton(),

                  if (controller.note != null &&
                      controller.note!.trim().isNotEmpty)
                    const SizedBox(height: 20),
                  if (controller.note != null &&
                      controller.note!.trim().isNotEmpty)
                    Card(
                      color: Colors.transparent, // جعل خلفية Card شفافة
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("ملاحظات",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.secondColor,
                                    fontSize: 16)),
                            const SizedBox(height: 10),
                            controller.isEditingAddress
                                ? TextField(
                                    controller: controller.addresscontroller,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.indigo),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            color: Colors.deepOrange,
                                            width: 2), // اللون عند الكتابة
                                      ),
                                    ),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        controller.setNote(value);
                                      }
                                    },
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        controller.note!,
                                        style: TextStyle(
                                            color: AppColor.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Spacer(),
                                      if (controller.pendingOrder == true)
                                        TextButton(
                                          onPressed:
                                              controller.toggleNoteEditing,
                                          child: Text("تعديل"),
                                        ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // 🔹 زر اسفل الشاشة

          bottomNavigationBar: controller.pendingOrder
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔹 زر رئيسي
                      ElevatedButton(
                        onPressed: () {
                          controller.fromOrder == false
                              ? controller.confirmOrder()
                              : controller.confirmeditOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.fromOrder
                            ? Text(
                                "إرسال التعديلات",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              )
                            : Text(
                                controller.paymentMethod == 'cash'
                                    ? "إرسال الطلب"
                                    : "إدخال معلومات الدفع و إارسال الطلب",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),

                      // 🔸 زر تعديل البطاقة (يظهر فقط في حال الدفع بالبطاقة)
                      if (controller.paymentMethod == 'card' &&
                          controller.fromOrder) ...[
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            controller
                                .showPaymentDetails(); // ← تضيفها بالـController
                          },
                          icon:
                              const Icon(Icons.credit_card, color: Colors.red),
                          label: const Text(
                            "تعديل أو تغيير البطاقة",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : controller.fromDeliver && controller.orderStatus != '4'
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔹 زر رئيسي
                          ElevatedButton(
                            onPressed: () {
                              controller.changeOrderStatus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              controller.orderStatus == "5"
                                  ? "Approve"
                                  : controller.orderStatus == "1"
                                      ? "on The Way"
                                      : controller.orderStatus == "2"
                                          ? "on Site"
                                          : "Delivered",
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
        );
      },
    );
  }

  Widget _buildRow(String title, String value, void Function()? onTap,
      {bool isTotal = false, bool canEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  fontSize: isTotal ? 18 : 15,
                  color: isTotal ? Colors.red : Colors.black87)),
          title == "طريقة الدفع" && controller.isEditingPayment == true
              ? Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // ✅ Cash
                        Row(
                          children: [
                            Checkbox(
                              value: controller.tempPaymentMethod == "cash",
                              onChanged: (val) {
                                if (val == true) {
                                  controller.tempPaymentMethod = "cash";
                                  controller.update();
                                }
                              },
                            ),
                            const Text("Cash"),
                          ],
                        ),

                        // ✅ Card
                        Row(
                          children: [
                            Checkbox(
                              value: controller.tempPaymentMethod == "card",
                              onChanged: (val) {
                                if (val == true) {
                                  controller.tempPaymentMethod = "card";
                                  controller.update();
                                }
                              },
                            ),
                            const Text("Card"),
                          ],
                        ),

                        // 🔘 زر الحفظ
                        TextButton(
                          onPressed: controller.savePaymentMethod,
                          child: const Text("حفظ"),
                        ),

                        // 🔘 زر الإلغاء
                        TextButton(
                          onPressed: controller.togglePaymentEditing,
                          child: const Text("إلغاء"),
                        ),
                      ],
                    ),
                  ),
                )
              : Row(
                  children: [
                    Text(value,
                        style: TextStyle(
                            fontWeight:
                                isTotal ? FontWeight.bold : FontWeight.normal,
                            fontSize: isTotal ? 18 : 15,
                            color: isTotal ? Colors.red : Colors.black87)),
                    if (canEdit == true &&
                        controller.fromOrder == true &&
                        controller.pendingOrder == true)
                      Container(
                          padding: EdgeInsetsDirectional.only(start: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: onTap,
                                child: Icon(Icons.edit_document,
                                    size: 25), // أيقونة أصغر
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'تعديل',
                                style: TextStyle(
                                    fontSize: 11,
                                    height: 1), // height=1 يخلي النص قريب
                              ),
                            ],
                          )),
                  ],
                ),
        ],
      ),
    );
  }
}
