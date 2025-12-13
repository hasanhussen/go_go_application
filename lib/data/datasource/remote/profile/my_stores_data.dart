import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class MyStoresData {
  Crud crud;
  MyStoresData(this.crud);

  getmyStores() async {
    var response = await crud.getData(AppLink.myStores);
    return response.fold((l) => l, (r) => r);
  }

  // getActiveStores() async {
  //   var response = await crud.getData(AppLink.myActiveStores);
  //   return response.fold((l) => l, (r) => r);
  // }

  // getNewStores() async {
  //   var response = await crud.getData(AppLink.myNewStores);
  //   return response.fold((l) => l, (r) => r);
  // }

  // getDeletedStores() async {
  //   var response = await crud.getData(AppLink.myDeletedStores);
  //   return response.fold((l) => l, (r) => r);
  // }

  sendAppeal(int storeId, String reason) async {
    var response = await crud
        .postData(AppLink.sendStoreAppeal + '/' + storeId.toString(), {
      "appeal_message": reason,
    });
    return response.fold((l) => l, (r) => r);
  }
}
