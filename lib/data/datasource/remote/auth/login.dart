import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class LoginData {
  Crud crud;
  LoginData(this.crud);
  postdata(String email, String password, String? fcmToken) async {
    var response = await crud.postDatawithoutToken(AppLink.login, {
      "email": email,
      "password": password,
      'fcm_token': fcmToken,
    });
    return response.fold((l) => l, (r) => r);
  }
}
