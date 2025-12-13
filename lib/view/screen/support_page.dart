import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/support_controller.dart';

class SupportPage extends StatelessWidget {
  final SupportController controller = Get.put(SupportController());

  SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('الدعم الفني',
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
                  // const Text("طلب جديد", style: TextStyle(color: Colors.red, fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
      body: GetBuilder<SupportController>(
        builder: (_) {
          String role =
              controller.roles.isNotEmpty ? controller.roles[0] : 'user';

          // 🧠 توليد قائمة الأنواع حسب الدور
          List<DropdownMenuItem<String>> getTypesByRole() {
            switch (role) {
              case 'owner':
                return const [
                  DropdownMenuItem(
                      value: 'store', child: Text('مشكلة في المتجر')),
                  DropdownMenuItem(
                      value: 'orders', child: Text('مشكلة في الطلبات')),
                  DropdownMenuItem(value: 'payments', child: Text('المدفوعات')),
                  DropdownMenuItem(
                      value: 'technical', child: Text('مشكلة تقنية')),
                ];
              case 'delivery':
                return const [
                  DropdownMenuItem(
                      value: 'delivery_issue', child: Text('مشكلة في التوصيل')),
                  DropdownMenuItem(
                      value: 'order_status', child: Text('حالة الطلب')),
                  DropdownMenuItem(
                      value: 'app_issue', child: Text('مشكلة في التطبيق')),
                  DropdownMenuItem(
                      value: 'account', child: Text('مشكلة في الحساب')),
                ];
              default: // user
                return const [
                  DropdownMenuItem(
                      value: 'order', child: Text('مشكلة في الطلب')),
                  DropdownMenuItem(
                      value: 'payment', child: Text('مشكلة في الدفع')),
                  DropdownMenuItem(
                      value: 'general', child: Text('اقتراح أو استفسار')),
                ];
            }
          }

          // ✅ نجيب العناصر ونضبط القيمة الافتراضية إذا ما كانت موجودة
          List<DropdownMenuItem<String>> items = getTypesByRole();
          bool typeExists =
              items.any((item) => item.value == controller.selectedType);
          if (!typeExists) {
            controller.selectedType = items.first.value!;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role == 'owner'
                        ? 'تواصل مع دعم التجار'
                        : role == 'delivery'
                            ? 'تواصل مع دعم التوصيل'
                            : 'تواصل مع فريق الدعم',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Role display
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('دورك:',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Text(role),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Type of problem (depends on role)
                  DropdownButtonFormField<String>(
                    value: controller.selectedType,
                    items: items,
                    onChanged: (v) {
                      controller.selectedType = v ?? items.first.value!;
                      controller.update();
                    },
                    decoration: const InputDecoration(
                      labelText: 'نوع المشكلة',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Subject
                  TextFormField(
                    controller: controller.subjectC,
                    decoration: const InputDecoration(
                      labelText: 'عنوان المشكلة',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'يرجى إدخال عنوان المشكلة' : null,
                  ),

                  const SizedBox(height: 12),

                  // Description
                  TextFormField(
                    controller: controller.messageC,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'وصف المشكلة بالتفصيل',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'يرجى كتابة تفاصيل المشكلة' : null,
                  ),

                  const SizedBox(height: 12),

                  // Image attachment
                  InkWell(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.pickedImage != null
                                  ? File(controller.pickedImage!.path)
                                      .path
                                      .split('/')
                                      .last
                                  : 'إرفاق صورة (اختياري)',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: controller.pickedImage != null
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => controller.sendSupport(),
                      icon: const Icon(Icons.send),
                      label: const Text(
                        'إرسال الطلب',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
