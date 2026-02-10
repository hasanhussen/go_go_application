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
import 'package:go_go/data/model/meal/meal_model.dart';
import 'package:image_picker/image_picker.dart';

class EditMealController extends GetxController {
  StatusRequest statusRequest = StatusRequest.none;
  MealData mealData = MealData(Get.find());

  MyServices myServices = Get.find();

  String token = "";
  int? storeId;
  int? mealId;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool additionalAlwaysAvailable = false;
  final quantityAdditionalController = TextEditingController();

  TextEditingController nameMealController = TextEditingController();
  TextEditingController priceMealController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  // قائمة الإضافات القديمة
  List<AdditionalsModel> additionals = [];

  List<AdditionalsModel> selectedAdditionals = [];
  List<String> selectedAdditionalsId = [];

  bool alwaysAvailable = false;
  File? selectedImage;
  String? selectedImageName;
  List<MealVariants> variants = [];
  //List<Map<String, String>> variants = [];
  bool isVariant = false;
  List<TextEditingController> variantNameControllers = [];
  List<TextEditingController> variantPriceControllers = [];
  List<TextEditingController> variantQuantityControllers = [];

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      update();
    }
  }

  toggleIsVariant(bool value) {
    isVariant = value;

    if (value) {
      // إنشاء حقلين إفتراضيين عند التفعيل
      if (variantNameControllers.isEmpty) addVariantField();
      if (variantNameControllers.length < 2) addVariantField();
      priceMealController.clear();
      quantityController.clear();
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
    if (variantNameControllers.isEmpty) {
      isVariant = false;
    }
    update();
  }

// تبديل الحالة "متوفر دائمًا"
  void toggleAlwaysAvailable(bool value) {
    alwaysAvailable = value;
    if (value) quantityController.clear();
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

  void toggleAdditionalAvailable(bool value) {
    additionalAlwaysAvailable = value;
    if (value) quantityAdditionalController.clear();
    update();
  }

  // إضافة إضافة جديدة
  void addNewAddition() async {
    bool exists = additionals.any((a) => a.name == nameController.text.trim());
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
          quantityAddiontalValue);
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
    selectedAdditionalsId.clear();
    selectedAdditionalsId =
        myServices.sharedPreferences.getStringList('selectedAdditionals') ?? [];
    print('selectedAdditionalsId=$selectedAdditionalsId');
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
      print("Adding ${add.id} from selectedAdditionalsId");
      if (!selectedAdditionals.any((a) => a.id == add.id)) {
        selectedAdditionals.add(add);
      }
      if (!selectedAdditionalsId.contains(add.id.toString())) {
        selectedAdditionalsId.add(add.id.toString());
      }
    } else {
      print("Removing ${add.id} from selectedAdditionalsId");
      selectedAdditionals.removeWhere((a) => a.id == add.id);
      selectedAdditionalsId.remove(add.id.toString());
    }
    // myServices.sharedPreferences.setStringList(
    //     'selectedAdditionals', selectedAdditionalsId.toSet().toList());
    myServices.sharedPreferences
        .setStringList('selectedAdditionals', selectedAdditionalsId);

    update();
  }

  editmeal() async {
    if (nameMealController.text.isEmpty || descriptionController.text.isEmpty) {
      Get.snackbar("خطأ", "الرجاء إدخال جميع الحقول المطلوبة",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // تحقق من السعر والكمية إذا مش متعدد المقاسات
    if (!isVariant) {
      if (priceMealController.text.isEmpty ||
          (!alwaysAvailable && quantityController.text.isEmpty)) {
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
    List<int> additionalaIds =
        selectedAdditionals.map((a) => a.id!).toSet().toList();
    String? quantityValue;
    if (variants.isEmpty) {
      quantityValue = quantityController.text.trim();
    } else {
      int totalQuantity = variantQuantityControllers.fold<int>(
          0,
          (prev, element) =>
              prev +
              int.parse(
                  element.text.trim().isEmpty ? '0' : element.text.trim()));
      quantityValue = totalQuantity.toString();
    }

    List<Map<String, String>> variantData = [];
    for (int i = 0; i < variantNameControllers.length; i++) {
      variantData.add({
        "name": variantNameControllers[i].text.trim(),
        "quantity": variantQuantityControllers[i].text.trim(),
        "price": variantPriceControllers[i].text.trim()
      });
    }

    var response = await mealData.editMeal(
        mealId!.toString(),
        storeId!.toString(),
        nameMealController.text.trim(),
        descriptionController.text.trim(),
        quantityValue,
        // quantityController.text.trim(),
        additionalaIds,
        (!isVariant) ? priceMealController.text.trim() : null,
        selectedImage,
        variants: variantData);
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
        'تم تعديل المنتج في متجرك',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  openEditAdiitional(int additionalId) {
    AdditionalsModel myAdditional =
        additionals.firstWhere((item) => item.id == additionalId);
    quantityAdditionalController.text = myAdditional.quantity.toString();
    if (myAdditional.quantity != null) {
      additionalAlwaysAvailable = true;
    }
    nameController.text = myAdditional.name ?? '';
    priceController.text = myAdditional.price.toString();
    update();
  }

  editAaddtional(String additionalId) async {
    statusRequest = StatusRequest.loading;
    gettoken();
    update();
    final quantityAddiontalValue = additionalAlwaysAvailable
        ? null
        : quantityAdditionalController.text.trim();
    var response = await mealData.editAdditional(
        additionalId,
        storeId!.toString(),
        nameController.text.trim(),
        priceController.text.trim(),
        quantityAddiontalValue);

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
      Get.back();
      Get.snackbar(
        'نجاح',
        'تم تعديل الإضافة ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  deleteAdditional(int additionalId) async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await mealData.deleteAdditional(additionalId.toString());
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
      getAdditionals();
      final ResturantProfileController resturantProfileController =
          Get.find<ResturantProfileController>();
      await resturantProfileController.getmeals(storeId!);
      await resturantProfileController.getMostSelling(storeId!);
      Get.snackbar(
        'نجاح',
        'تم حذف الإضافة ',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  @override
  void onInit() {
    storeId = Get.arguments['storeId'] ?? 0;
    mealId = Get.arguments['mealId'] ?? 0;
    nameMealController.text = Get.arguments['nameMeal'] ?? '';
    priceMealController.text = Get.arguments['priceMeal'] ?? '';
    descriptionController.text = Get.arguments['description'] ?? '';
    quantityController.text = Get.arguments['quantity'] ?? '';
    if (Get.arguments['quantity'] == null ||
        Get.arguments['quantity'] == 'null') {
      alwaysAvailable = true;
    }
    selectedImageName = Get.arguments['image'];
    variants = Get.arguments['variants'] ?? [];
    isVariant = variants.isNotEmpty ? true : false;
    for (var variant in variants) {
      variantNameControllers.add(TextEditingController(text: variant.name));
      variantPriceControllers
          .add(TextEditingController(text: variant.price.toString()));
      variantQuantityControllers
          .add(TextEditingController(text: variant.quantity.toString()));
    }
    getAdditionals();
    super.onInit();
  }

  @override
  void dispose() {
    myServices.sharedPreferences.remove('selectedAdditionals');
    super.dispose();
  }
}
