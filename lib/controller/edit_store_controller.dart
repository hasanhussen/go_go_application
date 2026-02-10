import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/home/category_data.dart';
import 'package:go_go/data/datasource/remote/profile/editstore_data.dart';
import 'package:go_go/data/model/category_model.dart';
import 'package:go_go/data/model/my_store_model.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EditStoreController extends GetxController {
  HomeScreenControllerImp homeScreenControllerImp = Get.find();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  MyServices myServices = Get.find();

  List<CategoryModel> services = [];

  StatusRequest statusRequest = StatusRequest.none;

  String token = "";

  CategoryData categoryData = CategoryData(Get.find());

  EditstoreData editstoreData = EditstoreData(Get.find());

  TextEditingController? nameController;
  TextEditingController? addressController;
  TextEditingController? phoneController;
  TextEditingController? specialController;

  //String? storeType;
  CategoryModel? selectedCategory;
  File? logoImage;
  File? coverImage;
  var hasDelivery = false;
  String boolDelivery = "0";
  int idType = 1;
  var isOnline = false;
  String boolIsOnLine = "0";

  late String oldname;
  late String oldaddress;
  late String oldPhone;
  late String oldSpecial;

  late String oldboolDeliver;
  late int oldidType;
  late String oldisOnline;

  String? logoImageName;
  String? coverImageName;

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

  List<WorkingHours>? oldworkingHours;

  LatLng? selectedLocation;

  void setStoreType2(CategoryModel selected) {
    selectedCategory = selected;
    //storeType = selected.type;
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

  void fillWorkingHours() {
    print("=============================== oldworkingHours $oldworkingHours ");
    print("=============================== workingHours $workingHours ");
    if (oldworkingHours != null && oldworkingHours!.isNotEmpty) {
      for (var wh in oldworkingHours!) {
        // نفصل الساعات والدقائق من string "HH:mm"
        final fromParts = wh.openAt!.split(':');
        final toParts = wh.closeAt!.split(':');

        workingHours[wh.day!] = {
          'from': TimeOfDay(
              hour: int.parse(fromParts[0]), minute: int.parse(fromParts[1])),
          'to': TimeOfDay(
              hour: int.parse(toParts[0]), minute: int.parse(toParts[1])),
        };

        selectedDays.add(wh.day!);
      }
    }
    print("=============================== oldworkingHours $oldworkingHours ");
    print("=============================== workingHours $workingHours ");
    update();
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

  deliveryToggle(String oldboolDeliver) {
    oldboolDeliver == "0" ? hasDelivery = false : hasDelivery = true;
    update();
  }

  onlineToggle(String oldIsOnLine) {
    oldIsOnLine == "0" ? isOnline = false : isOnline = true;
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

  editStore() async {
    var response;
    statusRequest = StatusRequest.loading;
    update();

    print(Get.arguments['id']);
    print(oldname);
    print(oldaddress);
    print(Get.arguments['image']);
    response = await editstoreData.editData(
      Get.arguments['id'],
      nameController!.text,
      addressController!.text,
      logoImage,
      coverImage,
      phoneController!.text,
      specialController!.text,
      idType.toString(),
      '1',
      boolDelivery,
      selectedDays,
      workingHours,
    );
    Get.back();
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
            editStore(); // يرجع ينفذ الطلب من جديد
          },
          onCancel: () {},
        );
        update();
        return;
      }
      Get.offAllNamed(AppRoute.homescreen);
      Get.snackbar(
        'نجاح',
        'تم تعديل متجرك بنحاج ✅',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
      // End
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
    update();
  }

  // chooseImage() async {
  //   logoImage = await fileUploadGallery();
  // }

  intialData() {
    oldname = Get.arguments['oldname'];
    oldaddress = Get.arguments['oldaddress'];
    oldPhone = Get.arguments['oldPhone'];
    oldSpecial = Get.arguments['oldSpecial'];
    //oldselectedCategory = Get.arguments['oldselectedCategory'];
    oldboolDeliver = Get.arguments['oldboolDeliver'];
    oldidType = Get.arguments['oldidType'];
    oldisOnline = Get.arguments['oldisOnline'];
    logoImageName = Get.arguments['image'];
    coverImageName = Get.arguments['cover'];
    oldworkingHours = Get.arguments['workingHours'] ?? [];
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    specialController = TextEditingController();
    //selectedCategory = oldselectedCategory;
    boolDelivery = oldboolDeliver;
    idType = oldidType;
    boolIsOnLine = oldisOnline;
    nameController!.text = oldname;
    addressController!.text = oldaddress;
    phoneController!.text = oldPhone;
    specialController!.text = oldSpecial;
    deliveryToggle(oldboolDeliver);
    onlineToggle(boolIsOnLine);
  }

  @override
  void onInit() {
    getCategories();
    intialData();
    fillWorkingHours();
    super.onInit();
  }
}
