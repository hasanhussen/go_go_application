import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class StoreData {
  Crud crud;
  StoreData(this.crud);

  getFollowedStores() async {
    var response = await crud.getData(AppLink.getFollowedStores);
    return response.fold((l) => l, (r) => r);
  }

  getdata(int id) async {
    var response =
        await crud.getData(AppLink.getCategorystores + '/' + id.toString());
    return response.fold((l) => l, (r) => r);
  }

  getplofilestore(int id) async {
    var response =
        await crud.getData(AppLink.profilestore + '/' + id.toString());
    return response.fold((l) => l, (r) => r);
  }

  checkfollow(int id) async {
    var response =
        await crud.getData(AppLink.checkfollowstore + '/' + id.toString());
    return response.fold((l) => l, (r) => r);
  }

  follow(int id) async {
    var response =
        await crud.getData(AppLink.followstore + '/' + id.toString());
    return response.fold((l) => l, (r) => r);
  }

  unfollow(int id) async {
    var response =
        await crud.getData(AppLink.unfollowstore + '/' + id.toString());
    return response.fold((l) => l, (r) => r);
  }

  rateStore(int id, double rate) async {
    var response = await crud.postData(
      AppLink.rateStore + '/' + id.toString(),
      {'rating': rate.toString()},
    );
    return response.fold((l) => l, (r) => r);
  }
}
