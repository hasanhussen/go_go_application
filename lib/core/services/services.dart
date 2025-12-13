import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:go_go/linkapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;
  String? publishableKey;
  String token = "";
  String status = "";

  Future<MyServices> init() async {
    await Firebase.initializeApp();
    sharedPreferences = await SharedPreferences.getInstance();
    await gettoken();
    if (token != "") {
      await getStatus();
    }
    await getStripe();
    return this;
  }

  gettoken() {
    token = sharedPreferences.getString("token") ?? "";
    sharedPreferences.remove('pendingOrderId');
  }

  getStatus() async {
    final response = await http.get(
      Uri.parse("${AppLink.server}/profile"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      status = body['status'];
      if (body['email_verified_at'] == null) {
        status = '4';
      }
      if (body['deleted_at'] != null) {
        status = '3';
      }
      sharedPreferences.setString("status", status);
    } else {
      throw Exception("فشل بجلب حالة المستخدم");
    }
  }

  getStripe() async {
    final response = await http.get(
      Uri.parse("${AppLink.server}/getPublishableKey"),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      Stripe.publishableKey = body['publishable_key'];
      publishableKey = Stripe.publishableKey;
      await Stripe.instance.applySettings();
    } else {
      throw Exception("فشل بجلب Stripe publishable key");
    }
  }
}

initialServices() async {
  await Get.putAsync(() => MyServices().init());
}
