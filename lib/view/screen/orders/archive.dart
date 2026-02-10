import 'package:go_go/controller/orders/archive_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/view/widgets/order/orderslistcard.dart';

class OrdersArchice extends GetView<OrdersArchiveController> {
  const OrdersArchice({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('140'.tr),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: GetBuilder<OrdersArchiveController>(
              builder: ((controller) => HandlingDataView(
                    statusRequest: controller.statusRequest,
                    widget: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            " الطلبات المكتملة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (controller.archiveOrders.isEmpty)
                            const Center(
                              child: Text(
                                "لا توجد طلبات مكتملة بعد",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.archiveOrders.length,
                              itemBuilder: (context, index) => CardOrdersList(
                                listdata: controller.archiveOrders[index],
                              ),
                            ),
                          const SizedBox(height: 20),
                          const Divider(thickness: 1.2),
                          const SizedBox(height: 10),
                          const Text(
                            "الطلبات المرفوضة/المحذوفة",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (controller.rejectedOrders.isEmpty)
                            const Center(
                              child: Text(
                                "لا توجد طلبات مرفوضة/محذوفة حالياً",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.rejectedOrders.length,
                              itemBuilder: (context, index) => CardOrdersList(
                                listdata: controller.rejectedOrders[index],
                              ),
                            ),
                        ],
                      ),
                    ),

                   
                  ))),
        ));
  }
}
