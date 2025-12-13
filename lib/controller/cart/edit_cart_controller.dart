import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/cart/cart_controller.dart';
import 'package:go_go/controller/orders/checkout_controller.dart';
import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/cart/cart_data.dart';
import 'package:go_go/data/datasource/remote/store/meal_data.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/cart/pivotCart_additional_model.dart';
import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/meal/meal_model.dart';

class EditCartController extends GetxController {
  int countmeal = 0;
  List<AdditionalsModel> additionalItems = [];
  Map<int, int> additionalscount = {};
  double totalPrice = 0.0;
  double additionalsPrice = 0.0;

  int newcountmeal = 0;
  List<AdditionalsModel> newadditionalItems = [];
  Map<int, int> newadditionalscount = {};
  double newtotalPrice = 0.0;
  double oldPrice = 0.0;
  double newadditionalsPrice = 0.0;

  MealModel? meal;
  CartModel cartItem = CartModel();

  StatusRequest statusRequest = StatusRequest.none;
  MealData mealData = MealData(Get.find());
  CartData cartData = CartData(Get.find());

  MyServices myServices = Get.find();

  String token = "";
  int mealId = 0;
  int cartId = 0;
  bool fromOrder = false;
  String? orderId;
  String? orderStatus;
  int? variantId;
  double? variantPrice;
  int? variantQuantity;
  MealVariants? variant;

