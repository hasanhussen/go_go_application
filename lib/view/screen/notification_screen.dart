import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/controller/notification_controller.dart';
import 'package:go_go/core/class/handlingdataview.dart';
import 'package:jiffy/jiffy.dart';
import '../widgets/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: const Text(
              "الإشعارات",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: [
              TextButton(
                onPressed: () {
                  controller.markAllAsRead();
                },
                child: const Text(
                  "تحديد الكل كمقروء",
                  style: TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            ],
          ),
          body: controller.notifications.isEmpty
              ? Center(
                  child: Text(
                    'لا يوجد إشعارات',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : HandlingDataRequest(
                  statusRequest: controller.statusRequest,
                  widget: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notif = controller.notifications[index];

                      return NotificationItem(
                        title: notif.data!.title ?? '',
                        message: notif.data!.body ?? '',
                        date: Jiffy.parse(notif.createdAt!).fromNow(),
                        color: notif.readAt == null
                            ? const Color.fromARGB(255, 174, 174, 174)
                            : Colors.white,
                        icon: notif.data!.icon ?? '',
                        onTap: () {
                          controller.goToNotificationDetails(notif.type ?? '',
                              notif.id ?? '', notif.data!.storeId);
                        },
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
