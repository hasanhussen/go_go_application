import 'package:go_go/controller/my_delivery_controller.dart';
import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/data/model/order_model.dart';
import 'package:jiffy/jiffy.dart';

// ignore: must_be_immutable
class CardOdersDelivery extends GetView<MyDeliveryController> {
  final OrderModel listdata;
  // ignore: use_super_parameters
  CardOdersDelivery({Key? key, required this.listdata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// العنوان + التاريخ
            Row(
              children: [
                Text(
                  "Order #${listdata.id}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      Jiffy.parse(listdata.createdAt!).fromNow(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(),

            /// تفاصيل الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfo("132".tr, "${listdata.price} \$"),
                _buildInfo("133".tr, "${listdata.deliveryPrice} \$"),
              ],
            ),
            const SizedBox(height: 6),
            _buildInfo("134".tr, listdata.paymentMethod ?? ""),
            _buildInfo(
              "135".tr,
              controller.printOrderStatus(listdata.status),
            ),

            const Divider(),

            /// السعر الكلي + الأزرار بنفس السطر مع Scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Total :\$ ${listdata.totalPrice} ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (listdata.status != "4")
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                      onPressed: () {
                        controller.changeOrderStatus(
                            listdata.id.toString(), listdata.status!);
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      ),
                      label: Text(
                        listdata.status == "5"
                            ? "Approve"
                            : listdata.status == "1"
                                ? "on The Way"
                                : listdata.status == "2"
                                    ? "on Site"
                                    : "Delivered",
                      ),
                    ),
                  const SizedBox(width: 5),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      controller.getOrderDetails(
                          listdata.id.toString(), listdata.status!, []);
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text("Details"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min, // ✅ منع مشاكل Scroll
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 133, 128, 128),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
