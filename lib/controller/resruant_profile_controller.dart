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
import 'package:go_go/data/datasource/remote/orders/pending_data.dart';
import 'package:go_go/data/datasource/remote/store/meal_data.dart';
import 'package:go_go/data/datasource/remote/store/store_data.dart';
import 'package:go_go/data/model/cart/cart_model.dart';
import 'package:go_go/data/model/cart/pivotCart_additional_model.dart';
import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:go_go/data/model/meal/meal_model.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/data/model/order_model.dart';
import 'package:go_go/view/widgets/cart/meal_details_sheet.dart';
import 'package:go_go/view/widgets/cart/most_selling_details.dart';

class ResturantProfileController extends GetxController {
  int? followers;
  String isfollow = '0';
  String couponCode = 'KA100';
  int koins = 145;
  bool isOwner = false;

  int countMeals = 0;
  int trashCount = 0;

  Map<int, int> additionalscount = {};
  double totalPrice = 0.0;
  double additionalsPrice = 0.0;

  MyStoreModel stores = MyStoreModel();
  List<MealModel> meals = [];
  List<MealModel> mostsellingmeals = [];
  List<MealModel> waitingmeals = [];
  List<MealModel> banedmeals = [];
  List<OrderModel> pendingOrders = [];
  OrdersPendingData ordersPendingData = OrdersPendingData(Get.find());
  int? selectedOrderId;
  //String? checkoutVisited;

  StatusRequest statusRequest = StatusRequest.none;
  StoreData storeData = StoreData(Get.find());
  MealData mealData = MealData(Get.find());
  CartData cartData = CartData(Get.find());

  MyServices myServices = Get.find();

  String token = "";
  int id = 0;

  String? pendingOrderId;
  bool boolPendingOrder = false;

  double? variantPrice;
  int? selectedVariantId;
  int? variantQuantity;

