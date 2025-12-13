import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/edit_store_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/data/model/category_model.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/screen/map_picker_page.dart';

class EditStoreScreen extends StatelessWidget {
  const EditStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditStoreController>(
      init: EditStoreController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text("119".tr, style: TextStyle(color: Colors.red)),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.red),
            centerTitle: true,
          ),
          body: HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formstate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("94".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "94".tr,
                        ),
                        validator: (value) {
                          return validInput(value!, 1, 30, "name");
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("95".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: controller.pickLogo,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.logoImage != null
                            ? Image.file(controller.logoImage!,
                                fit: BoxFit.cover)
                            : controller.logoImageName != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${AppLink.imageststatic}/${controller.logoImageName!}",
                                    // controller.file!,
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 80,
                                  )
                                //Image.file(controller.logoImage!, fit: BoxFit.cover)
                                : const Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("141".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: controller.pickCover,
                      child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: controller.coverImage != null
                            ? Image.file(controller.coverImage!,
                                fit: BoxFit.cover)
                            : controller.coverImageName != null
                                ? CachedNetworkImage(
                                    imageUrl:
                                        "${AppLink.imageststatic}/${controller.coverImageName!}",
                                    // controller.file!,
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: 80,
                                  )
                                : const Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.red)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("142".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: controller.phoneController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "143".tr,
                        ),
                        validator: (value) {
                          return validInput(value!, 10, 12, "phone");
                          // if (value!.isEmpty) {
                          //   return "144".tr;
                          // }
                          // return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("96".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: controller.addressController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "117".tr,
                        ),
                        validator: (value) {
                          return validInput(value!, 10, 50, "address");
                          // if (value!.isEmpty) {
                          //   return "115".tr;
                          // } else if (value.length > 50) {
                          //   return "can't be larger than 50";
                          // }
                          // return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Get.to(() => const MapPickerPage()),
                      icon: const Icon(Icons.location_on, color: Colors.red),
                      label: Text(
                        "97".tr,
                        style: TextStyle(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                    ),
                    const SizedBox(height: 30),
                    Text("98".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<CategoryModel>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        isExpanded: true,
                        value: controller.selectedCategory,
                        hint: Text("99".tr),
                        items: controller.services.map((category) {
                          return DropdownMenuItem<CategoryModel>(
                            value: category,
                            child: Text(category.type ?? ""),
                          );
                        }).toList(),
                        onChanged: (CategoryModel? selected) {
                          if (selected != null) {
                            controller.setStoreType2(selected);
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return "116".tr;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text("145".tr, style: TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.05),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: controller.specialController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "146".tr,
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    // const SizedBox(height: 30),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //         value: controller.hasDelivery,
                    //         onChanged: controller.toggleDelivery),
                    //     Text("100".tr)
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //         value: controller.isOnline,
                    //         onChanged: controller.toggleOnline),
                    //     Text("101".tr)
                    //   ],
                    // ),
                    const SizedBox(height: 30),
                    Text("102".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.openAlways.value,
                          onChanged: controller.setAlwaysOpen,
                        ),
                        Text("103".tr)
                      ],
                    ),
                    ...controller.weekDays.map((day) {
                      return Row(
                        children: [
                          Checkbox(
                            value: controller.selectedDays.contains(day),
                            onChanged: (val) => controller.toggleDay(day, val),
                          ),
                          Text(day)
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Text("104".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    ...controller.selectedDays.map((day) {
                      final times = controller.workingHours[day];
                      final from = times != null ? times['from'] : null;
                      final to = times != null ? times['to'] : null;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(day),
                          TextButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                  context: context,
                                  initialTime: from ??
                                      const TimeOfDay(hour: 9, minute: 0));
                              if (picked != null) {
                                controller.setTime(day, picked,
                                    to ?? const TimeOfDay(hour: 16, minute: 0));
                              }
                            },
                            child: Text(from != null
                                ? "${"105".tr}: ${from.format(context)}"
                                : "106".tr),
                          ),
                          TextButton(
                            onPressed: () async {
                              final picked = await showTimePicker(
                                  context: context,
                                  initialTime: to ??
                                      const TimeOfDay(hour: 16, minute: 0));
                              if (picked != null) {
                                controller.setTime(
                                    day,
                                    from ?? const TimeOfDay(hour: 9, minute: 0),
                                    picked);
                              }
                            },
                            child: Text(to != null
                                ? "${"107".tr}: ${to.format(context)}"
                                : "108".tr),
                          ),
                        ],
                      );
                    }).toList(),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.editStore();
                        print("📝 الاسم: ${controller.nameController!.text}");
                        print("📍 الموقع: ${controller.selectedLocation}");
                        print("🕒 أوقات الدوام: ${controller.workingHours}");
                        print("📅 الأيام: ${controller.selectedDays}");
                      },
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label:
                          Text("109".tr, style: TextStyle(color: Colors.white)),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
