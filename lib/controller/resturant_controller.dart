import 'package:get/get.dart';
import 'package:go_go/data/datasource/remote/store/store_data.dart';
import 'package:go_go/data/model/my_store_model.dart';

import '../core/class/statusrequest.dart';
import '../core/services/services.dart';

class RestaurantController extends GetxController {
  List<MyStoreModel> restaurants = [];
  String? catid;
  StoreData storeData = StoreData(Get.find());
  late StatusRequest statusRequest;

  MyServices myServices = Get.find();

  String token = "";

  goToProfileDetails(int id) {
    Get.toNamed("resturantprofile", arguments: {
      "id": id,
    });
  }
}
