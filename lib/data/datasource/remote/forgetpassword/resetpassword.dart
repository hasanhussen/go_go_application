import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class ResetPasswordData {
  Crud crud;
  ResetPasswordData(this.crud);
  postdata(String email, String password) async {
    var response = await crud.postDatawithoutToken(AppLink.resetPassword, {
      "email": email,
      "password": password,
      "password_confirmation": password,
    });
    return response.fold((l) => l, (r) => r);
  }
}
