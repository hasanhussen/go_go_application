import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/store/meal_data.dart';
import 'package:go_go/data/model/meal/meal_model.dart';

class MealTrashController extends GetxController {
  int? storeId;

  // List hiddenMeals = [];
  // List trashedMeals = [];
  // bool isLoading = false;

  List<MealModel> hiddenMeals = [];
  List<MealModel> trashedMeals = [];

  StatusRequest statusRequest = StatusRequest.none;
  MealData mealData = MealData(Get.find());

  MyServices myServices = Get.find();

  String token = "";

  Future<void> fetchHiddenMeals() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await mealData.getHiddenMeals(storeId!);
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
        hiddenMeals
            .addAll((response as List).map((e) => MealModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  // ✅ جلب المنتجات المحذوفة
  Future<void> fetchTrashedMeals() async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await mealData.getTrashedMeals(storeId!);
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
        trashedMeals
            .addAll((response as List).map((e) => MealModel.fromJson(e)));
      } else {
        statusRequest = StatusRequest.failure;
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  // ✅ استرجاع منتج مخفية
  Future<void> restoreHidden(String mealId) async {
    statusRequest = StatusRequest.loading;
    update();
    try {
      var response = await mealData.restoreHiddenMeal(mealId);
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
        hiddenMeals.removeWhere((m) => m.id.toString() == mealId);
        final ResturantProfileController resturantProfileController =
            Get.find<ResturantProfileController>();
        await resturantProfileController.getmeals(storeId!);
        await resturantProfileController.getMostSelling(storeId!);
        Get.snackbar(
          'نجاح',
          'تم إرجاع المنتج ',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void sendAppeal(int mealId, String reason) async {
    var response = await mealData.sendAppeal(mealId, reason);
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
      Get.back();
      Get.snackbar(
        "تم الإرسال",
        "تم إرسال الاعتراض وسيتم مراجعته قريبًا.",
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade800,
      );
    }
  }

  // Future<void> restoreTrashed(String mealId) async {
  //   await mealData.restoreTrashedMeal(mealId);
  //   trashedMeals.removeWhere((m) => m['id'].toString() == mealId);
  //   update();
  // }

  @override
  void onInit() {
    storeId = Get.arguments['storeId'] ?? 0;
    print(storeId);
    fetchHiddenMeals();
    fetchTrashedMeals();
    super.onInit();
  }
}
