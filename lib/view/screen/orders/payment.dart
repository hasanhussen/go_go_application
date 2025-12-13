import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/orders/checkout_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';

class PaymentSheet extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (_) => HandlingDataRequest(
        statusRequest: controller.statusRequest,
        widget: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // مقبض للسحب
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // العنوان
                Text(
                  "إدخال بيانات الدفع",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: controller.nameController,
                  decoration:
                      const InputDecoration(labelText: 'اسم صاحب البطاقة'),
                ),
                const SizedBox(height: 20),
                CardField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey[200],
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.black),
                  onCardChanged: (card) {
                    controller.setCard(card);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'المبلغ'),
                ),

                const SizedBox(height: 25),

                // زر الدفع
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : () {
                            controller.fromOrder
                                ? controller
                                    .editCardPayment(controller.orderId!)
                                : controller.startOnlinePayment();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'دفع الآن',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