  @override
  void onInit() async {
    Get.arguments['isOwner'] != null
        ? isOwner = Get.arguments['isOwner']
        : isOwner = false;
    id = Get.arguments['id'];
    pendingOrderId = myServices.sharedPreferences.getString('pendingOrderId');

    getStores(id);
    getmeals(id);
    getMostSelling(id);
    if (isOwner) {
      getWaitingMeal(id);
      getbanedMeal(id);
    }
    await getOrders();
    isPendingOrder();

    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  resetValues() {
    countMeals = 0;
    additionalscount = {};
    totalPrice = 0.0;
    additionalsPrice = 0.0;
    update();
  }

  void selectVariant(int id, double price, int? quantity) {
    resetValues();
    selectedVariantId = id;
    variantPrice = price;
    variantQuantity = quantity;
    update();
  }

  Future<bool> handleWillPop() async {
    if (countMeals > 0) {
      final result = await Get.defaultDialog<bool>(
        title: "تأكيد الإلغاء",
        middleText: "هل أنت متأكد أنك تريد عدم اكمال الطلب ؟",
        textCancel: "لا",
        textConfirm: "نعم",
        confirmTextColor: Colors.white,
        onConfirm: () {
          resetValues(); // ✨ تصفير القيم
          Get.back(result: true); // يطلع
        },
        onCancel: () {
          //Get.back(result: false); // يضل
        },
      );
      return result ?? false;
    } else {
      resetValues(); // ✨ تصفير القيم مباشرة
      return true;
    }
  }

  togglefollow(int id) {
    print(isfollow);
    if (isfollow == '0') {
      isfollow = '1';
      update();
      followers = followers! + 1;
      update();
      storeData.follow(id);
    } else if (isfollow == '1') {
      isfollow = '0';
      update();
      followers = followers! - 1;
      update();
      storeData.unfollow(id);
    }

    update();
  }

  checkfollow(int storeid) async {
    var response = await storeData.checkfollow(id);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
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
      if (response['follow'] == 'yes') {
        isfollow = '1';
        update();
      } else {
        isfollow = '0';
        update();
      }
      update();
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
  }

  getStores(int id) async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await storeData.getplofilestore(id);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      // Start backend
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
      stores = MyStoreModel.fromJson(response);
      followers = stores.followers;
      checkfollow(id);
      update();
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getmeals(int id) async {
    statusRequest = StatusRequest.loading;
    meals.clear();
    gettoken();
    update();
    var response = await mealData.getdata(id);
    print("=============================== Controllergetmeals $response ");
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
      meals.addAll((response as List).map((e) => MealModel.fromJson(e)));
      print('meals=$meals');
      getcountTrashed();
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getOrders() async {
    pendingOrders.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await ordersPendingData.getwaiting();
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

      pendingOrders
          .addAll((response as List).map((e) => OrderModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void isPendingOrder() {
    if (pendingOrderId == null) {
      boolPendingOrder = false;
      return;
    }

    final int? targetId = int.tryParse(pendingOrderId!.trim());

    final penorder = pendingOrders.firstWhereOrNull(
      (order) => order.id == targetId,
    );

    boolPendingOrder = penorder?.status.toString() == '0';

    print('pendingOrderId=$pendingOrderId');
    print('penorder found? ${penorder != null}');
    print('penorder status: ${penorder?.status}');
    print('boolPendingOrder=$boolPendingOrder');

    update();
  }

  getMostSelling(int storeId) async {
    statusRequest = StatusRequest.loading;
    mostsellingmeals.clear();
    gettoken();
    update();
    var response = await mealData.getmostselling(storeId);
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
      mostsellingmeals
          .addAll((response as List).map((e) => MealModel.fromJson(e)));
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getWaitingMeal(int storeId) async {
    statusRequest = StatusRequest.loading;
    waitingmeals.clear();
    gettoken();
    update();
    var response = await mealData.getWaitingMeals(storeId);
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
      waitingmeals.addAll((response as List).map((e) => MealModel.fromJson(e)));
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getbanedMeal(int storeId) async {
    statusRequest = StatusRequest.loading;
    banedmeals.clear();
    gettoken();
    update();
    var response = await mealData.getBanedMeals(storeId);
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
      banedmeals.addAll((response as List).map((e) => MealModel.fromJson(e)));
      update();
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  increasecount(int mealId) {
    MealModel? meal = meals.firstWhere((meal) => meal.id == mealId);
    if (meal.quantity != null && countMeals == meal.quantity) {
      Get.snackbar(
        'انتباه',
        'لا يمكن زيادة الكمية أكثر من المتوفر',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    countMeals += 1;
    calculateTotalPrice(mealId);
    update();
  }

  decreasecount(int mealId) {
    if (countMeals > 0) {
      countMeals -= 1;
    }
    calculateTotalPrice(mealId);
    update();
  }

  void increaseAdditionalsCount(int itemId, int mealId) {
    if (additionalscount.containsKey(itemId)) {
      if (meals
                  .firstWhere((meal) => meal.id == mealId)
                  .additionals!
                  .firstWhere((additional) => additional.id == itemId)
                  .quantity !=
              null &&
          additionalscount[itemId]! >=
              meals
                  .firstWhere((meal) => meal.id == mealId)
                  .additionals!
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
    update();
    calculateadditionalsPrice(mealId);
    calculateTotalPrice(mealId);
  }

  void decreaseAdditionalsCount(int itemId, int mealId) {
    if (additionalscount.containsKey(itemId)) {
      int currentQty = additionalscount[itemId]!;
      if (currentQty > 1) {
        additionalscount[itemId] = currentQty - 1;
      } else {
        additionalscount.remove(itemId); // حذف العنصر إذا وصلت الكمية للصفر
      }
      update();
      calculateadditionalsPrice(mealId);
      calculateTotalPrice(mealId);
    }
  }

  calculateadditionalsPrice(int mealId) {
    // البحث عن المنتج المطلوبة
    MealModel? selectedMeal = meals.firstWhere(
      (meal) => meal.id == mealId,
    );
    additionalsPrice = 0;
    // نحسب السعر من الإضافات المرتبطة بهاي المنتج فقط
    additionalscount.forEach((additionalId, quantity) {
      for (var additional in selectedMeal.additionals!) {
        if (additional.id == additionalId) {
          additionalsPrice += additional.price! * quantity;
          break; // نوقف عند أول تطابق
        }
      }
    });
    update();
  }

  calculateTotalPrice(int mealId) {
    MealModel? selectedMeal = meals.firstWhere(
      (meal) => meal.id == mealId,
    );
    if (selectedVariantId != null) {
      variantPrice = variantPrice ?? 0.0;
      totalPrice = variantPrice! * countMeals + additionalsPrice;
    } else {
      totalPrice = selectedMeal.price! * countMeals + additionalsPrice;
    }

    update();
  }

  List<Map<String, dynamic>> buildAdditionalsList(
      Map<int, int> additionalscount, int mealId) {
    List<Map<String, dynamic>> result = [];
    MealModel myMeal = meals.firstWhere((item) => item.id == mealId);

    additionalscount.forEach((id, quantity) {
      AdditionalsModel additionalold =
          myMeal.additionals!.firstWhere((item) => item.id == id);
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

  addtocart(int mealId, String orderId) async {
    if (countMeals < 1) {
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
    // List<Map<String, String>> oldadditionalsprice =
    //     buildAdditionalspriceList(additionalscount, mealId);
    gettoken();

    update();
    MealModel myMeal = meals.firstWhere((item) => item.id == mealId);
    print("=============================== Controller $selectedVariantId ");
    var response = await cartData.add(
        orderId,
        mealId,
        countMeals,
        additionals,
        totalPrice.toString(),
        selectedVariantId != null
            ? variantPrice.toString()
            : myMeal.price.toString(),
        selectedVariantId?.toString());
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
      if (orderId != '0') {
        if (response is Map && response['error'] != null) {
          Get.defaultDialog(
              title: 'تحذير',
              content: Text(
                response['error'],
                textAlign: TextAlign.center,
              ),
              cancel: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text('اغلاق')));
        } else {
          final CheckoutController checkoutController =
              Get.find<CheckoutController>();
          List<CartModel> cartItems = checkoutController.cartItems;
          CartModel cartitemedit = CartModel(
            mealId: mealId,
            quantity: countMeals,
            newquantity: 0,
            price: totalPrice,
            oldMealPrice: variantPrice ?? myMeal.price,
            oldPrice: totalPrice,
            meal: myMeal,
            variantId: selectedVariantId,
          );
          cartitemedit.additionalItems = [];
          additionalscount.forEach((id, quantity) {
            AdditionalsModel additionaledit =
                myMeal.additionals!.firstWhere((item) => item.id == id);
            cartitemedit.additionalItems!.add(AdditionalsModel(
              id: additionaledit.id,
              name: additionaledit.name,
              price: additionaledit.price,
              pivot: PivotcartAdditionalModel(
                additionalId: additionaledit.id,
                quantity: quantity,
                newquantity: 0,
                oldAdditionalPrice: additionaledit.price,
              ),
            ));
          });
          cartItems.add(cartitemedit);
          Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
          final OrdersPendingController ordersPendingController =
              Get.find<OrdersPendingController>();
          await ordersPendingController.getOrderDetails(
              orderId, '0', cartItems);
          Get.snackbar(
            'نجاح',
            'تمت إضافة العنصر الى طلبك و تعديل السعر',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      } else {
        if (response is Map && response['error'] != null) {
          Get.defaultDialog(
              title: 'تحذير',
              content: Text(
                // 'يرجى الذهاب الى السلة و تعديل الطلب، العنصر موجود مسبقًا في السلة الشرائية\n.',
                response['error'],
                textAlign: TextAlign.center,
              ),
              cancel: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text('اغلاق')));
        } else {
          final CartController cartController = Get.find<CartController>();
          await cartController.getCartItems();

          Get.back();
          Get.snackbar(
            'نجاح',
            'تمت إضافة العنصر الى السلة الشرائية',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        }
      }

      resetValues();
      update();
    } else if (StatusRequest.serverException == statusRequest) {
      Get.defaultDialog(
          title: 'تحذير',
          content: Text(
            'يرجى الذهاب الى السلة و تعديل الطلب، العنصر موجود مسبقًا في السلة الشرائية\n.',
            textAlign: TextAlign.center,
          ),
          cancel: InkWell(
              onTap: () {
                Get.back();
              },
              child: Text('اغلاق')));

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
    update();
  }

  void showMealDetails(int index) {
    if (meals[index].quantity != null && meals[index].quantity == 0) {
      Get.snackbar(
        'انتباه',
        'هذا المنتج غير متوفر حالياً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    Get.bottomSheet(
        MealDetailsSheet(
          index: index,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        )).whenComplete(() {
      // ✅ هون بتنكتب الدالة يلي لازم تتنفذ بعد الإغلاق
      print("تم إغلاق الـ BottomSheet");
      resetValues(); // مثال: إعادة تحميل البيانات
    });
  }

  void showMostSellingDetails(int index) {
    if (mostsellingmeals[index].quantity != null &&
        mostsellingmeals[index].quantity == 0) {
      Get.snackbar(
        'انتباه',
        'هذا المنتج غير متوفر حالياً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    Get.bottomSheet(
        MostSellingDetails(
          index: index,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        )).whenComplete(() {
      // ✅ هون بتنكتب الدالة يلي لازم تتنفذ بعد الإغلاق
      print("تم إغلاق الـ BottomSheet");
      resetValues(); // مثال: إعادة تحميل البيانات
    });
  }

  gotoAddMeal() {
    Get.toNamed(AppRoute.addMealView, arguments: {'storeId': stores.id});
  }

  getcountTrashed() async {
    var response =
        await mealData.getTrashedCounts(stores.id!); // implement endpoint
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      print("trashCount: $response");
      trashCount = response['trashCount'];
    } else {
      trashCount = 0;
    }
    update();
  }

  hideMeal(int mealId) async {
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await mealData.hideMeal(mealId.toString()); // implement endpoint
    print("hideMeal response: $response");
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      // بعد الإخفاء نجدد القوائم
      await getmeals(stores.id!);
      //await getMostSelling(stores.id!);
      // await getcountTrashed();
      Get.snackbar(
        'نجاح',
        'تم إخفاء المنتج',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      statusRequest = StatusRequest.failure;
      Get.snackbar('خطأ', 'حدث خطأ أثناء الإخفاء',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
    }
    update();
  }

  deleteMealPermanent(int mealId) async {
    statusRequest = StatusRequest.loading;
    update();
    var response =
        await mealData.softDeleteMeal(mealId.toString()); // implement endpoint
    print("deleteMealPermanent response: $response");
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      await getmeals(stores.id!);
      await getMostSelling(stores.id!);
      await getWaitingMeal(stores.id!);
      await getbanedMeal(stores.id!);
      Get.snackbar(
        'نجاح',
        'تم الحذف النهائي للمنتج',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      statusRequest = StatusRequest.failure;
      Get.snackbar('خطأ', 'حدث خطأ أثناء الحذف النهائي',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white);
    }
    update();
  }

  gotoMealTrash() {
    Get.toNamed(AppRoute.mealTrashScreen, arguments: {'storeId': stores.id});
  }

  List<AdditionalsModel> selectedAdditionals = [];
  List<String> selectedAdditionalsId = [];

  void getSelectedAdditionals(int mealid) {
    //MealModel myMeal = meals.firstWhere((item) => item.id == mealid);
    MealModel? myMeal =
        waitingmeals.firstWhereOrNull((item) => item.id == mealid);
    myMeal ??= banedmeals.firstWhereOrNull((item) => item.id == mealid);
    myMeal ??= meals.firstWhereOrNull((item) => item.id == mealid);

    if (myMeal == null) {
      Get.snackbar('خطأ', 'المنتج غير موجودة');
      return;
    }
    // نظف القوائم أولاً
    selectedAdditionals.clear();
    selectedAdditionalsId.clear();

    // جلب الإضافات الموجودة مسبقًا
    selectedAdditionals = myMeal.additionals ?? [];
    for (var item in selectedAdditionals) {
      selectedAdditionalsId.add(item.id.toString());
    }

    // خزن بالقيمة الجديدة فقط
    myServices.sharedPreferences.setStringList(
        'selectedAdditionals', selectedAdditionalsId.toSet().toList());
  }

  gotoEditMeal(int mealId) async {
    MealModel? myMeal =
        waitingmeals.firstWhereOrNull((item) => item.id == mealId);
    myMeal ??= banedmeals.firstWhereOrNull((item) => item.id == mealId);
    myMeal ??= meals.firstWhereOrNull((item) => item.id == mealId);

    if (myMeal == null) {
      Get.snackbar('خطأ', 'المنتج غير موجودة');
      return;
    }

    getSelectedAdditionals(mealId);

    Get.toNamed(AppRoute.editMealView, arguments: {
      'storeId': stores.id,
      'mealId': mealId,
      'nameMeal': myMeal.name,
      'priceMeal': myMeal.price.toString(),
      'description': myMeal.description,
      'quantity': myMeal.quantity.toString(),
      'image': myMeal.image,
      'variants': myMeal.variants ?? [],
    });
  }

  rateStore(double rating) {
    storeData.rateStore(stores.id!, rating).then((response) {
      print("=============================== Controller $response ");
      statusRequest = handlingData(response);
      if (statusRequest == StatusRequest.success) {
        Get.back();
        Get.snackbar(
          'شكراَ',
          'تم ارسال تقييمك بنجاح',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تقييم المتجر',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    });
  }

  @override
  void dispose() {
    myServices.sharedPreferences.remove('pendingOrderId');
    super.dispose();
  }
}