  @override
  void onInit() {
    mealId = Get.arguments['mealId'] ?? 0;
    cartId = Get.arguments['cartId'] ?? 0;
    countmeal = Get.arguments['countmeal'] ?? 0;
    additionalItems = Get.arguments['additionalItems'] ?? [];
    fromOrder = Get.arguments['fromOrder'] ?? false;
    cartItem = Get.arguments['cartItem'] ?? CartModel();
    orderStatus = Get.arguments['orderStatus'] ?? '0';
    orderId = Get.arguments['orderId'] ?? '0';
    oldPrice = cartItem.oldPrice ?? 0.0;
    variantId = Get.arguments['variantId'];
    getMeal(mealId);

    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  buildAdditionalscount() {
    if (additionalItems.isNotEmpty) {
      for (var additional in additionalItems) {
        additionalscount[additional.id!] = additional.pivot!.quantity!;
      }
      update();
    }
  }

  bool pricesAreEqual(double? a, double? b) {
    if (a == null || b == null) return false;
    return (a * 100).round() == (b * 100).round();
  }

  getMeal(int mealId) async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await mealData.getmeal(mealId);
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
      meal = MealModel.fromJson(response);
      buildAdditionalscount();
      calculateadditionalsPrice();
      getVariant();
      calculateTotalPrice();

      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getVariant() {
    if (variantId != null &&
        meal != null &&
        meal!.variants != null &&
        meal!.variants!.isNotEmpty) {
      variant =
          meal!.variants!.firstWhere((variant) => variant.id == variantId);
      variantPrice = variant!.price;
      variantQuantity = variant!.quantity;
    }

    print("=============================== variant $variant ");
    print("=============================== variantId $variantId ");
    print("=============================== meal $meal ");
    print("===============================  meal!.variants ${meal?.variants}");
  }

  increasecount() {
    if (!fromOrder &&
        meal!.quantity != null &&
        (countmeal == meal!.quantity || countmeal == variant?.quantity)) {
      Get.snackbar(
        'انتباه',
        'لا يمكن زيادة الكمية أكثر من المتوفر',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    countmeal += 1;
    if (fromOrder == true) {
      if (meal!.quantity != null &&
          (newcountmeal == meal!.quantity ||
              newcountmeal == variant?.quantity)) {
        Get.snackbar(
          'انتباه',
          'لا يمكن زيادة الكمية أكثر من المتوفر',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }
      newcountmeal += 1;
    }
    calculateTotalPrice();
    update();
  }

  decreasecount() {
    if (countmeal > 0) {
      countmeal -= 1;
    }
    if (newcountmeal == 0 && fromOrder) {
      if (variantId != null) {
        oldPrice -= variantPrice!;
      } else {
        oldPrice -= meal!.price!;
      }
    }
    if (newcountmeal > 0 && fromOrder) {
      newcountmeal -= 1;
    }
    calculateTotalPrice();
    update();
  }

  void increaseAdditionalsCount(int itemId, int mealId) {
    if (additionalscount.containsKey(itemId)) {
      if (additionalscount[itemId]! >=
          meal!.additionals!
              .firstWhere((additional) => additional.id == itemId)
              .quantity!) {
        Get.snackbar(
          'انتباه',
          'لا يمكن زيادة الكمية أكثر من المتوفر',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return;
      }
      additionalscount[itemId] = additionalscount[itemId]! + 1;
    } else {
      additionalscount[itemId] = 1;
    }

    if (newadditionalscount.containsKey(itemId)) {
      newadditionalscount[itemId] = newadditionalscount[itemId]! + 1;
    } else {
      newadditionalscount[itemId] = 1;
    }
    update();
    calculateadditionalsPrice();
    calculateTotalPrice();
  }

  void decreaseAdditionalsCount(int itemId, int mealId) {
    if (additionalscount.containsKey(itemId)) {
      int currentQty = additionalscount[itemId]!;
      if (currentQty > 1) {
        additionalscount[itemId] = currentQty - 1;
      } else {
        additionalscount.remove(itemId); // حذف العنصر إذا وصلت الكمية للصفر
      }
      // update();
      // calculateadditionalsPrice();
      // calculateTotalPrice();
    }

    if (newadditionalscount.containsKey(itemId)) {
      int currentQty = newadditionalscount[itemId]!;
      if (currentQty > 1) {
        newadditionalscount[itemId] = currentQty - 1;
      } else {
        newadditionalscount.remove(itemId); // حذف العنصر إذا وصلت الكمية للصفر
      }
      // update();
      // calculateadditionalsPrice();
      // calculateTotalPrice();
    }

    if (!newadditionalscount.containsKey(itemId) &&
        additionalscount.containsKey(itemId)) {
      AdditionalsModel getadditionalItem =
          additionalItems.firstWhere((addiontal) => addiontal.id == itemId);
      oldPrice -= getadditionalItem.price!;
    }
    update();
    calculateadditionalsPrice();
    calculateTotalPrice();
  }

  calculateadditionalsPrice() {
    additionalsPrice = 0;
    additionalscount.forEach((additionalId, quantity) {
      for (var additional in meal!.additionals!) {
        if (additional.id == additionalId) {
          additionalsPrice += additional.price! * quantity;
          break; // نوقف عند أول تطابق
        }
      }
    });

    if (fromOrder) {
      newadditionalscount.forEach((additionalId, quantity) {
        for (var additional in meal!.additionals!) {
          if (additional.id == additionalId) {
            newadditionalsPrice += additional.price! * quantity;
            break; // نوقف عند أول تطابق
          }
        }
      });
    }
    update();
  }

  calculateTotalPrice() {
    print('====================variantId=$variantId');
    if (variantId != null) {
      totalPrice = variantPrice! * countmeal + additionalsPrice;
      print('====================variantPrice=$variantPrice');
      print('====================totalPrice=$totalPrice');
      print('====================countmeal=$countmeal');
    } else {
      totalPrice = meal!.price! * countmeal + additionalsPrice;
    }

    if (fromOrder == true) {
      if (variantId != null) {
        newtotalPrice = variantPrice! * newcountmeal + newadditionalsPrice;
      } else {
        newtotalPrice = meal!.price! * newcountmeal + newadditionalsPrice;
      }
    }
    update();
  }

  List<Map<String, dynamic>> buildAdditionalsList(
      Map<int, int> additionalscount, int mealId) {
    List<Map<String, dynamic>> result = [];
    //MealModel myMeal = meals.firstWhere((item) => item.id == mealId);

    additionalscount.forEach((id, quantity) {
      AdditionalsModel additionalold =
          meal!.additionals!.firstWhere((item) => item.id == id);
      if (quantity > 0) {
        result.add({
          'id': id,
          'quantity': quantity,
          'old_additional_price': additionalold.price.toString(),
        });
      }
    });

    return result;
  }

  updateCart() async {
    if (countmeal < 1) {
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
    List<Map<String, dynamic>> additionals =
        buildAdditionalsList(additionalscount, mealId);
    gettoken();
    update();
    double? finalprice;
    if (fromOrder) {
      finalprice = newtotalPrice + oldPrice;
    } else {
      finalprice = totalPrice;
    }

    if (fromOrder) {
      final CheckoutController checkoutController =
          Get.find<CheckoutController>();
      List<CartModel> cartItems = checkoutController.cartItems;
      CartModel cartitemedit =
          cartItems.firstWhere((item) => item.id == cartId);
      print('====================cartitemedit=${cartitemedit.oldMealPrice}');
      cartitemedit.quantity = countmeal;
      cartitemedit.newquantity = newcountmeal;

      cartitemedit.oldMealPrice = variantPrice ?? meal!.price;
      cartitemedit.oldPrice = finalprice;
      cartitemedit.additionalItems = [];
      cartitemedit.price = finalprice;
      additionalscount.forEach((id, quantity) {
        AdditionalsModel additionaledit =
            meal!.additionals!.firstWhere((item) => item.id == id);

        cartitemedit.additionalItems!.add(AdditionalsModel(
          id: additionaledit.id,
          name: additionaledit.name,
          price: additionaledit.price,
          pivot: PivotcartAdditionalModel(
            cartId: cartId,
            additionalId: additionaledit.id,
            quantity: quantity,
            newquantity: newadditionalscount[id] ?? 0,
            oldAdditionalPrice: additionaledit.price,
          ),
        ));
      });
      print('====================cartitemedit=${cartitemedit.oldMealPrice}');
      print('====================price=${cartitemedit.price}');
      Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
      final OrdersPendingController ordersPendingController =
          Get.find<OrdersPendingController>();
      await ordersPendingController.getOrderDetails(
          orderId ?? '0', orderStatus ?? '0', cartItems);
      // checkoutController.calculateTotalPrice();

      Get.snackbar(
        'نجاح',
        fromOrder
            ? 'تم تعديل العنصر في تفاصيل الطلب'
            : 'تم تعديل العنصر في السلة الشرائية',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      var response = await cartData.updateItem(
          cartId,
          mealId,
          countmeal,
          additionals,
          finalprice.toString(),
          variantId != null ? variantPrice.toString() : meal!.price.toString());
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
        // if (fromOrder == false) {
        final CartController cartController = Get.find<CartController>();
        await cartController.getCartItems();
        Get.back();
        // } else {
        // Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
        // final OrdersPendingController ordersPendingController =
        //     Get.find<OrdersPendingController>();
        // await ordersPendingController.getOrderDetails(
        //     orderId ?? '0', orderStatus ?? '0');
        // Get.back();
        Get.snackbar(
          'نجاح',
          fromOrder
              ? 'تم تعديل العنصر في تفاصيل الطلب'
              : 'تم تعديل العنصر في السلة الشرائية',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        update();
      } else {
        statusRequest = StatusRequest.failure;
        Get.back();
        Get.defaultDialog(
            title: 'تحذير',
            content: Text(
              'حدث خطأ يرجى إعادة المحاولة',
              textAlign: TextAlign.center,
            ),
            cancel: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Text('اغلاق')));

        update();
      }
    }
    update();
  }
}
