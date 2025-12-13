import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/meal_trash_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/functions/showAppeaDialog.dart';
import 'package:go_go/linkapi.dart';

class MealTrashScreen extends StatelessWidget {
  MealTrashScreen({super.key});
  final MealTrashController controller = Get.put(MealTrashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(' سلة مهملات المنتجات',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18)),
        backgroundColor: const Color.fromARGB(255, 244, 243, 243),
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
                  // const Text("طلب جديد", style: TextStyle(color: Colors.red, fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
      body: GetBuilder<MealTrashController>(
        builder: (controller) => HandlingDataRequest(
          statusRequest: controller.statusRequest,
          widget: controller.hiddenMeals.isEmpty &&
                  controller.trashedMeals.isEmpty
              ? Center(
                  child: Text(" سلة المهملات فارغة"),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // القسم الأول: المنتجات المخفية
                        Text("🍽️ المنتجات المخفية",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        controller.hiddenMeals.isEmpty
                            ? const Text("لا يوجد منتجات مخفية")
                            : Column(
                                children: controller.hiddenMeals.map((meal) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: meal.image != null
                                            ? NetworkImage(
                                                '${AppLink.imageststatic}/${meal.image!}')
                                            : null,
                                        backgroundColor: Colors.red[100],
                                      ),
                                      title: Text(meal.name ?? ''),
                                      subtitle: Text(meal.description ?? ''),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.restore,
                                            color: Colors.green),
                                        onPressed: () {
                                          controller.restoreHidden(
                                              meal.id.toString());
                                        },
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                        const SizedBox(height: 30),

                        // القسم الثاني: المنتجات المحذوفة
                        Text("🗑️ المنتجات المحذوفة",
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 10),
                        controller.trashedMeals.isEmpty
                            ? const Text("لا يوجد منتجات محذوفة")
                            : Column(
                                children: controller.trashedMeals.map((meal) {
                                  return Card(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: CircleAvatar(
                                              backgroundImage: meal.image !=
                                                      null
                                                  ? NetworkImage(
                                                      '${AppLink.imageststatic}/${meal.image!}')
                                                  : null,
                                              backgroundColor: Colors.grey[400],
                                            ),
                                            title: Text(meal.name ?? '',
                                                style: const TextStyle(
                                                    color: Colors.black54)),
                                            subtitle: const Text(
                                              "بانتظار موافقة المسؤولين",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.black54),
                                            ),
                                            trailing: const Icon(Icons.lock,
                                                color: Colors.grey),
                                          ),

                                          const SizedBox(height: 10),
                                          if (meal.deleteReason != null) ...[
                                            Text(
                                                "📄 السبب: ${meal.deleteReason}",
                                                style: const TextStyle(
                                                    color: Colors.grey)),
                                            const SizedBox(height: 12),
                                          ],

                                          /// زر الاعتراض
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (meal.appeal != null)
                                                Text("📄تم تقديم طلب استئناف",
                                                    style: const TextStyle(
                                                        color: Colors.grey)),
                                              SizedBox(width: 15),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      showAppealDialog(
                                                          context,
                                                          mealController:
                                                              controller,
                                                          mealId: meal.id!),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red.shade400,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  icon: const Icon(Icons.flag,
                                                      color: Colors.white,
                                                      size: 20),
                                                  label: const Text("اعتراض",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
