import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';
import 'package:go_go/core/constant/color.dart';
import 'package:go_go/view/widgets/order/custombuttoncoupon.dart';

class AddCouponButton extends GetView<CartController> {
  const AddCouponButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        builder: (controller) => controller.couponname == null
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: controller.couponController,
                        onChanged: (val) {
                          controller
                              .update(); // هي بتخلي GetBuilder يعمل rebuild
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            hintText: "Coupon Code",
                            border: OutlineInputBorder()),
                      )),
                  SizedBox(width: 5),
                  Expanded(
                      flex: 1,
                      child: CustomButtonCoupon(
                        textbutton:
                            controller.isLoading == false ? "apply" : null,
                        onPressed:
                            controller.couponController!.text.trim().isEmpty
                                ? () {}
                                : () => controller.checkcoupon(true),
                      ))
                ]))
            : Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "سيتم إضافة الكوبون",
                            style: TextStyle(
                                color: AppColor.grey,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            " ${controller.couponname!} ",
                            style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            " إلى طلبك",
                            style: TextStyle(
                                color: AppColor.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text(
                        "سيتم خصم %${controller.datacoupon['discount']}  من ${controller.typeDiscount} ",
                        style: TextStyle(
                            color: AppColor.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )),
                  Spacer(),
                  Container(
                      padding: EdgeInsetsDirectional.only(end: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.editCoupon();
                            },
                            child: Icon(Icons.edit_document,
                                size: 25), // أيقونة أصغر
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'تعديل',
                            style: TextStyle(
                                fontSize: 11,
                                height: 1), // height=1 يخلي النص قريب
                          ),
                        ],
                      ))
                ],
              ));
  }
}
