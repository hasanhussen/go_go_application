// views/order_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/handlingdataview.dart';

import '../../../controller/cart/cart_controller.dart';
import '../../widgets/order/add_coupon_button.dart';
import '../../widgets/order/buttom_checkout.dart';
import '../../widgets/order/checkout_appbar.dart';
import '../../widgets/order/note_textfield.dart';
import '../../widgets/order/cart_item_card.dart';
import '../../widgets/order/payment_methods.dart';

class Cart extends StatelessWidget {
  Cart({super.key});
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            controller.gotoBack();
            return true;
          },
          child: HandlingDataRequest(
            statusRequest: controller.statusRequest,
            widget: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: ListView(
                  children: [
                    const CheckoutAppBar(),
                    const SizedBox(height: 20),
                    const CartItemCard(),
                    const SizedBox(height: 12),
                    const NoteTextField(),
                    const SizedBox(height: 18),
                    const PaymentMethods(),
                    const SizedBox(height: 18),
                    const AddCouponButton(),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              bottomNavigationBar: const BottomCheckoutBar(),
            ),
          ),
        );
      },
    );
  }
}
