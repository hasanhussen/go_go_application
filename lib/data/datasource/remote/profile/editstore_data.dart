import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class EditstoreData {
  Crud crud;
  EditstoreData(this.crud);
  // editData(String id, String name, String address, String phone, String special,
  //     String type, String cityId, String delivery) async {
  //   var response = await crud.postData(AppLink.editstore + '/' + id, {
  //     "name": name,
  //     "address": address,
  //     "category_id": type,
  //     "city_id": cityId,
  //     "delivery": delivery,
  //   });
  //   return response.fold((l) => l, (r) => r);
  // }

  editData(
    String id,
    String name,
    String address,
    File? imagefile,
    File? coverfile,
    String phone,
    String? special,
    String type,
    String cityId,
    String delivery,
    RxSet<String> selectedDays,
    RxMap<String, Map<String, TimeOfDay>> workingHours,
    // RxBool openAlways,
  ) async {
    // تحويل أوقات الدوام لقائمة جاهزة للإرسال
    List<Map<String, dynamic>> workingHoursList = selectedDays.map((day) {
      final times = workingHours[day];
      return {
        "day": day.toLowerCase(),
        "open_at": times?['from'] != null
            ? "${times?['from']!.hour.toString().padLeft(2, '0')}:${times?['from']!.minute.toString().padLeft(2, '0')}"
            : null,
        "close_at": times?['to'] != null
            ? "${times?['to']!.hour.toString().padLeft(2, '0')}:${times?['to']!.minute.toString().padLeft(2, '0')}"
            : null,
        // "is_open": true,
        // "is_24": openAlways.value,
      };
    }).toList();

    var response;
    Map<dynamic, dynamic> data = {
      "name": name,
      "address": address,
      "category_id": type,
      "city_id": cityId,
      "delivery": delivery,
      "phone": phone,
      // "working_hours": jsonEncode(workingHoursList),
    };

    if (workingHoursList.isNotEmpty) {
      for (int i = 0; i < workingHoursList.length; i++) {
        data["working_hours[$i][day]"] = workingHoursList[i]['day'];
        data["working_hours[$i][open_at]"] = workingHoursList[i]['open_at'];
        data["working_hours[$i][close_at]"] = workingHoursList[i]['close_at'];
        // data["working_hours[$i][is_open]"] =
        //     workingHoursList[i]['is_open'].toString();
        // data["working_hours[$i][is_24]"] =
        //     workingHoursList[i]['is_24'] ? '1' : '0';
      }
    }

    if (special != null) data['special'] = special;
    if (imagefile != null || coverfile != null) {
      response = await crud.addRequestWithImageOne(
          AppLink.editstore + '/' + id, data, imagefile, coverfile);
    }
    response = await crud.postData(AppLink.editstore + '/' + id, data);

    return response.fold((l) => l, (r) => r);

    // var response = await crud.addRequestWithImageOne(
    //     AppLink.editstore,
    //     {
    //       "name": name,
    //       "address": address,
    //       "category_id": type,
    //       "city_id": cityId,
    //       "delivery": delivery,
    //     },
    //     image);
    // return response.fold((l) => l, (r) => r);
  }
}
