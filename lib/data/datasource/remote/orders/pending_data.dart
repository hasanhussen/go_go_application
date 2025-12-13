import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class OrdersPendingData {
  Crud crud;
  OrdersPendingData(this.crud);

  // getOrders() async {
  //   var response = await crud.getData(AppLink.orders);
  //   return response.fold((l) => l, (r) => r);
  // }

  getProcessing() async {
    var response = await crud.getData(AppLink.pendingorders);
    return response.fold((l) => l, (r) => r);
  }

  getCompleted() async {
    var response = await crud.getData(AppLink.ordersarchive);
    return response.fold((l) => l, (r) => r);
  }

  getwaiting() async {
    var response = await crud.getData(AppLink.orderswaiting);
    return response.fold((l) => l, (r) => r);
  }

  getRejected() async {
    var response = await crud.getData(AppLink.ordersRejected);
    return response.fold((l) => l, (r) => r);
  }

  getDetails(String orderid) async {
    var response = await crud.getData(AppLink.ordersdetails + '/' + orderid);
    return response.fold((l) => l, (r) => r);
  }

  deleteData(String orderid) async {
    var response = await crud.deleteData(AppLink.ordersdelete + '/' + orderid);
    return response.fold((l) => l, (r) => r);
  }
}
