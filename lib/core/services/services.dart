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
    // 1. تهيئة Firebase و SharedPreferences (أشياء سريعة وضرورية)
    await Firebase.initializeApp();
    sharedPreferences = await SharedPreferences.getInstance();
    
    gettoken();

    // 2. استدعاء جلب البيانات من السيرفر "بدون await" 
    // لكي لا يظل التطبيق عالقاً على شاشة سوداء إذا تأخر السيرفر
    checkApiData(); 

    return this;
  }

  void gettoken() {
    token = sharedPreferences.getString("token") ?? "";
    // تنظيف أي بيانات مؤقتة قديمة
    sharedPreferences.remove('pendingOrderId');
  }

  // دالة تجمع طلبات الشبكة وتنفذها في الخلفية
  void checkApiData() async {
    try {
      if (token.isNotEmpty) {
        await getStatus();
      }
      await getStripe();
    } catch (e) {
      print("Background Data Fetch Error: $e");
    }
  }

  Future<void> getStatus() async {
    try {
      final response = await http.get(
        Uri.parse("${AppLink.server}/profile"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10)); // مهلة 10 ثوانٍ فقط

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        status = body['status'].toString();
        
        if (body['email_verified_at'] == null) status = '4';
        if (body['deleted_at'] != null) status = '3';
        
        await sharedPreferences.setString("status", status);
      } else {
        status = "error_auth";
      }
    } catch (e) {
      status = "offline";
    }
  }

  Future<void> getStripe() async {
    try {
      final response = await http.get(
        Uri.parse("${AppLink.server}/getPublishableKey"),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        Stripe.publishableKey = body['publishable_key'];
        publishableKey = Stripe.publishableKey;
        await Stripe.instance.applySettings();
      }
    } catch (e) {
      print("Stripe Error: $e");
    }
  }
}

// دالة التشغيل التي يتم استدعاؤها في الـ main
initialServices() async {
  await Get.putAsync(() => MyServices().init());
}