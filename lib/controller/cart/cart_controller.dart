// controllers/order_controller.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/checkinternet.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/cart/cart_data.dart';
import 'package:go_go/data/datasource/remote/cart/coupon_data.dart';
import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/linkapi.dart';
import 'package:http/http.dart' as http;

import 'package:go_go/data/model/cart/cart_model.dart';

class CartController extends GetxController {
  List<CartModel> cartItems = [];

  StatusRequest statusRequest = StatusRequest.none;
  CartData cartData = CartData(Get.find());
  CouponData couponData = CouponData(Get.find());

  MyServices myServices = Get.find();

  String token = "";

  String paymentMethod = "cash";
  double totalPrice = 0.0;
  TextEditingController? noteController = TextEditingController();
  TextEditingController? couponController = TextEditingController();
  String? couponname;
  Map<String, dynamic> datacoupon = {};
  String? typeDiscount;
  double? priceAfterDiscount;

  bool isLoading = false;

  @override
  void onInit() {
    getCartItems();
    getCouponName();
    checkcoupon(false);
    getNote();
    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getCouponName() {
    couponname = myServices.sharedPreferences.getString("couponname");
    update();
  }

  getNote() {
    if (myServices.sharedPreferences.getString("note") != null) {
      noteController!.text =
          myServices.sharedPreferences.getString("note") ?? '';
      update();
    }
  }

  gotoBack() {
    myServices.sharedPreferences.setString('note', noteController!.text.trim());
    Get.back();
  }

  getCartItems() async {
    statusRequest = StatusRequest.loading;
    cartItems.clear();
    gettoken();
    update();
    var response = await cartData.getdata();
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response is Map && response['error'] != null) {
        statusRequest = StatusRequest.failure;
        Get.defaultDialog(
          title: "خطأ",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.red,
          ),
          middleText: response['error'],
          middleTextStyle: const TextStyle(fontSize: 16),
          backgroundColor: Colors.white,
          radius: 12,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      cartItems.addAll((response as List).map((e) => CartModel.fromJson(e)));
      calculatTotalPrice();
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void changePaymentMethod(String method) {
    paymentMethod = method;
    update();
  }

  calculatTotalPrice() {
    totalPrice = 0.0;
    update();
    for (var item in cartItems) {
      totalPrice += item.price!;
    }
    update();
  }

  checkcoupon(bool inCartScreen) async {
    if (couponname != null || couponController!.text.trim().isNotEmpty) {
      isLoading = true;
      update();
      if (await checkInternet()) {
        MyServices myServices = Get.find();
        final String token =
            myServices.sharedPreferences.getString("token") ?? "";
        var response = await http.post(
          Uri.parse(AppLink.checkcoupon),
          body: {"name": couponname ?? couponController!.text.trim()},
          headers: {
            'Authorization': 'Bearer $token',
            // 'Content-Type': 'application/json',
          },
        );
        print(response.statusCode);
        var responsebody = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          couponname ??= couponController!.text.trim();

          datacoupon = responsebody;
          if (inCartScreen == true) {
            Get.snackbar("success", "${datacoupon['success']}");
          }
          typeDiscountCoupon();
          myServices.sharedPreferences.setString('couponname', couponname!);
          update();
        } else {
          datacoupon = responsebody;
          statusRequest = StatusRequest.none;
          if (inCartScreen == true) {
            Get.snackbar("Warning", "${datacoupon['error']}");
          }
          update();
        }
      } else {
        statusRequest = StatusRequest.offlinefailure;
        update();
      }
      isLoading = false;
      update();
    }
  }

  typeDiscountCoupon() {
    double? couponPrice;
    if (datacoupon['details'] == 'products_price') {
      typeDiscount = 'سعر المنتجات';
      double discount = double.parse(datacoupon['discount'].toString());
      couponPrice = totalPrice * (1 - (discount / 100));
      priceAfterDiscount = double.parse(couponPrice.toStringAsFixed(2));
      print(priceAfterDiscount);
      update();
    } else if (datacoupon['details'] == 'delivery_price') {
      typeDiscount = 'سعر التوصيل';
    } else {
      typeDiscount = 'اجمالي السعر';
    }
  }

  editCoupon() async {
    await myServices.sharedPreferences.remove('couponname');
    couponname = null;
    priceAfterDiscount = null;
    update();
  }

  deleteItem(String cartId) async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    print("=============================== Controller");
    var response = await cartData.deleteItem(cartId);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (response is Map && response['error'] != null) {
        statusRequest = StatusRequest.failure;
        Get.defaultDialog(
          title: "خطأ",
          titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.red,
          ),
          middleText: response['error'],
          middleTextStyle: const TextStyle(fontSize: 16),
          backgroundColor: Colors.white,
          radius: 12,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      getCartItems();
      // Get.back();
    } else {
      Get.defaultDialog(
        title: "خطأ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        middleText: "فشل حذف العنصر ❌\nحاول مرة أخرى.",
        middleTextStyle: const TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        radius: 12,
        textConfirm: "إعادة المحاولة",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        textCancel: "إغلاق",
        cancelTextColor: Colors.black,
        onConfirm: () {
          Get.back(); // يسكر الديالوج
          //checkout(); // يرجع ينفذ الطلب من جديد
        },
        onCancel: () {},
      );
    }

    update();
  }

  gotoEdit(int mealId, int cartId, int countmeal,
      List<AdditionalsModel> additionalItems, int? variantId) {
    myServices.sharedPreferences.setString('note', noteController!.text.trim());
    Get.toNamed(AppRoute.editcart, arguments: {
      'mealId': mealId,
      'cartId': cartId,
      'countmeal': countmeal,
      'additionalItems': additionalItems,
      'variantId': variantId,
    });
  }

  gotoDetails() {
    if (cartItems.isEmpty) {
      Get.snackbar("Warning", "يرجى اضافة عنصر على الأقل");
      return;
    }
    if (totalPrice < 1) {
      Get.snackbar("Warning", "\$يجب ان يكون سعر المنتجات اكثر من 0.99");
      return;
    }
    myServices.sharedPreferences.setString('note', noteController!.text.trim());
    Get.toNamed(AppRoute.checkout, arguments: {
      //'cartItems': cartItems,
      //'productsPrice': totalPrice,
      'datacoupon': datacoupon,
      'paymentMethod': paymentMethod,
      'oldcartcount': cartItems.length,
    });
  }
}
