import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/functions/validinput.dart';
import 'package:go_go/controller/meal_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';

class AddMealView extends StatelessWidget {
  AddMealView({super.key});
  final MealController controller = Get.put(MealController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MealController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("إضافة منتج"),
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
                  // إدخال اسم المنتج
                  _buildTextField(controller.nameMealController, "اسم المنتج"),
                  const SizedBox(height: 12),

                  // خيار متعدد المقاسات
                  Row(
                    children: [
                      const Text("هل منتجك متعدد المقاسات؟ "),
                      TextButton(
                        onPressed: () {
                          controller.toggleIsVariant(!controller.isVariant);
                        },
                        child:
                            Text(controller.isVariant ? "إلغاء" : "اضغط هنا"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // السعر والكمية الأساسيين (تختفي إذا متعدد المقاسات)
                  if (!controller.isVariant) ...[
                    _buildTextField(controller.priceMealController, "السعر",
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: controller.alwaysAvailable
                          ? const SizedBox.shrink()
                          : _buildTextField(
                              controller.quantityMealController, "الكمية",
                              key: const ValueKey("quantityField")),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // حقول المقاسات إذا مفعل متعدد المقاسات
                  if (controller.isVariant)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "المقاسات",
                          style:
                              TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(
                          controller.variantNameControllers.length,
                          (index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    _buildTextField(
                                        controller
                                            .variantNameControllers[index],
                                        "اسم المقاس"),
                                    const SizedBox(height: 6),
                                    _buildTextField(
                                        controller
                                            .variantPriceControllers[index],
                                        "السعر",
                                        keyboardType: TextInputType.number),
                                    const SizedBox(height: 6),
                                    _buildTextField(
                                        controller
                                            .variantQuantityControllers[index],
                                        "الكمية",
                                        keyboardType: TextInputType.number),
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
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: controller.selectedImage == null
                                ? const Center(
                                    child: Icon(Icons.add_a_photo,
                                        color: Colors.grey, size: 40))
                                : Image.file(controller.selectedImage!,
                                    fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 12),
                      if (!controller.isVariant)
                        Expanded(
                          child: Column(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: controller.alwaysAvailable
                                    ? const SizedBox.shrink()
                                    : _buildTextField(
                                        controller.quantityMealController,
                                        "الكمية",
                                        key: const ValueKey("quantityField")),
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: controller.alwaysAvailable,
                                    onChanged: (val) => controller
                                        .toggleAlwaysAvailable(val ?? false),
                                    activeColor: Colors.redAccent,
                                  ),
                                  const Text("متوفر دائمًا"),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // الإضافات
                  Text(
                    "الإضافات",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(
                    controller.additionals.length,
                    (index) {
                      final addition = controller.additionals[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CheckboxListTile(
                          value: controller.selectedAdditionalsId
                                  .contains(addition.id.toString())
                              ? true
                              : false,
                          onChanged: (val) {
                            controller.toggleAddition(index, val ?? false);
                          },
                          title: Text(addition.name!),
                          subtitle: Text("${addition.price} \$"),
                          activeColor: Colors.redAccent,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      controller.addmeals();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "حفظ المنتج",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
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

  void _showAddAdditionDialog(BuildContext context, MealController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text("إضافة جديدة"),
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
              const SizedBox(height: 10),
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
            child: const Text("إضافة"),
            onPressed: () {
              controller.addNewAddition();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
