import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/controller/my_delivery_controller.dart';
import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/checkinternet.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/cart/cart_data.dart';
import 'package:go_go/data/datasource/remote/checkout/checkout_data.dart';
import 'package:go_go/data/datasource/remote/delivery/my_delivery_data.dart';
import 'package:go_go/data/datasource/remote/orders/pending_data.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/order_model.dart';
import 'package:go_go/linkapi.dart';
import 'package:go_go/view/screen/orders/payment.dart';
import 'package:http/http.dart' as http;

class CheckoutController extends GetxController {
  List<CartModel> cartItems = [];
  StatusRequest statusRequest = StatusRequest.none;
  MyServices myServices = Get.find();

  CheckoutData checkoutData = CheckoutData(Get.find());
  OrdersPendingData ordersPendingData = OrdersPendingData(Get.find());

  MyDeliveryData mydeliveryData = MyDeliveryData(Get.find());
  CartData cartData = CartData(Get.find());
  TextEditingController couponController = TextEditingController();

  String token = "";

  String? paymentMethod;
  //bool showpaymentcheckbox = false;
  bool isEditingPayment = false;
  String? tempPaymentMethod;

  String? couponname;
  int? couponId;
  bool couponLoading = false;
  bool showCouponField = false;
  Map<String, dynamic> datacoupon = {};
  String? typeDiscount;

  String? note;
  bool isNoteEditing = false;
  TextEditingController notecontroller = TextEditingController();

  double productsPrice = 0.0;
  double totalPrice = 0.0;
  double deliveryPrice = 10.0;
  int? discount;
  double totalBeforeDiscount = 0.0;

  String? address;
  bool isEditingAddress = true;
  TextEditingController addresscontroller = TextEditingController();

  bool fromOrder = false;
  bool fromDeliver = false;
  bool pendingOrder = true;
  String? orderStatus;
  String? orderId;
  bool isitemdelet = false;
  int oldcartcount = 0;
  String? storeName;

  bool linkedWithOrder = false;
  OrderModel? linkedOrder;

  List<OrderModel> processingOrders = [];

