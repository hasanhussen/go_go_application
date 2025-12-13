import 'dart:io';

import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class MealData {
  Crud crud;
  MealData(this.crud);
  getdata(int storeid) async {
    var response =
        await crud.getData(AppLink.getstoremeals + '/' + storeid.toString());
    return response.fold((l) => l, (r) => r);
  }

  getmostselling(int storeid) async {
    var response =
        await crud.getData(AppLink.mostSellingmeals + '/' + storeid.toString());
    return response.fold((l) => l, (r) => r);
  }

  getmeal(int mealId) async {
    var response =
        await crud.getData(AppLink.getmeal + '/' + mealId.toString());
    return response.fold((l) => l, (r) => r);
  }

  getWaitingMeals(int storeid) async {
    var response =
        await crud.getData(AppLink.getwaitingmeals + '/' + storeid.toString());
    return response.fold((l) => l, (r) => r);
  }

  getBanedMeals(int storeid) async {
    var response =
        await crud.getData(AppLink.getBanedgmeals + '/' + storeid.toString());
    return response.fold((l) => l, (r) => r);
  }

  addmeal(
    String storeid,
    String name,
    String description,
    String? quantity,
    List<int> additionals,
    String? price,
    File? imagefile, {
    List<Map<String, dynamic>>? variants, // <-- جديد
  }) async {
    var response;
    Map<String, String> data = {
      "store_id": storeid,
      "name": name,
      "description": description,
      // "price": price,
    };

    if (price != null) data['price'] = price;

    if (quantity != null && quantity.isNotEmpty) data['quantity'] = quantity;

    // ✳️ نضيف كل إضافة بشكل منفصل كـ additionals[0], additionals[1], ...
    for (int i = 0; i < additionals.length; i++) {
      data["additionals[$i]"] = additionals[i].toString();
    }

    // ✳️ إضافة المقاسات
    if (variants != null && variants.isNotEmpty) {
      for (int i = 0; i < variants.length; i++) {
        data["variants[$i][name]"] = variants[i]['name'];
        data["variants[$i][price]"] = variants[i]['price'];
        data["variants[$i][quantity]"] = variants[i]['quantity'];
      }
    }

    if (imagefile != null) {
      response =
          await crud.addRequestWithImageOne(AppLink.addmeal, data, imagefile);
    } else {
      response = await crud.mypostData(AppLink.addmeal, data);
    }

    return response.fold((l) => l, (r) => r);
  }

  editMeal(
    String mealId,
    String storeid,
    String name,
    String description,
    String? quantity,
    List<int> additionals,
    String? price,
    File? imagefile, {
    List<Map<String, dynamic>>? variants, // <-- جديد
  }) async {
    var response;
    Map<dynamic, dynamic> data = {
      "store_id": storeid,
      "name": name,
      "description": description,
      //"price": price
    };

    if (price != null) data['price'] = price;
    if (quantity != null && quantity.isNotEmpty) data['quantity'] = quantity;

    // ✳️ نضيف كل إضافة بشكل منفصل كـ additionals[0], additionals[1], ...
    for (int i = 0; i < additionals.length; i++) {
      data["additionals[$i]"] = additionals[i].toString();
    }

    if (variants != null && variants.isNotEmpty) {
      for (int i = 0; i < variants.length; i++) {
        data["variants[$i][name]"] = variants[i]['name'];
        data["variants[$i][price]"] = variants[i]['price'];
        data["variants[$i][quantity]"] = variants[i]['quantity'];
      }
    }

    if (imagefile != null) {
      response = await crud.addRequestWithImageOne(
          '${AppLink.editmeal}/$mealId', data, imagefile);
    } else {
      response = await crud.mypostData('${AppLink.editmeal}/$mealId', data);
    }

    return response.fold((l) => l, (r) => r);
  }

  getHiddenMeals(int storeId) async {
    var response =
        await crud.getData(AppLink.gethidden + '/' + storeId.toString());
    return response.fold((l) => l, (r) => r);
  }

  getTrashedMeals(int storeId) async {
    var response =
        await crud.getData(AppLink.trashedMeals + '/' + storeId.toString());
    return response.fold((l) => l, (r) => r);
  }

  hideMeal(String mealId) async {
    var response = await crud.getData('${AppLink.hideMeal}/$mealId');
    return response.fold((l) => l, (r) => r);
  }

  restoreHiddenMeal(String mealId) async {
    var response = await crud.getData('${AppLink.restoreHiddenMeal}/$mealId');
    return response.fold((l) => l, (r) => r);
  }

  softDeleteMeal(String mealId) async {
    var response = await crud.deleteData('${AppLink.softDeleteMeal}/$mealId');
    return response.fold((l) => l, (r) => r);
  }

  getTrashedCounts(int storeId) async {
    var response =
        await crud.getData(AppLink.countTrashed + '/' + storeId.toString());
    return response.fold((l) => l, (r) => r);
  }

  sendAppeal(int mealId, String reason) async {
    var response =
        await crud.postData(AppLink.sendMealAppeal + '/' + mealId.toString(), {
      "appeal_message": reason,
    });
    return response.fold((l) => l, (r) => r);
  }

  // restoreTrashedMeal(String mealId) async {
  //   var response =
  //       await crud.mypostData(AppLink.restoreTrashedMeal + '/$mealId', {});
  //   return response.fold((l) => l, (r) => r);
  // }

  // deleteMeal(String mealId) async {
  //   var response = await crud.deleteData(AppLink.deletemeal + '/' + mealId);
  //   return response.fold((l) => l, (r) => r);
  // }

  getAdditionals(int storeid) async {
    var response = await crud
        .getData(AppLink.getStoreAdditional + '/' + storeid.toString());
    return response.fold((l) => l, (r) => r);
  }

  addAdditional(
      String storeid, String name, String price, String? qauntity) async {
    Map<dynamic, dynamic> data = {
      "store_id": storeid,
      "name": name,
      "price": price,
    };

    if (qauntity != null) {
      data["qauntity"] = qauntity;
    }

    var response = await crud.mypostData(AppLink.addAdditional, data);

    return response.fold((l) => l, (r) => r);
  }

  editAdditional(String additionalId, String storeid, String name, String price,
      String? qauntity) async {
    Map<dynamic, dynamic> data = {
      "store_id": storeid,
      "name": name,
      "price": price
    };

    if (qauntity != null) {
      data["qauntity"] = qauntity;
    }

    var response =
        await crud.mypostData('${AppLink.editadditional}/$additionalId', data);

    return response.fold((l) => l, (r) => r);
  }

  deleteAdditional(String additionalId) async {
    var response =
        await crud.deleteData('${AppLink.deleteadditional}/$additionalId');
    return response.fold((l) => l, (r) => r);
  }
}
