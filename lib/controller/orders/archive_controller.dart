import 'package:flutter/material.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:get/get.dart';
import 'package:go_go/data/datasource/remote/orders/pending_data.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/order_model.dart';

class OrdersArchiveController extends GetxController {
  OrdersPendingData ordersPendingData = OrdersPendingData(Get.find());

  List<OrderModel> archiveOrders = [];
  List<OrderModel> rejectedOrders = [];
  OrderModel orderDetails = OrderModel();

  StatusRequest statusRequest = StatusRequest.none;

  MyServices myServices = Get.find();

  String printOrderStatus(String val) {
    if (val == "0") {
      return "136".tr;
    } else if (val == "1") {
      return "137".tr;
    } else if (val == "2") {
      return "139".tr;
    } else if (val == "3") {
      return "138".tr;
    } else {
      return "140".tr;
    }
  }

  getarchiveOrders() async {
    archiveOrders.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.getCompleted();
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

      archiveOrders
          .addAll((response as List).map((e) => OrderModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getRejectedOrders() async {
    rejectedOrders.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.getRejected();
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

      rejectedOrders
          .addAll((response as List).map((e) => OrderModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  deleteOrder(String orderid) async {
    //data.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.deleteData(orderid);
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

      refrehOrder();

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  refrehOrder() {
    getarchiveOrders();
    getRejectedOrders();
  }

  getOrderDetails(
      String id, String orderStatus, List<CartModel> cartItems) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.getDetails(id);
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
      'pendingOrder': orderStatus == '0' ? true : false,
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

  @override
  void onInit() {
    getRejectedOrders();
    getarchiveOrders();
    super.onInit();
  }
}
