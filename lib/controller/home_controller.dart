import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/home/banner_data.dart';
import 'package:go_go/data/datasource/remote/home/category_data.dart';
import 'package:go_go/data/model/banner_model.dart';
import 'package:go_go/data/model/category_model.dart';
import 'package:go_go/data/model/my_store_model.dart';

class HomeController extends GetxController {
  CategoryData categoryData = CategoryData(Get.find());
  BannerData bannerData = BannerData(Get.find());

  List<CategoryModel> services = [];
  List<MyStoreModel> bestStores = [];

  StatusRequest statusRequest = StatusRequest.none;

  MyServices myServices = Get.find();

  final PageController pageController = PageController(viewportFraction: 0.9);
  final RxInt currentPage = 0.obs;
  Timer? _timer;

  List<BannerModel> sliderData = [];

  getCategories() async {
    services.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await categoryData.getdata();
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

      services.addAll((response['categories'] as List)
          .map((e) => CategoryModel.fromJson(e)));
      bestStores.addAll((response['bestStores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  getBanners() async {
    sliderData.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await bannerData.getdata();
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

      sliderData.addAll((response as List).map((e) => BannerModel.fromJson(e)));

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    getBanners().then((_) {
      _startAutoSlide(); // بدء التنقل التلقائي بعد تحميل البانر
    });
    getCategories();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (currentPage.value < sliderData.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
