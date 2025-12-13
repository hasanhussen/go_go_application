import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class BannerData {
  Crud crud;
  BannerData(this.crud);
  getdata() async {
    var response = await crud.getData(AppLink.slider);
    return response.fold((l) => l, (r) => r);
  }
}
