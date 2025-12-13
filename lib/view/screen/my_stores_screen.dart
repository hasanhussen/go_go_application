import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/my_stores_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/view/widgets/mystore/blockedStoreCard.dart';
import 'package:go_go/view/widgets/mystore/rejectedStoreCard.dart';
import 'package:go_go/view/widgets/store_card.dart';
import 'package:auto_size_text/auto_size_text.dart';

class MyStoresScreen extends StatelessWidget {
  const MyStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyStoresController>(
      init: MyStoresController(),
      builder: (controller) {
        // إنشاء ValueNotifier للتاب المحدد
        final selectedIndex = ValueNotifier<int>(0);

        // قائمة أسماء التابات
        final tabs = [
          "الفعّالة",
          "بانتظار الموافقة",
          "المحظورة",
          "مرفوضة / محذوفة",
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "متاجري",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.red),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 🌟 TabBar مخصص
              Container(
                color: Colors.white,
                height: 50,
                child: ValueListenableBuilder<int>(
                  valueListenable: selectedIndex,
                  builder: (context, value, child) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: false, // طبيعي من اليمين لليسار
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: tabs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final isSelected = index == value;
                        return GestureDetector(
                          onTap: () {
                            selectedIndex.value = index;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? const Border(
                                      bottom: BorderSide(
                                          color: Colors.red, width: 2),
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              tabs[index],
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.red : Colors.grey[600],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // 🌟 محتوى التابات
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: selectedIndex,
                  builder: (context, value, child) {
                    switch (value) {
                      case 0:
                        return _buildStoreList(
                          controller.activeStores,
                          controller,
                          emptyMessage: "لا توجد متاجر فعالة.",
                          includeBlocked: true,
                        );
                      case 1:
                        return _buildStoreList(
                          controller.newStores,
                          controller,
                          emptyMessage: "لا توجد متاجر بانتظار الموافقة.",
                        );
                      case 2:
                        return _buildStoreList(
                          controller.blockedStores,
                          controller,
                          emptyMessage: "لا توجد متاجر محظورة.",
                          includeBlocked: true,
                        );
                      case 3:
                        return _buildStoreList(
                          controller.deletedStores,
                          controller,
                          emptyMessage: "لا توجد متاجر مرفوضة أو محذوفة.",
                          showRejectionReason: true,
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.goToAddStore,
            backgroundColor: Colors.red,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  // 🧩 نفس دالة بناء المتاجر اللي عندك
  Widget _buildStoreList(
    List<MyStoreModel> stores,
    MyStoresController controller, {
    required String emptyMessage,
    bool includeBlocked = false,
    bool showRejectionReason = false,
  }) {
    if (stores.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final store = stores[index];

        if (includeBlocked && store.status == '2') {
          return BlockedStoreCard(store: store, controller: controller);
        }

        if (showRejectionReason) {
          return Rejectedstorecard(store: store, controller: controller);
        }

        return StoreCard(
          store: store,
          onEdit: () => controller.gotoedit(
              store.id.toString(),
              store.name!,
              store.address!,
              store.delivery!,
              store.companyType!,
              "1",
              store.phone ?? "",
              store.special ?? "",
              store.image ?? "",
              store.cover ?? "",
              store.workingHours ?? []),
          onDelete: () => controller.deletestore(store.id!),
          onTap: () => controller.goToProfileDetails(store.id!),
        );
      },
    );
  }
}
