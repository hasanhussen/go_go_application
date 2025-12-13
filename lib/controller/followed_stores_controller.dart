import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/data/datasource/remote/store/store_data.dart';
import 'package:go_go/data/model/my_store_model.dart';

import '../core/class/statusrequest.dart';
import '../core/functions/handingdatacontroller.dart';
import '../core/services/services.dart';

// Controller
class FollowedStoresController extends GetxController {
  // List<StoreModel> followedStores = [];
  List<MyStoreModel> followedStores = [];
  String? catid;
  StoreData storeData = StoreData(Get.find());
  late StatusRequest statusRequest;

  MyServices myServices = Get.find();

  String token = "";

  @override
  void onInit() {
    getStores();
    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getStores() async {
    followedStores.clear();
    statusRequest = StatusRequest.loading;
    gettoken();
    var response = await storeData.getFollowedStores();
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
      followedStores
          .addAll((response as List).map((e) => MyStoreModel.fromJson(e)));
      print("=============================== followedStores $followedStores ");
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  goToProfileDetails(int id) {
    Get.toNamed("resturantprofile", arguments: {
      "id": id,
    });
  }
}
