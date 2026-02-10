import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/delivery/my_delivery_data.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/order_model.dart';

class MyDeliveryController extends GetxController {
  List<OrderModel> myDeliveryOrders = [];
  List<OrderModel> newDeliveryOrders = [];
  List<OrderModel> completedDeliveryOrders = [];
  OrderModel orderDetails = OrderModel();

  StatusRequest statusRequest = StatusRequest.none;
  MyDeliveryData mydeliveryData = MyDeliveryData(Get.find());

  MyServices myServices = Get.find();

  String token = "";

  @override
  void onInit() {
    // getmyDeliveryOrders();
    // getNewDeliveryOrders();
    // getcompletedDeliveryOrders();
    getDeliveryOrders();
    super.onInit();
  }

  refreshOrders() {
    // getmyDeliveryOrders();
    // getNewDeliveryOrders();
    // getcompletedDeliveryOrders();
    getDeliveryOrders();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getDeliveryOrders() async {
    myDeliveryOrders.clear();
    newDeliveryOrders.clear();
    completedDeliveryOrders.clear();
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await mydeliveryData.getDeliveryOrders();
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
      // Start backend

      myDeliveryOrders.addAll((response['processingOrders'] as List)
          .map((e) => OrderModel.fromJson(e)));
      newDeliveryOrders.addAll((response['waitingOrders'] as List)
          .map((e) => OrderModel.fromJson(e)));
      completedDeliveryOrders.addAll((response['completedOrders'] as List)
          .map((e) => OrderModel.fromJson(e)));

      // myDeliveryOrders
      //     .addAll((response as List).map((e) => OrderModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }
  
  getOrderDetails(
      String id, String orderStatus, List<CartModel> cartItems) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await mydeliveryData.getDetails(id);
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
      // Start backend

      orderDetails = OrderModel.fromJson(response);
      gotoDetails(id, orderStatus, cartItems);
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  Map<String, dynamic> datacoupon = {};
  getDataCoupon() {
    if (orderDetails.coupon != null) {
      datacoupon = {
        'id': orderDetails.coupon!.id,
        'discount': orderDetails.coupon!.discount,
        'details': orderDetails.coupon!.details,
      };
    }
  }

  calculatProductsPrice(List<CartModel> cartitems) {
    double editproductsPrice = 0.0;

    for (var item in cartitems) {
      editproductsPrice += item.price!;
    }
    return editproductsPrice;
  }

  gotoDetails(String orderId, String orderStatus, List<CartModel> cartitems) {
    getDataCoupon();
    final bool hasCart = cartitems.isNotEmpty;
    double? productsPrice = hasCart
        ? calculatProductsPrice(cartitems)
        : double.tryParse(orderDetails.calculatedtotalprice.toString());

    Get.toNamed(AppRoute.checkout, arguments: {
      'fromOrder': true,
      'fromDeliver': true,
      'pendingOrder': false,
      'orderStatus': orderStatus,
      'orderId': orderId,
      'cartItems': cartitems.isEmpty ? orderDetails.carts : cartitems,
      'productsPrice': productsPrice,
      'datacoupon': datacoupon,
      'paymentMethod': orderDetails.paymentMethod,
      'couponname': orderDetails.coupon?.name,
      'note': orderDetails.notes,
      'address': orderDetails.address,
      'oldcartcount': orderDetails.oldCartCount,
      //'cartItem': cart
    });
  }

  changeOrderStatus(String orderid, String status) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await mydeliveryData.changeOrderStatus(orderid, status);
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
      // Get.back();
      Get.snackbar(
        "111".tr,
        "154".tr,
        backgroundColor: Colors.deepOrangeAccent,
        snackPosition: SnackPosition.TOP,
      );
      getDeliveryOrders();
      // getmyDeliveryOrders();
      // getNewDeliveryOrders();
      // getcompletedDeliveryOrders();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  String printOrderStatus(String? val) {
    if (val == "5") {
      return "Pending";
    } else if (val == "1") {
      return "Processing";
    } else if (val == "2") {
      return "On The Way";
    } else if (val == "3") {
      return "On Site";
    } else if (val == "4") {
      return "Completed";
    } else {
      return "Unknown";
    }
  }
}
