import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:go_go/controller/resruant_profile_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/store/meal_data.dart';
import 'package:go_go/data/model/meal/additional_model.dart';
import 'package:image_picker/image_picker.dart';

class MealController extends GetxController {
  StatusRequest statusRequest = StatusRequest.none;
  MealData mealData = MealData(Get.find());

  MyServices myServices = Get.find();

  String token = "";
  int? storeId;

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  bool additionalAlwaysAvailable = false;
  final quantityAdditionalController = TextEditingController();

  final nameMealController = TextEditingController();
  final priceMealController = TextEditingController();
  final descriptionController = TextEditingController();
  final quantityMealController = TextEditingController();

  // قائمة الإضافات القديمة
  List<AdditionalsModel> additionals = [];

  List<AdditionalsModel> selectedAdditionals = [];
  List<String> selectedAdditionalsId = [];

// متغيرات جديدة
  bool alwaysAvailable = false;
  File? selectedImage;

  bool isVariant = false; // هل المنتج متعدد المقاسات؟
  List<TextEditingController> variantNameControllers = [];
  List<TextEditingController> variantPriceControllers = [];
  List<TextEditingController> variantQuantityControllers = [];

  void toggleIsVariant(bool value) {
    isVariant = value;

    if (value) {
      // إنشاء حقلين إفتراضيين عند التفعيل
      if (variantNameControllers.isEmpty) addVariantField();
      if (variantNameControllers.length < 2) addVariantField();
      priceMealController.clear();
      quantityMealController.clear();
    } else {
      // مسح كل الحقول المرتبطة بالمقاسات عند إلغاء الخيار
      for (var c in variantNameControllers) c.dispose();
      for (var c in variantPriceControllers) c.dispose();
      for (var c in variantQuantityControllers) c.dispose();
      variantNameControllers.clear();
      variantPriceControllers.clear();
      variantQuantityControllers.clear();
    }
    update();
  }

  void addVariantField() {
    variantNameControllers.add(TextEditingController());
    variantPriceControllers.add(TextEditingController());
    variantQuantityControllers.add(TextEditingController());
    update();
  }

  void removeVariantField(int index) {
    variantNameControllers[index].dispose();
    variantPriceControllers[index].dispose();
    variantQuantityControllers[index].dispose();
    variantNameControllers.removeAt(index);
    variantPriceControllers.removeAt(index);
    variantQuantityControllers.removeAt(index);
    update();
  }

// اختيار صورة

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      update();
    }
  }

