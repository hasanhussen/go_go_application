import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/profile/deletestore_data.dart';
import 'package:go_go/data/datasource/remote/profile/my_stores_data.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'package:go_go/view/screen/add_store_screen.dart';

class MyStoresController extends GetxController {
  // List<MyStoreModel> stores = [];
  List<MyStoreModel> newStores = [];
  List<MyStoreModel> deletedStores = [];
  List<MyStoreModel> activeStores = [];
  List<MyStoreModel> blockedStores = [];
  StatusRequest statusRequest = StatusRequest.none;
  MyStoresData myStoresData = MyStoresData(Get.find());
  DeletestoreData deletestoreData = DeletestoreData(Get.find());

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
    activeStores.clear();
    newStores.clear();
    deletedStores.clear();
    blockedStores.clear();
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await myStoresData.getmyStores();
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

      activeStores.addAll((response['active_stores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));
      newStores.addAll((response['new_stores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));
      deletedStores.addAll((response['deleted_stores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));
      blockedStores.addAll((response['banned_stores'] as List)
          .map((e) => MyStoreModel.fromJson(e)));

      // activeStores = stores.where((s) => s.status == '1').toList();
      // blockedStores = stores.where((s) => s.status == '2').toList();

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  // getNewStores() async {
  //   newStores.clear();
  //   statusRequest = StatusRequest.loading;
  //   gettoken();
  //   update();
  //   var response = await myStoresData.getNewStores();
  //   print("=============================== Controller $response ");
  //   statusRequest = handlingData(response);
  //   if (StatusRequest.success == statusRequest) {
  //     // Start backend

  //     newStores.addAll((response as List).map((e) => MyStoreModel.fromJson(e)));

  //     // End
  //   } else {
  //     statusRequest = StatusRequest.failure;
  //   }
  //   update();
  // }

  // getDeletedStores() async {
  //   deletedStores.clear();
  //   statusRequest = StatusRequest.loading;
  //   gettoken();
  //   update();
  //   var response = await myStoresData.getDeletedStores();
  //   print("=============================== Controller $response ");
  //   statusRequest = handlingData(response);
  //   if (StatusRequest.success == statusRequest) {
  //     // Start backend

  //     deletedStores
  //         .addAll((response as List).map((e) => MyStoreModel.fromJson(e)));

  //     // End
  //   } else {
  //     statusRequest = StatusRequest.failure;
  //   }
  //   update();
  // }

  deletestore(int id) async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    var response = await deletestoreData.deletestore(id.toString());
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

      Get.showSnackbar(GetSnackBar(
        title: '111'.tr,
        message: '121'.tr,
        duration: const Duration(seconds: 3),
      ));
      // Get.defaultDialog(title: "111".tr, middleText: "121".tr);
      // update();
      activeStores.removeWhere((store) => store.id == id);
      update();
      //getStores();

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void goToAddStore() {
    Get.to(() => const AddStoreScreen());
  }

  gotoedit(
      String id,
      String oldname,
      String oldaddress,
      String oldboolDeliver,
      int oldidType,
      String oldisOnline,
      oldPhone,
      oldSpecial,
      image,
      cover,
      List<WorkingHours>? workingHours) {
    Get.offNamed(AppRoute.editstores, arguments: {
      'id': id,
      'oldname': oldname,
      'oldaddress': oldaddress,
      'oldboolDeliver': oldboolDeliver,
      'oldidType': oldidType,
      'oldisOnline': oldisOnline,
      'oldPhone': oldPhone,
      'oldSpecial': oldSpecial,
      'image': image,
      'cover': cover,
      'workingHours': workingHours,
    });
  }

  goToProfileDetails(int id) {
    Get.toNamed("resturantprofile", arguments: {"id": id, "isOwner": true});
  }

  void sendAppeal(int storeId, String reason) async {
    var response = await myStoresData.sendAppeal(storeId, reason);
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
}
