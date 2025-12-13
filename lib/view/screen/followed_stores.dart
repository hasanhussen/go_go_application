import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/followed_stores_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/view/widgets/resturant_card.dart';

class FollowedStores extends StatelessWidget {
  final FollowedStoresController controller =
      Get.put(FollowedStoresController());

  FollowedStores({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("155".tr,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 234, 233, 233),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 18, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      body: GetBuilder<FollowedStoresController>(
        builder: (controller) {
          return controller.followedStores.isEmpty
              ? Center(
                  child: Text(
                    "No followed stores yet",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : HandlingDataRequest(
                  statusRequest: controller.statusRequest,
                  widget: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: controller.followedStores.length,
                    itemBuilder: (context, index) {
                      final store = controller.followedStores[index];

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: EdgeInsets.only(bottom: 14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => controller.goToProfileDetails(store.id!),
                          child: RestaurantCard(restaurant: store),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