  getprocessingOrders() async {
    processingOrders.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.getProcessing();
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

      processingOrders
          .addAll((response as List).map((e) => OrderModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void togglelinkedWithOrder(int orderid) async {
    linkedOrder = processingOrders.firstWhere((item) => item.id == orderid);
    address = linkedOrder?.address;
    if (fromOrder == false) {
      myServices.sharedPreferences.setString('address', address ?? '');
    }
    isEditingAddress = false;
    linkedWithOrder = true;
    update();
  }

  void toggleAddressEditing() async {
    isEditingAddress = !isEditingAddress;
    addresscontroller.text = address ?? '';
    if (fromOrder == false) {
      await myServices.sharedPreferences.remove('address');
    }
    address = null;
    update();
  }

  refrehOrder() {
    pendingOrder = false;
    update();
  }

  void setAddress(String newAddress) {
    address = newAddress;
    if (fromOrder == false) {
      myServices.sharedPreferences.setString('address', newAddress);
    }
    isEditingAddress = false;
    linkedWithOrder = false;
    linkedOrder = null;
    update();
  }

  getAddress() {
    if (Get.arguments['address'] == null) {
      address = myServices.sharedPreferences.getString("address");
      if (address != null) {
        isEditingAddress = false;
      }
      update();
    } else {
      address = Get.arguments['address'];
      isEditingAddress = false;
      update();
    }
  }

  void togglePaymentEditing() {
    if (isEditingPayment) {
      // اذا كنت بوضع تعديل ورجعت
      isEditingPayment = false;
      tempPaymentMethod = null;
    } else {
      // اذا دخلت على وضع التعديل
      tempPaymentMethod = paymentMethod; // القيمة الافتراضية
      isEditingPayment = true;
    }
    update();
  }

  void savePaymentMethod() {
    if (tempPaymentMethod != null) {
      paymentMethod = tempPaymentMethod; // حفظ القيمة الجديدة
    }
    isEditingPayment = false;
    tempPaymentMethod = null;
    update();
  }

  typeDiscountCoupon() {
    print(datacoupon);
    if (couponname != null && datacoupon.isNotEmpty) {
      double? couponPrice;
      final discountValue = datacoupon['discount'];

      if (discountValue == null) {
        // يعني الكوبون ما فيه نسبة خصم
        typeDiscount = 'لا يوجد خصم';
        discount = 0;
        totalPrice = productsPrice + deliveryPrice;
        update();
        return;
      }

      discount = int.tryParse(discountValue.toString()) ?? 0;

      if (datacoupon['details'] == 'products_price') {
        typeDiscount = 'سعر المنتجات';
        couponPrice = productsPrice * (1 - (discount! / 100));
        productsPrice = double.parse(couponPrice.toStringAsFixed(2));
        totalPrice = productsPrice + deliveryPrice;
      } else if (datacoupon['details'] == 'delivery_price') {
        typeDiscount = 'سعر التوصيل';
        couponPrice = deliveryPrice * (1 - (discount! / 100));
        deliveryPrice = double.parse(couponPrice.toStringAsFixed(2));
        totalPrice = productsPrice + deliveryPrice;
      } else {
        typeDiscount = 'اجمالي السعر';
        couponPrice = (productsPrice + deliveryPrice) * (1 - (discount! / 100));
        totalPrice = double.parse(couponPrice.toStringAsFixed(2));
      }

      update();
    }
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getCouponName() {
    if (Get.arguments['couponname'] == null) {
      couponname = myServices.sharedPreferences.getString("couponname");
      if (couponname != null) {
        couponId = int.parse(datacoupon['id'].toString());
      }
      update();
    } else {
      couponname = Get.arguments['couponname'];
      update();
    }
  }

  getNote() {
    if (Get.arguments['note'] == null) {
      note = myServices.sharedPreferences.getString("note") ?? '';
      update();
    } else {
      note = Get.arguments['note'];
      update();
    }
  }

  void toggleNoteEditing() async {
    isNoteEditing = !isNoteEditing;
    notecontroller.text = note ?? '';
    if (fromOrder == false) {
      await myServices.sharedPreferences.remove('note');
    }
    note = null;
    update();
  }

  void setNote(String newNote) {
    note = newNote;
    if (fromOrder == false) {
      myServices.sharedPreferences.setString('note', newNote);
    }
    isNoteEditing = false;
    update();
  }

  checkout() async {
    if (address == null) {
      Get.snackbar(
        "تنبيه!",
        "يرجى إدخال عنوان التوصيل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }
    if (cartItems.isEmpty) {
      Get.snackbar(
        'انتباه',
        'يجب أن يحتوي الطلب على منتج واحدة على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      update();
      return;
    }

    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    print("=============================== Controller");

    var response = await checkoutData.confirm(
        note,
        address!,
        productsPrice,
        deliveryPrice,
        couponId,
        discount,
        cartItems.length,
        totalPrice,
        totalBeforeDiscount,
        linkedWithOrder ? linkedOrder?.id : null,
        paymentMethod!);
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
          textConfirm: "إعادة المحاولة",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
            checkout(); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      Get.snackbar(
        "الطلب",
        "تم إرسال الطلب بنجاح ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      resetvalues();
      // update();
      // عند الإرسال
      Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
    } else {
      Get.defaultDialog(
        title: "خطأ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        middleText: "فشل إرسال الطلب ❌\nحاول مرة أخرى.",
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
          checkout(); // يرجع ينفذ الطلب من جديد
        },
        onCancel: () {},
      );
    }

    update();
  }

  confirmOrderAfterPayment(String paymentIntentId) async {
    if (address == null) {
      Get.snackbar(
        "تنبيه!",
        "يرجى إدخال عنوان التوصيل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }
    if (cartItems.isEmpty) {
      Get.snackbar(
        'انتباه',
        'يجب أن يحتوي الطلب على منتج واحدة على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      update();
      return;
    }

    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    print("=============================== Controller");
    var response = await checkoutData.confirmOrderAfterPayment(
        note,
        address!,
        productsPrice,
        deliveryPrice,
        couponId,
        discount,
        cartItems.length,
        totalPrice,
        totalBeforeDiscount,
        linkedWithOrder ? linkedOrder?.id : null,
        paymentIntentId);
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
          textConfirm: "إعادة المحاولة",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
            confirmOrderAfterPayment(
                paymentIntentId); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      Get.snackbar(
        "الطلب",
        "تم إرسال الطلب بنجاح ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      resetvalues();
      // update();
      // عند الإرسال
      // final OrdersPendingController ordersPendingController =
      //     Get.find<OrdersPendingController>();
      // await ordersPendingController.refrehOrder();
      Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
    } else {
      Get.defaultDialog(
        title: "خطأ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        middleText: "فشل إرسال الطلب ❌\nحاول مرة أخرى.",
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
          confirmOrderAfterPayment(paymentIntentId); // يرجع ينفذ الطلب من جديد
        },
        onCancel: () {},
      );
    }

    update();
  }

  confirmOrder() async {
    if (paymentMethod == "cash") {
      print('confirmOrder');
      await checkout();
      print('confirmOrder==========');
    } else {
      // startOnlinePayment(cartTotal: 23.50);
      showPaymentDetails();
    }
  }

  confirmeditOrder() async {
    if (paymentMethod == "cash") {
      print('confirmOrder');
      await editOrder();
      print('confirmOrder==========');
    } else {
      editOnlinePayment(orderId!);
      // showPaymentDetails();
    }
  }

  resetvalues() async {
    await myServices.sharedPreferences.remove('couponname');
    await myServices.sharedPreferences.remove('note');
    await myServices.sharedPreferences.remove('address');
    couponId = null;
    note = null;
    address = null;
    discount = null;

    update();
  }

  TextEditingController cardNumber = TextEditingController();
  TextEditingController expiry = TextEditingController();
  TextEditingController cvc = TextEditingController();

  bool isProcessing = false;

  void showPaymentDetails() {
    if (address == null) {
      Get.snackbar(
        "تنبيه!",
        "يرجى إدخال عنوان التوصيل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    amountController.text = totalPrice.toString();
    update();
    Get.bottomSheet(PaymentSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ));
  }

  CardFieldInputDetails? card;
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  // من السيرفر
  String clientSecret = '';
  String paymentIntentId = '';
  String stripePaymentMethodId = '';
  double amount = 0;

  bool isLoading = false;

  void setCard(CardFieldInputDetails? cardDetails) {
    card = cardDetails;
    update();
  }

  Future<void> startOnlinePayment({
    // required double cartTotal, // أو احذفه لو السيرفر يحسب
    String currency = 'usd',
  }) async {
    if (card == null) {
      Get.snackbar('خطأ', 'الرجاء إدخال بيانات البطاقة');
      return;
    }
    isLoading = true;
    update();
    try {
      // جلب التوكن
      await gettoken();

      // 1) إنشاء PaymentIntent على السيرفر
      final resp = await http.post(
        Uri.parse(AppLink.createPaymentIntent),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'amount': totalPrice.toString(),
          'currency': currency,
        },
      );

      if (resp.statusCode != 200) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'فشل إنشاء عملية الدفع');
        return;
      }

      final data = jsonDecode(resp.body);
      clientSecret = data['client_secret'] ?? '';
      paymentIntentId = data['payment_intent_id'] ?? '';
      amount = double.tryParse(data['amount'].toString()) ?? 0;

      // فحص الحقول المهمة
      if (clientSecret.isEmpty) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'حدث خطأ: clientSecret فارغ!');
        return;
      }

      if (paymentIntentId.isEmpty) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'حدث خطأ: paymentIntentId فارغ!');
        return;
      }

      print('clientSecret="$clientSecret"');
      print('paymentIntentId="$paymentIntentId"');
      print('amount=$amount');

      // 2) تهيئة Stripe
      final publishableKey = myServices.publishableKey;
      if (publishableKey == null || publishableKey.isEmpty) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'publishableKey غير موجود!');
        return;
      }

      print('Card complete? ${card?.complete}');

      print('بدء الدفع');
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: nameController.text,
            ),
          ),
        ),
      );
      print('انتهاء الدفع');

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم الدفع بنجاح ✅',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        await confirmOrderAfterPayment(paymentIntentId);
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresCapture) {
        Get.back();
        Get.snackbar(
          '✅ تم تأكيد البطاقة',
          'سيتم سحب الأموال عند تسليم الطلب',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        print("PaymentIntent يحتاج إلى capture لاحق من السيرفر");
        await confirmOrderAfterPayment(paymentIntentId);
      } else {
        showPaymentStatusDialog(paymentIntent.status);
        //Get.snackbar('فشل', 'لم يكتمل الدفع: ${paymentIntent.status}');
        print(paymentIntent.status);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الدفع: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  editCoupon() {
    showCouponField = true;
    if (couponname != null) {
      couponController.text = couponname!;
    }
    update();
  }

  checkcoupon() async {
    if (couponController.text.trim().isNotEmpty) {
      couponLoading = true;
      update();
      if (await checkInternet()) {
        MyServices myServices = Get.find();
        final String token =
            myServices.sharedPreferences.getString("token") ?? "";
        var response = await http.post(
          Uri.parse(AppLink.checkcoupon),
          body: {"name": couponController.text.trim()},
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // 'Content-Type': 'application/json',
          },
        );
        print(response.statusCode);
        var responsebody = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          couponname = couponController.text.trim();

          datacoupon = responsebody;
          Get.snackbar("success", "${datacoupon['success']}");
          typeDiscountCoupon();
          myServices.sharedPreferences.setString('couponname', couponname!);
          update();
        } else {
          datacoupon = responsebody;
          statusRequest = StatusRequest.none;
          Get.snackbar("Warning", "${datacoupon['error']}");
          update();
        }
      } else {
        statusRequest = StatusRequest.offlinefailure;
        update();
      }
      couponLoading = false;
      showCouponField = false;
      update();
    }
  }

  getordercount() {
    if (cartItems.length < oldcartcount) {
      isitemdelet = true;
      update();
    }
  }

  deletorderItem(int cartMealId, {int? cartVariantId}) async {
    if (fromOrder) {
      // statusRequest = StatusRequest.loading;
      // gettoken();
      // update();
      // print("=============================== Controller");
      // var response = await cartData.deleteItem(cartId);
      // print("=============================== Controller $response ");
      // statusRequest = handlingData(response);
      // if (response is Map && response['error'] != null) {
      //   statusRequest = StatusRequest.failure;
      //   Get.defaultDialog(
      //     title: "خطأ",
      //     titleStyle: const TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 18,
      //       color: Colors.red,
      //     ),
      //     middleText: response['error'],
      //     middleTextStyle: const TextStyle(fontSize: 16),
      //     backgroundColor: Colors.white,
      //     radius: 12,
      //     buttonColor: Colors.red,
      //     textCancel: "إغلاق",
      //     cancelTextColor: Colors.black,
      //     onCancel: () {},
      //   );
      //   update();
      //   return;
      // }
      CartModel? cartItem = cartItems.firstWhereOrNull((item) =>
          item.mealId == cartMealId && item.variantId == cartVariantId);
      if (cartItem != null) {
        cartItems.remove(cartItem);
        Get.snackbar(
          '✅ تم الحذف',
          ' تم حذف المنتج من طلبك',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
        final OrdersPendingController ordersPendingController =
            Get.find<OrdersPendingController>();
        await ordersPendingController.getOrderDetails(
            orderId ?? '0', orderStatus ?? '0', cartItems);
        // Get.back();
        update();
      }
    }
  }

  Future<void> editCardPayment(
    String orderId, {
    // required double cartTotal, // أو احذفه لو السيرفر يحسب
    String currency = 'usd',
  }) async {
    if (card == null) {
      Get.snackbar('خطأ', 'الرجاء إدخال بيانات البطاقة');
      return;
    }
    isLoading = true;
    update();
    try {
      // جلب التوكن
      await gettoken();

      // 1) إنشاء PaymentIntent على السيرفر
      final resp = await http.post(
        Uri.parse('${AppLink.updateCard}/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'new_total': totalPrice.toString(),
        },
      );

      if (resp.statusCode != 200) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'فشل إنشاء عملية الدفع');
        return;
      }

      final data = jsonDecode(resp.body);
      // أخذ PaymentIntent الجديد أو القديم حسب الرد
      paymentIntentId = data['new_payment_intent_id'] ?? paymentIntentId;
      clientSecret = data['client_secret'] ?? clientSecret;
      amount = double.tryParse(
              (data['new_amount'] ?? data['capture_with_amount']).toString()) ??
          0;

      // // فحص الحقول المهمة
      // if (clientSecret.isEmpty) {
      //   isLoading = false;
      //   update();
      //   Get.snackbar('خطأ', 'حدث خطأ: clientSecret فارغ!');
      //   return;
      // }

      // if (paymentIntentId.isEmpty) {
      //   isLoading = false;
      //   update();
      //   Get.snackbar('خطأ', 'حدث خطأ: paymentIntentId فارغ!');
      //   return;
      // }

      // print('clientSecret="$clientSecret"');
      // print('paymentIntentId="$paymentIntentId"');
      // print('amount=$amount');

      // 2) تهيئة Stripe
      final publishableKey = myServices.publishableKey;
      if (publishableKey == null || publishableKey.isEmpty) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'publishableKey غير موجود!');
        return;
      }

      //print('Card complete? ${card?.complete}');

      print('بدء الدفع');
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: nameController.text,
            ),
          ),
        ),
      );

      print('انتهاء الدفع');

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم تعديل مبلغ الدفع بنجاح ✅',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        await editOrderAfterPayment(paymentIntentId);
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresCapture) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم تأكيد البطاقة والدفع قيد المعالجة ✅',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        print("PaymentIntent يحتاج إلى capture لاحق من السيرفر");
        await editOrderAfterPayment(paymentIntentId);
      } else {
        showPaymentStatusDialog(paymentIntent.status);
        //Get.snackbar('فشل', 'لم يكتمل الدفع: ${paymentIntent.status}');
        print(paymentIntent.status);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الدفع: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> editOnlinePayment(
    String orderId, {
    // required double cartTotal, // أو احذفه لو السيرفر يحسب
    String currency = 'usd',
  }) async {
    if (card == null) {
      Get.snackbar('خطأ', 'الرجاء إدخال بيانات البطاقة');
      return;
    }
    isLoading = true;
    update();
    try {
      // جلب التوكن
      await gettoken();

      // 1) إنشاء PaymentIntent على السيرفر
      final resp = await http.post(
        Uri.parse('${AppLink.updatePaymentAmount}/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'new_total': totalPrice.toString(),
        },
      );

      if (resp.statusCode != 200) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'فشل إنشاء عملية الدفع');
        return;
      }

      final data = jsonDecode(resp.body);
      // أخذ PaymentIntent الجديد أو القديم حسب الرد
      paymentIntentId = data['new_payment_intent_id'] ?? paymentIntentId;
      stripePaymentMethodId = data['stripe_payment_method_id'] ?? '';
      clientSecret = data['client_secret'] ?? clientSecret;
      amount = double.tryParse(
              (data['new_amount'] ?? data['capture_with_amount']).toString()) ??
          0;

      // 2) تهيئة Stripe
      final publishableKey = myServices.publishableKey;
      if (publishableKey == null || publishableKey.isEmpty) {
        isLoading = false;
        update();
        Get.snackbar('خطأ', 'publishableKey غير موجود!');
        return;
      }

      // print('Card complete? ${card?.complete}');

      print('بدء الدفع');
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: stripePaymentMethodId != ''
            ? PaymentMethodParams.cardFromMethodId(
                paymentMethodData: PaymentMethodDataCardFromMethod(
                  paymentMethodId: stripePaymentMethodId,
                ),
              )
            : PaymentMethodParams.card(
                paymentMethodData: PaymentMethodData(
                  billingDetails: BillingDetails(
                    name: nameController.text,
                  ),
                ),
              ),
      );

      print('انتهاء الدفع');

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم تعديل مبلغ الدفع بنجاح ✅',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        await editOrderAfterPayment(paymentIntentId);
      } else if (paymentIntent.status == PaymentIntentsStatus.RequiresCapture) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم تأكيد البطاقة والدفع قيد المعالجة ✅',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        print("PaymentIntent يحتاج إلى capture لاحق من السيرفر");
        await editOrderAfterPayment(paymentIntentId);
      } else {
        showPaymentStatusDialog(paymentIntent.status);
        //Get.snackbar('فشل', 'لم يكتمل الدفع: ${paymentIntent.status}');
        print(paymentIntent.status);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الدفع: $e');
    } finally {
      isLoading = false;
      update();
    }
  }

  editOrder() async {
    if (address == null) {
      Get.snackbar(
        "تنبيه!",
        "يرجى إدخال عنوان التوصيل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }
    if (cartItems.isEmpty) {
      Get.snackbar(
        'انتباه',
        'يجب أن يحتوي الطلب على منتج واحدة على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      update();
      return;
    }

    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    print("=============================== Controller");
    print(
        "=============================== cartItems ${cartItems[1].oldPrice} ");
    var response = await checkoutData.editdata(
        orderId,
        note,
        address!,
        productsPrice,
        deliveryPrice,
        couponId,
        discount,
        cartItems.length,
        totalPrice,
        totalBeforeDiscount,
        linkedWithOrder ? linkedOrder?.id : null,
        paymentMethod!,
        cartItems);
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
          textConfirm: "إعادة المحاولة",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
            editOrder(); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      Get.snackbar(
        "الطلب",
        "تم تعديل الطلب بنجاح ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      resetvalues();
      // update();
      // عند الإرسال
      Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
    } else {
      Get.defaultDialog(
        title: "خطأ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        middleText: "فشل إرسال الطلب ❌\nحاول مرة أخرى.",
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
          editOrder(); // يرجع ينفذ الطلب من جديد
        },
        onCancel: () {},
      );
    }

    update();
  }

  editOrderAfterPayment(String paymentIntentId) async {
    if (address == null) {
      Get.snackbar(
        "تنبيه!",
        "يرجى إدخال عنوان التوصيل",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.warning, color: Colors.white),
      );
      return;
    }
    if (cartItems.isEmpty) {
      Get.snackbar(
        'انتباه',
        'يجب أن يحتوي الطلب على منتج واحدة على الأقل',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      update();
      return;
    }

    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    print("=============================== Controller");
    var response = await checkoutData.editdataAfterPayment(
        orderId,
        note,
        address!,
        productsPrice,
        deliveryPrice,
        couponId,
        discount,
        cartItems.length,
        totalPrice,
        totalBeforeDiscount,
        linkedWithOrder ? linkedOrder?.id : null,
        paymentIntentId,
        cartItems);
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
          textConfirm: "إعادة المحاولة",
          confirmTextColor: Colors.white,
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onConfirm: () {
            Get.back(); // يسكر الديالوج
            editOrderAfterPayment(paymentIntentId); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      Get.snackbar(
        "الطلب",
        "تم تعديل الطلب بنجاح ✅",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      resetvalues();
      // update();
      // عند الإرسال
      Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
    } else {
      Get.defaultDialog(
        title: "خطأ",
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.red,
        ),
        middleText: "فشل تعديل الطلب ❌\nحاول مرة أخرى.",
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
          editOrderAfterPayment(paymentIntentId); // يرجع ينفذ الطلب من جديد
        },
        onCancel: () {},
      );
    }

    update();
  }

  gotoEdit(int mealId, int cartId, int countmeal,
      List<AdditionalsModel> additionalItems, CartModel cart, int? variantId) {
    //myServices.sharedPreferences.setString('note', noteController!.text.trim());
    Get.toNamed(AppRoute.editcart, arguments: {
      'mealId': mealId,
      'cartId': cartId,
      'countmeal': countmeal,
      'additionalItems': additionalItems,
      'fromOrder': fromOrder,
      'cartItem': cart,
      'orderStatus': orderStatus,
      'orderId': orderId,
      'variantId': variantId,
    });
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
      calculatProductsPrice();
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  calculatProductsPrice() {
    productsPrice = 0.0;
    update();
    for (var item in cartItems) {
      productsPrice += item.price!;
    }
    totalPrice = productsPrice + deliveryPrice;
    totalBeforeDiscount = totalPrice;
    update();
  }

  void showPaymentStatusDialog(PaymentIntentsStatus status) {
    String title = 'فشل الدفع';
    String message = '';

    switch (status) {
      case PaymentIntentsStatus.Canceled:
        message = 'تم إلغاء الدفع. يرجى المحاولة لاحقًا.';
        break;
      case PaymentIntentsStatus.RequiresPaymentMethod:
        message =
            'لم تتم عملية الدفع، يبدو أن رصيد البطاقة غير كافٍ أو طريقة الدفع غير صالحة. يرجى تجربة بطاقة أخرى.';
        break;
      case PaymentIntentsStatus.RequiresCapture:
        message = 'تم تفويض البطاقة، الدفع قيد المعالجة.';
        break;
      case PaymentIntentsStatus.Processing:
        message = 'يتم معالجة الدفع، يرجى الانتظار.';
        break;
      case PaymentIntentsStatus.Succeeded:
        message = 'تم الدفع بنجاح ✅';
        break;
      default:
        message = 'حدث خطأ أثناء الدفع. الحالة: $status';
    }

    Get.defaultDialog(
      title: title,
      middleText: message,
      textConfirm: 'حسناً',
      onConfirm: () => Get.back(),
      barrierDismissible: false,
    );
  }

  addnewProduct() {
    myServices.sharedPreferences.remove('pendingOrderId');
    myServices.sharedPreferences
        .setString('pendingOrderId', orderId.toString());
    Get.toNamed(
      AppRoute.homescreen,
      // arguments: {"pendingOrderId": orderId}
    );
    //print('pendingOrderId=$orderId');
    final HomeScreenControllerImp homeScreenControllerImp =
        Get.find<HomeScreenControllerImp>();
    homeScreenControllerImp.toggleShowHomePage();
  }

  changeOrderStatus() async {
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await mydeliveryData.changeOrderStatus(orderId!, orderStatus!);
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
      MyDeliveryController myDeliveryController = Get.find();
      myDeliveryController.refreshOrders();
      Get.back();
      Get.snackbar(
        "111".tr,
        "154".tr,
        backgroundColor: Colors.deepOrangeAccent,
        snackPosition: SnackPosition.TOP,
      );
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['cartItems'] != null) {
      cartItems = Get.arguments['cartItems'] ?? [];
      productsPrice = Get.arguments['productsPrice'] ?? 0.0;
      totalPrice = productsPrice + deliveryPrice;
      totalBeforeDiscount = totalPrice;
    }
    if (cartItems.isEmpty) {
      getCartItems();
    }

    datacoupon = Get.arguments['datacoupon'] ?? {};
    paymentMethod = Get.arguments['paymentMethod'] ?? 'cash';
    fromOrder = Get.arguments['fromOrder'] ?? false;
    fromDeliver = Get.arguments['fromDeliver'] ?? false;
    pendingOrder = Get.arguments['pendingOrder'] ?? true;
    oldcartcount = Get.arguments['oldcartcount'] ?? 0;
    orderStatus = Get.arguments['orderStatus'] ?? '0';
    orderId = Get.arguments['orderId'] ?? '0';
    getCouponName();
    getNote();
    getAddress();
    typeDiscountCoupon();
    getprocessingOrders();
    super.onInit();
  }
}
