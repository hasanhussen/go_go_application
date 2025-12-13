//import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/homescreen_controller.dart';
import 'package:go_go/controller/my_delivery_controller.dart';
import 'package:go_go/controller/my_stores_controller.dart';
import 'package:go_go/controller/notification_controller.dart';
import 'package:go_go/controller/orders/checkout_controller.dart';
import 'package:go_go/controller/orders/pending_controller.dart';
import 'package:permission_handler/permission_handler.dart';

requestPermissionNotification() async {
  // ignore: unused_local_variable
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

Future<void> requestPermissions() async {
  // طلب إذن قراءة الوسائط (الصورة والفيديو)
  PermissionStatus statusImage = await Permission.photos.request();
  PermissionStatus statusVideo = await Permission.videos.request();
  PermissionStatus statusStorage = await Permission.storage.request();

  // التأكد من الأذونات
  if (statusImage.isGranted &&
      statusVideo.isGranted &&
      statusStorage.isGranted) {
    print("تم منح الأذونات بنجاح");
  } else {
    print("الأذونات مرفوضة");
  }
}

fcmconfig() {
  FlutterRingtonePlayer flutterRingtonePlayer = FlutterRingtonePlayer();
  print("hai =======================================================");
  FirebaseMessaging.onMessage.listen((message) {
    print("================== Notification =================");
    print(message.notification!.title);
    print(message.notification!.body);
    flutterRingtonePlayer.playNotification();
    Get.snackbar(message.notification!.title!, message.notification!.body!,
        backgroundColor: Color.fromARGB(255, 255, 255, 255));
    refreshPageNotification(message.data);
  });
}

refreshPageNotification(data) {
  print("============================= page id ");
  print(data['order_id']);
  print("============================= page name ");
  print(data['type']);
  print("================== Current Route");
  print(Get.currentRoute);

  HomeScreenControllerImp homeScreenControllerImp = Get.find();
  homeScreenControllerImp.notOppendNotification += 1;

  if (Get.currentRoute == "/homescreen") {
    homeScreenControllerImp.update();
    if (homeScreenControllerImp.currentpage == 1) {
      NotificationController controller = Get.find();
      controller.getNotification();
    }
  }

  if (Get.currentRoute == "/homescreen" && data['type'] == "order_accepted") {
    HomeScreenControllerImp homeScreenControllerImp = Get.find();
    if (homeScreenControllerImp.currentpage == 3) {
      OrdersPendingController controller = Get.find();
      controller.refrehOrder();
    }
  }

  if (Get.currentRoute == "/checkout" && data['type'] == "order_accepted") {
    CheckoutController controller = Get.find();
    controller.refrehOrder();
  }

  const allowedTypes = {
    "store_accepted",
    "store_rejected",
    "store_banned",
    "store_unbanned",
    "store_restored"
  };

  if (Get.currentRoute == "/myStoresScreen" &&
      allowedTypes.contains(data['type'])) {
    MyStoresController controller = Get.find();
    controller.getStores();
  }

  if (Get.currentRoute == "/myDeliverScreen" &&
      data['type'] == "order_assign") {
    MyDeliveryController controller = Get.find();
    controller.refreshOrders();
  }
}




// Firebase + stream 
// Socket io 
// Notification refresh 