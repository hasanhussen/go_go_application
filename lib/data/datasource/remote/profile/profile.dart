import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class ProfileData {
  Crud crud;
  ProfileData(this.crud);
  getdata() async {
    var response = await crud.getData(AppLink.profile);
    return response.fold((l) => l, (r) => r);
  }
}
