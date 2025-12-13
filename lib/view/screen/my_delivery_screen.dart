import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/my_delivery_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/data/model/order_model.dart';
import 'package:go_go/view/widgets/order/card_oders_delivery.dart';

class MyDeliveryScreen extends StatelessWidget {
  const MyDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyDeliveryController>(
      init: MyDeliveryController(),
      builder: (controller) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "طلبات التوصيل",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.red),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: TabBar(
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.red,
                  tabs: const [
                    Tab(text: "الجديدة"),
                    Tab(text: "قيد المعالجة"),
                    Tab(text: " مكتملة "),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: HandlingDataRequest(
              statusRequest: controller.statusRequest,
              widget: TabBarView(
                children: [
                  buildOrderList(
                    controller.newDeliveryOrders,
                    emptyMessage: "لا توجد طلبات جديدة.",
                    includeBlocked: true,
                  ),
                  buildOrderList(
                    controller.myDeliveryOrders,
                    emptyMessage: "لا توجد طلبات بانتظار قيد المعالجة.",
                  ),
                  buildOrderList(
                    controller.completedDeliveryOrders,
                    emptyMessage: "لا توجد طلبات مكتملة.",
                    showRejectionReason: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🧩 بناء قائمة المتاجر لكل تبويب
  Widget buildOrderList(
    List<OrderModel> orders, {
    required String emptyMessage,
    bool includeBlocked = false,
    bool showRejectionReason = false,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) => CardOdersDelivery(
        listdata: orders[index],
      ),
    );
  }
}
