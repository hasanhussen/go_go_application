import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';
import 'package:go_go/controller/orders/checkout_controller.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/view/widgets/order/custombuttoncoupon.dart';

class OrderCouponButton extends GetView<CheckoutController> {
  const OrderCouponButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
        builder: (controller) => Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: controller.couponController,
                    onChanged: (val) {
                      controller.update();
                    },
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        hintText: "Coupon Code",
                        border: OutlineInputBorder()),
                  )),
              SizedBox(width: 5),
              Expanded(
                  flex: 1,
                  child: CustomButtonCoupon(
                    textbutton:
                        controller.couponLoading == false ? "apply" : null,
                    onPressed: controller.couponController.text.trim().isEmpty
                        ? () {}
                        : () => controller.checkcoupon(),
                  ))
            ])));
  }
}
