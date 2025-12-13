import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/home/category_data.dart';
import 'package:go_go/data/datasource/remote/profile/addstore_data.dart';
import 'package:go_go/data/model/category_model.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddStoreController extends GetxController {
  HomeScreenControllerImp homeScreenControllerImp = Get.find();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  MyServices myServices = Get.find();

  List<CategoryModel> services = [];

  StatusRequest statusRequest = StatusRequest.none;

  String token = "";

  CategoryData categoryData = CategoryData(Get.find());

  AddstoreData addstoreData = AddstoreData(Get.find());
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final specialController = TextEditingController();
  String? storeType;
  CategoryModel? selectedCategory;
  File? logoImage;
  File? coverImage;
  var hasDelivery = false;
  String boolDelivery = "0";
  int idType = 1;
  var isOnline = false;
  // List<String> types = [
  //   //'مطعم', 'مخبز', 'محل تجميل', 'بقالة', 'صيدلية'
  // ];
  List<String> weekDays = [
    'السبت',
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة'
  ];
  RxSet<String> selectedDays = <String>{}.obs;
  RxBool openAlways = false.obs;
  RxMap<String, Map<String, TimeOfDay>> workingHours =
      <String, Map<String, TimeOfDay>>{}.obs;

  LatLng? selectedLocation;

  // void setStoreType(String? value) {
  //   storeType = value;

  //   update();A
  // }

  void setStoreType2(CategoryModel selected) {
    selectedCategory = selected;
    storeType = selected.type;
    idType = selected.id!;
    update();
  }

  Future pickLogo() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      logoImage = File(picked.path);
      update();
    }
  }

  Future pickCover() async {
    final pickedCover =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedCover != null) {
      coverImage = File(pickedCover.path);
      update();
    }
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

      // services.addAll((response as List).map((e) => CategoryModel.fromJson(e)));
      services.addAll((response['categories'] as List)
          .map((e) => CategoryModel.fromJson(e)));
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    selectedLocation = LatLng(position.latitude, position.longitude);
  }

  void toggleDelivery(bool? value) {
    hasDelivery = value ?? false;
    update();
  }

  void toggleOnline(bool? value) {
    isOnline = value ?? false;
    update();
  }

  void toggleDay(String day, bool? value) {
    if (value == true) {
      selectedDays.add(day);
    } else {
      selectedDays.remove(day);
      openAlways.value = false;
    }
    update();
  }

  void setAlwaysOpen(bool? value) {
    openAlways.value = value ?? false;
    if (openAlways.value) {
      selectedDays.addAll(weekDays);
    } else {
      selectedDays.clear();
    }
    update();
  }

  void setTime(String day, TimeOfDay from, TimeOfDay to) {
    workingHours[day] = {'from': from, 'to': to};
    update();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  hasDelivrey() {
    hasDelivery == false ? boolDelivery = "0" : boolDelivery = "1";
    update();
  }

  // String formatTimeOfDay(TimeOfDay t) {
  //   final hour = t.hour.toString().padLeft(2, '0');
  //   final minute = t.minute.toString().padLeft(2, '0');
  //   return "$hour:$minute";
  // }

  // Map<String, dynamic> getWorkingHoursJson() {
  //   Map<String, dynamic> data = {};

  //   workingHours.forEach((day, times) {
  //     data[day] = {
  //       "from": formatTimeOfDay(times['from']!),
  //       "to": formatTimeOfDay(times['to']!),
  //     };
  //   });

  //   return data;
  // }

  addStore() async {
    if (formstate.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      gettoken();
      hasDelivrey();
      update();
      //final workingHoursJson = getWorkingHoursJson();
      var response = await addstoreData.postdata(
        nameController.text,
        addressController.text,
        idType.toString(),
        '1',
        boolDelivery,
        //workingHoursJson,
        logoImage,
        coverImage,
        phoneController.text,
        specialController.text,
        selectedDays,
        workingHours,
      );
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
              addStore(); // يرجع ينفذ الطلب من جديد
            },
            onCancel: () {},
          );
          update();
          return;
        }
        Get.snackbar(
          "111".tr,
          "110".tr,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
        //Get.defaultDialog(title: "111".tr, middleText: "110".tr);
        Get.offAllNamed(AppRoute.homescreen);
        update();
      } else {
        Get.defaultDialog(title: "112".tr, middleText: "113".tr);
        update();
      }
      update();
    } else {
      Get.defaultDialog(title: "112".tr, middleText: "113".tr);
      update();
    }
  }

  // getType() {
  //   types.addAll(services.map((e) => e.type!).toList());
  //   update();
  // }

  @override
  void onInit() {
    getCategories();
    super.onInit();
  }
}
