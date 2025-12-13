import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/constant/approute.dart';
import 'package:go_go/core/functions/handingdatacontroller.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/data/datasource/remote/home/notification_data.dart';
import 'package:go_go/data/model/notification_model.dart';

class NotificationController extends GetxController {
  // List<Map<String, dynamic>> notifications = [
  //   {
  //     "title": "تم قبول طلبك",
  //     "message": "طلبك رقم #124 تم قبوله من قبل الإدارة.",
  //     "date": "اليوم - 10:30 ص",
  //     "color": 0xFFFFF3E0, // لون مميز
  //     "icon": "✅",
  //   },
  //   {
  //     "title": "تم تحديث حالة الطلب",
  //     "message": "طلبك الآن في مرحلة التحضير.",
  //     "date": "أمس - 05:00 م",
  //     "color": 0xFFE3F2FD,
  //     "icon": "🚚",
  //   },
  //   {
  //     "title": "إعلان جديد من الإدارة",
  //     "message": "عرض خاص هذا الأسبوع! خصم 20٪ على الطلبات الجديدة.",
  //     "date": "25 أكتوبر 2025 - 09:15 ص",
  //     "color": 0xFFFCE4EC,
  //     "icon": "📢",
  //   },
  // ];

  StatusRequest statusRequest = StatusRequest.none;
  NotificationData notificationData = NotificationData(Get.find());

  MyServices myServices = Get.find();

  List<NotificationModel> notifications = [];

  String token = "";

  @override
  void onInit() {
    getNotification();
    super.onInit();
  }

  gettoken() {
    token = myServices.sharedPreferences.getString("token") ?? "";
    update();
  }

  getNotification() async {
    notifications.clear();
    statusRequest = StatusRequest.loading;
    update();
    var response = await notificationData.getdata();
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
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
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      notifications
          .addAll((response as List).map((e) => NotificationModel.fromJson(e)));
      HomeScreenControllerImp homeScreenControllerImp = Get.find();
      homeScreenControllerImp.notOppendNotification = 0;

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  goToNotificationDetails(
      String type, String notificationId, int? storeId) async {
    var response = await notificationData.markAsRead(notificationId);
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
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
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      await getNotification();
      if (type == 'App\\Notifications\\StoreNotification') {
        Get.toNamed(AppRoute.myStoresScreen);
      } else if (type == 'App\\Notifications\\OrderNotification') {
        Get.offAllNamed(AppRoute.homescreen, arguments: {"page": 3});
      } else if (type == 'App\\Notifications\\MealNotification') {
        Get.toNamed("resturantprofile",
            arguments: {"id": storeId, "isOwner": true});
      } else if (type == 'App\\Notifications\\AdminNotification') {
        // صفحة تظهر تفاصيل الإشعار
        showAdminNotificationDialog(notificationId);
      }
      // 🔥 أي نوع إشعار غير معروف يدخل هون
      else {
        showAdminNotificationDialog(notificationId);
      }
      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  void showAdminNotificationDialog(String notificationId) {
    final notification =
        notifications.firstWhere((n) => n.id == notificationId);

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.notifications_active,
                  size: 45, color: Colors.redAccent),
              const SizedBox(height: 10),
              Text(
                notification.data?.title ?? "إشعار",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                notification.data?.body ?? "",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              // const SizedBox(height: 15),
              // Text(
              //   notification.createdAt ?? "",
              //   style: const TextStyle(fontSize: 12, color: Colors.grey),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "إغلاق",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  markAllAsRead() async {
    var response = await notificationData.markAllAsRead();
    print("=============================== Controller $response ");
    statusRequest = handlingData(response);
    if (StatusRequest.success == statusRequest) {
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
          buttonColor: Colors.red,
          textCancel: "إغلاق",
          cancelTextColor: Colors.black,
          onCancel: () {},
        );
        update();
        return;
      }
      await getNotification();

      // End
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }
}
