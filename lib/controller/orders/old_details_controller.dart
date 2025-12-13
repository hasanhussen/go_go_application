import 'package:go_go/core/class/statusrequest.dart';

import 'package:get/get.dart';

class OldOrdersDetailsController extends GetxController {
  //OrdersDetailsData ordersDetailsData = OrdersDetailsData(Get.find());

  //List<CartModel> data = [];

  StatusRequest statusRequest = StatusRequest.none;

  //late OrdersModel ordersModel;

  // double? lat;
  // double? long;

  // @override
  // void onInit() {
  //   ordersModel = Get.arguments['ordersmodel'];
  //   getData();
  //   super.onInit();
  // }

  // getData() async {
  //   statusRequest = StatusRequest.loading;

  //   var response = await ordersDetailsData.getData(ordersModel.ordersId!);

  //   print("=============================== Controller $response ");

  //   statusRequest = handlingData(response);

  //   if (StatusRequest.success == statusRequest) {
  //     // Start backend
  //     if (response['status'] == "success") {
  //       List listdata = response['data'];
  //       data.addAll(listdata.map((e) => CartModel.fromJson(e)));
  //     } else {
  //       statusRequest = StatusRequest.failure;
  //     }
  //     // End
  //   }
  //   update();
  // }
}
