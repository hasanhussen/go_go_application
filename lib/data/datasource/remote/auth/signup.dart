import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class SignupData {
  Crud crud;
  SignupData(this.crud);
  postdata(String username, String password, String email, String phone,
      String role, String status, String gender, String? fcmToken) async {
    var response = await crud.postDatawithoutToken(AppLink.signUp, {
      "name": username,
      "email": email,
      "phone": phone,
      "role": role,
      "status": status,
      "password": password,
      "password_confirmation": password,
      "gender": gender,
      'fcm_token': fcmToken,
    });
    return response.fold((l) => l, (r) => r);
  }
}