// تبديل الحالة "متوفر دائمًا"
  void toggleAlwaysAvailable(bool value) {
    alwaysAvailable = value;
    if (value) quantityMealController.clear();
    update();
  }

  void toggleAdditionalAvailable(bool value) {
    additionalAlwaysAvailable = value;
    if (value) quantityAdditionalController.clear();
    update();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getAdditionals() async {
    additionals.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await mealData.getAdditionals(storeId!);
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
      additionals
          .addAll((response as List).map((e) => AdditionalsModel.fromJson(e)));
      getSelectedAdditionals();
      update();
    } else {
      statusRequest = StatusRequest.failure;
      update();
    }
  }

  // إضافة إضافة جديدة
  void addNewAddition() async {
    bool exists = additionals.any((a) => a.name == nameController.text.trim());
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        (!additionalAlwaysAvailable &&
            quantityAdditionalController.text.isEmpty)) {
      Get.snackbar("تنبيه", "يرجى إدخال كل الحقول المطلوبة",
          backgroundColor: Colors.orangeAccent, colorText: Colors.white);
      return;
    }
    if (!exists) {
      statusRequest = StatusRequest.loading;
      update();
      final quantityAddiontalValue = additionalAlwaysAvailable
          ? null
          : quantityAdditionalController.text.trim();

      var response = await mealData.addAdditional(
        storeId!.toString(),
        nameController.text.trim(),
        priceController.text.trim(),
        quantityAddiontalValue,
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
            buttonColor: Colors.red,
            textCancel: "إغلاق",
            cancelTextColor: Colors.black,
            onCancel: () {},
          );
          update();
          return;
        }
        getAdditionals();
      } else {
        statusRequest = StatusRequest.failure;
        update();
      }
    } else {
      Get.snackbar("Warning", 'هذه الإضافة موجودة بالفعل في القائمة');
    }
  }

  void getSelectedAdditionals() {
    selectedAdditionalsId =
        myServices.sharedPreferences.getStringList('selectedAdditionals') ?? [];

    selectedAdditionals.clear();

    for (var id in selectedAdditionalsId) {
      var add = additionals.firstWhereOrNull((a) => a.id.toString() == id);
      if (add != null) {
        selectedAdditionals.add(add);
      }
    }
    update();
  }

  // تبديل حالة الاختيار
  void toggleAddition(int index, bool value) {
    final add = additionals[index];
    if (value) {
      if (!selectedAdditionals.any((a) => a.id == add.id)) {
        selectedAdditionals.add(add);
        selectedAdditionalsId.add(add.id.toString());
      }
    } else {
      selectedAdditionals.removeWhere((a) => a.id == add.id);
      selectedAdditionalsId.remove(add.id.toString());
    }
    myServices.sharedPreferences
        .setStringList('selectedAdditionals', selectedAdditionalsId);
    update();
  }

  addmeals() async {
    if (nameMealController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedImage == null) {
      Get.snackbar("خطأ", "الرجاء إدخال جميع الحقول المطلوبة",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // تحقق من السعر والكمية إذا مش متعدد المقاسات
    if (!isVariant) {
      if (priceMealController.text.isEmpty ||
          (!alwaysAvailable && quantityMealController.text.isEmpty)) {
        Get.snackbar("خطأ", "الرجاء إدخال السعر والكمية",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    } else {
      // تحقق من المقاسات
      bool anyEmpty = false;
      for (int i = 0; i < variantNameControllers.length; i++) {
        if (variantNameControllers[i].text.isEmpty ||
            variantPriceControllers[i].text.isEmpty ||
            variantQuantityControllers[i].text.isEmpty) {
          anyEmpty = true;
          break;
        }
      }
      if (variantNameControllers.isEmpty || anyEmpty) {
        Get.snackbar("خطأ", "الرجاء إدخال جميع بيانات المقاسات",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
    }

    statusRequest = StatusRequest.loading;
    gettoken();
    update();

    List<int> additionalaIds = selectedAdditionals.map((a) => a.id!).toList();

// قبل إرسال الطلب
    final quantityValue = !isVariant
        ? (alwaysAvailable ? null : quantityMealController.text.trim())
        : variantQuantityControllers
            .fold<int>(
              0,
              (previousValue, element) =>
                  previousValue + int.parse(element.text.trim()),
            )
            .toString();

    List<Map<String, dynamic>> variants = [];
    if (isVariant) {
      for (int i = 0; i < variantNameControllers.length; i++) {
        variants.add({
          'name': variantNameControllers[i].text.trim(),
          'price': variantPriceControllers[i].text.trim(),
          'quantity': variantQuantityControllers[i].text.trim(),
        });
      }
    }

    var response = await mealData.addmeal(
      storeId!.toString(),
      nameMealController.text.trim(),
      descriptionController.text.trim(),
      quantityValue,
      additionalaIds,
      (!isVariant) ? priceMealController.text.trim() : null,
      selectedImage,
      variants: variants, // نمرر المقاسات
    );
    print("=============================== additionalaIds $additionalaIds ");
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
      myServices.sharedPreferences.remove('selectedAdditionals');
      final ResturantProfileController resturantProfileController =
          Get.find<ResturantProfileController>();
      await resturantProfileController.getmeals(storeId!);
      await resturantProfileController.getMostSelling(storeId!);
      Get.back();
      Get.snackbar(
        'نجاح',
        'تمت إضافة المنتج الى متجرك',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    storeId = Get.arguments['storeId'] ?? 0;
    getAdditionals();
    super.onInit();
  }

  @override
  void dispose() {
    myServices.sharedPreferences.remove('selectedAdditionals');
    super.dispose();
  }
}
