import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/edit_meal_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/linkapi.dart';

class EditMealView extends StatelessWidget {
  EditMealView({super.key});
  final EditMealController controller = Get.put(EditMealController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditMealController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("تعديل منتج"),
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // اسم المنتج
                  _buildTextField(controller.nameMealController, "اسم المنتج"),
                  const SizedBox(height: 12),

                  if (controller.variantNameControllers.isEmpty) ...[
                    _buildTextField(controller.priceMealController, "السعر",
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    controller.alwaysAvailable
                        ? const SizedBox.shrink()
                        : _buildTextField(
                            controller.quantityController, "الكمية",
                            keyboardType: TextInputType.number),
                    Row(
                      children: [
                        Checkbox(
                          value: controller.alwaysAvailable,
                          onChanged: (val) =>
                              controller.toggleAlwaysAvailable(val ?? false),
                          activeColor: Colors.redAccent,
                        ),
                        const Text("متوفر دائمًا"),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // الوصف
                  _buildTextField(controller.descriptionController, "الوصف",
                      maxLines: 3),
                  const SizedBox(height: 12),

                  // الصورة + الكمية + متوفر دائمًا
                  Text("صورة المنتج",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.redAccent)),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الصورة
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: controller.selectedImage != null
                              ? Image.file(controller.selectedImage!,
                                  fit: BoxFit.cover)
                              : controller.selectedImageName != null
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          "${AppLink.imageststatic}/${controller.selectedImageName!}",
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Icon(Icons.add_a_photo,
                                          color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // الكمية + متوفر دائمًا
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // المقاسات
                          if (controller.variantNameControllers.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "المقاسات",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.redAccent),
                                ),
                                const SizedBox(height: 10),
                                ...List.generate(
                                  controller.variantNameControllers.length,
                                  (index) {
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            _buildTextField(
                                                controller
                                                        .variantNameControllers[
                                                    index],
                                                "اسم المقاس"),
                                            const SizedBox(height: 6),
                                            _buildTextField(
                                                controller
                                                        .variantPriceControllers[
                                                    index],
                                                "السعر",
                                                keyboardType:
                                                    TextInputType.number),
                                            const SizedBox(height: 6),
                                            _buildTextField(
                                                controller
                                                        .variantQuantityControllers[
                                                    index],
                                                "الكمية",
                                                keyboardType:
                                                    TextInputType.number),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.redAccent),
                                                onPressed: () => controller
                                                    .removeVariantField(index),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                TextButton.icon(
                                  onPressed: () => controller.addVariantField(),
                                  icon: const Icon(Icons.add),
                                  label: const Text("إضافة مقاس جديد"),
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ] else ...[
                            Column(
                              children: [
                                const Text("هل منتجك متعدد المقاسات؟ "),
                                TextButton(
                                  onPressed: () {
                                    controller
                                        .toggleIsVariant(!controller.isVariant);
                                  },
                                  child: Text(controller.isVariant
                                      ? "إلغاء"
                                      : "اضغط هنا"),
                                ),
                              ],
                            ),
                          ],
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // الإضافات
                  Text("الإضافات",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.redAccent)),
                  const SizedBox(height: 10),

                  // قائمة الإضافات
                  ...List.generate(controller.additionals.length, (index) {
                    final addition = controller.additionals[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CheckboxListTile(
                        value: controller.selectedAdditionalsId
                            .contains(addition.id.toString()),
                        onChanged: (val) {
                          controller.toggleAddition(index, val ?? false);
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        title: Row(
                          children: [
                            Expanded(
                                child: Text(addition.name!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                _showAddAdditionDialog(context, controller,
                                    isEdit: true, additionalId: addition.id);
                              },
                              icon: const Icon(
                                Icons.edit_note_outlined,
                                size: 16,
                              ),
                              label: const Text("Edit"),
                            ),
                            const SizedBox(width: 6),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "تأكيد الحذف",
                                  middleText:
                                      "هل أنت متأكد أنك تريد حذف هذا الإضافة؟",
                                  textCancel: "إلغاء",
                                  textConfirm: "حذف",
                                  confirmTextColor: Colors.white,
                                  buttonColor: Colors.red,
                                  onConfirm: () {
                                    controller.deleteAdditional(addition.id!);
                                    Get.back();
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 16,
                              ),
                              label: const Text("Delete"),
                            ),
                          ],
                        ),
                        subtitle: Text("${addition.price} \$"),
                        activeColor: Colors.redAccent,
                      ),
                    );
                  }),

                  // زر إضافة جديدة
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddAdditionDialog(context, controller);
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "إضافة جديدة",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // زر الحفظ
                  ElevatedButton(
                    onPressed: () {
                      controller.editmeal();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("حفظ التعديل",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1,
      TextInputType keyboardType = TextInputType.text,
      Key? key}) {
    return TextFormField(
      key: key,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      validator: (value) {
        if (label == 'الكمية' && value != null) {
          validInput(value, 1, 4, 'quantity');
        }
        return null;
      },
    );
  }

  _showAddAdditionDialog(BuildContext context, EditMealController controller,
      {int? additionalId, bool isEdit = false}) {
    isEdit ? controller.openEditAdiitional(additionalId!) : null;
    Get.dialog(
      AlertDialog(
        title: isEdit
            ? const Text("تعديل الإضافة ")
            : const Text("إدخال إضافة جديدة"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller.nameController, "اسم الإضافة"),
              const SizedBox(height: 10),
              _buildTextField(controller.priceController, "السعر",
                  keyboardType: TextInputType.number),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: controller.additionalAlwaysAvailable,
                    activeColor: Colors.redAccent,
                    onChanged: (val) {
                      controller.toggleAdditionalAvailable(val!);
                    },
                  ),
                  const Text("متوفرة دائمًا"),
                ],
              ),
              if (!controller.additionalAlwaysAvailable)
                _buildTextField(
                  controller.quantityAdditionalController,
                  "الكمية",
                  keyboardType: TextInputType.number,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("إلغاء"),
            onPressed: () => Get.back(),
          ),
          ElevatedButton(
            child: isEdit ? const Text("تعديل") : const Text("إضافة"),
            onPressed: () {
              if (controller.nameController.text.isNotEmpty &&
                  controller.priceController.text.isNotEmpty) {
                isEdit
                    ? controller.editAaddtional(additionalId.toString())
                    : controller.addNewAddition();
              }
            },
          ),
        ],
      ),
    );
  }
}
