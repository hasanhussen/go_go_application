import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class VerfiyCodeSignUpData {
  Crud crud;
  VerfiyCodeSignUpData(this.crud);
  postdata(String email, String verifycode) async {
    var response = await crud.postDatawithoutToken(
        AppLink.verifycodessignup, {"email": email, "verifycode": verifycode});
    return response.fold((l) => l, (r) => r);
  }

  resendData(String email) async {
    var response =
        await crud.postDatawithoutToken(AppLink.resend, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}
