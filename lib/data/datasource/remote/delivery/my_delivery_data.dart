import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class MyDeliveryData {
  Crud crud;
  MyDeliveryData(this.crud);

  getDeliveryOrders() async {
    var response = await crud.getData(AppLink.deliveryOrders);
    return response.fold((l) => l, (r) => r);
  }

  // getProcessing() async {
  //   var response = await crud.getData(AppLink.pendingDeliveryorders);
  //   return response.fold((l) => l, (r) => r);
  // }

  // getCompleted() async {
  //   var response = await crud.getData(AppLink.ordersDeliveryarchive);
  //   return response.fold((l) => l, (r) => r);
  // }

  // getwaiting() async {
  //   var response = await crud.getData(AppLink.ordersDeliverywaiting);
  //   return response.fold((l) => l, (r) => r);
  // }

  getDetails(String orderid) async {
    var response = await crud.getData('${AppLink.ordersdetails}/$orderid');
    return response.fold((l) => l, (r) => r);
  }

  changeOrderStatus(String orderid, String status) async {
    if (status == "5") {
      var response = await crud.getData('${AppLink.deliveryAccept}/$orderid');
      return response.fold((l) => l, (r) => r);
    } else if (status == "1") {
      var response = await crud.getData('${AppLink.deliveryOnTheWay}/$orderid');
      return response.fold((l) => l, (r) => r);
    } else if (status == "2") {
      var response = await crud.getData('${AppLink.deliveryOnSite}/$orderid');
      return response.fold((l) => l, (r) => r);
    } else {
      var response = await crud.getData('${AppLink.delivered}/$orderid');
      return response.fold((l) => l, (r) => r);
    }
  }
}
