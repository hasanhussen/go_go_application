import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/home/category_data.dart';
import 'package:go_go/data/datasource/remote/profile/profile.dart';
import 'package:go_go/data/datasource/remote/store/store_data.dart';
import 'package:go_go/data/model/category_model.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/view/screen/cart/cart.dart';
import 'package:go_go/view/screen/notification_screen.dart';
import 'package:go_go/view/screen/orders/pending.dart';
import 'package:go_go/view/screen/profile.dart';

class HomeScreenControllerImp extends GetxController {
  int? currentpage;
  bool showHomePage = true;
  bool showcategoryList = false;
  // List<StoreModel> restaurants = [];
  List<MyStoreModel> restaurants = [];
  StoreData storeData = StoreData(Get.find());
  ProfileData profileData = ProfileData(Get.find());
  String token = "";
  String status = "";
  //int? pendingOrderId;

  List<CategoryModel> services = [];
  List<MyStoreModel> bestStores = [];

  int notOppendNotification = 0;

  StatusRequest statusRequest = StatusRequest.none;

  MyServices myServices = Get.find();
  CategoryData categoryData = CategoryData(Get.find());

  String? image;
  String? type;

  List<Widget> listPage = [
    ProfileScreen(),
    NotificationScreen(),
    Cart(),
    OrdersPending(),
  ];

  List bottomappbar = [
    {"title": "profile", "icon": Icons.person},
    {"title": "notification", "icon": Icons.notifications},
    {"title": "delivery", "icon": Icons.shopping_cart},
    {"title": "myorders", "icon": Icons.list}
  ];

  changePage(int i) {
    showHomePage = false;
    showcategoryList = false;
    currentpage = i;
    update();
  }

  toggleShowHomePage() {
    showHomePage = true;
    showcategoryList = false;
    currentpage = null;
    update();
  }

  toggleShowCategoryList(int id, int index) {
    getStores(id);
    showHomePage = false;
    showcategoryList = true;
    currentpage = null;
    image = services[index].image;
    type = services[index].type;
    update();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getStores(int id) async {
    restaurants.clear();
    statusRequest = StatusRequest.loading;
    gettoken();
    var response = await storeData.getdata(id);
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
      restaurants
          .addAll((response as List).map((e) => MyStoreModel.fromJson(e)));
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    getCategories();
    if (Get.arguments != null) {
      if (Get.arguments['page'] != null) {
        changePage(Get.arguments['page']);
      }
    }

    super.onInit();
  }

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
      print('*************response $response');
      print('*************categories${response['categories']}');
      services.addAll((response['categories'] as List)
          .map((e) => CategoryModel.fromJson(e)));
      bestStores.addAll((response['bestStores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));

      notOppendNotification = response['notOppendNotification'];
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }
}
