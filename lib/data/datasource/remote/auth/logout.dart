import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class LogoutData {
  Crud crud;
  LogoutData(this.crud);
  postdata(String fcm_token) async {
    var response =
        await crud.postData(AppLink.logout, {'fcm_token': fcm_token});
    return response.fold((l) => l, (r) => r);
  }
}
