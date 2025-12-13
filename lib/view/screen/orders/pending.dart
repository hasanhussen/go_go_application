import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/view/widgets/order/orderslistcard.dart';

class OrdersPending extends StatelessWidget {
  const OrdersPending({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(OrdersPendingController());
    return Scaffold(
      appBar: AppBar(
        title: Text('84'.tr),
        actions: [
          GetBuilder<OrdersPendingController>(
            builder: (controller) => InkWell(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [Icon(Icons.archive_outlined), Text('140'.tr)],
                ),
              ),
              onTap: () {
                controller.gotoArchive();
              },
            ),
          )
        ],
      ),
      body: GetBuilder<OrdersPendingController>(
        builder: (controller) => HandlingDataView(
          statusRequest: controller.statusRequest,
          widget: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟥 قسم الطلبات قيد التنفيذ
                const Text(
                  "الطلبات قيد التنفيذ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                if (controller.processingOrders.isEmpty)
                  const Center(
                    child: Text(
                      "لا توجد طلبات قيد التنفيذ حالياً",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.processingOrders.length,
                    itemBuilder: (context, index) => CardOrdersList(
                      listdata: controller.processingOrders[index],
                    ),
                  ),

                const SizedBox(height: 20),
                const Divider(thickness: 1.2),

                // 🟨 قسم الطلبات بانتظار الموافقة
                const SizedBox(height: 10),
                const Text(
                  "الطلبات بانتظار الموافقة",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                if (controller.waitingOrders.isEmpty)
                  const Center(
                    child: Text(
                      "لا توجد طلبات بانتظار الموافقة حالياً",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.waitingOrders.length,
                    itemBuilder: (context, index) => CardOrdersList(
                      listdata: controller.waitingOrders[index],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
