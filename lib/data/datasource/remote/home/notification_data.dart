import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class NotificationData {
  Crud crud;
  NotificationData(this.crud);
  getdata() async {
    var response = await crud.getData(AppLink.notifications);
    return response.fold((l) => l, (r) => r);
  }

  markAsRead(String notificationId) async {
    var response = await crud.getData('${AppLink.markAsRead}/$notificationId');
    return response.fold((l) => l, (r) => r);
  }

  markAllAsRead() async {
    var response = await crud.getData(AppLink.markAllAsRead);
    return response.fold((l) => l, (r) => r);
  }
}
