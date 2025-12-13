import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class VerifyCodeForgetPasswordData {
  Crud crud;
  VerifyCodeForgetPasswordData(this.crud);
  postdata(String email, String verifycode) async {
    var response = await crud.postDatawithoutToken(
        AppLink.verifycodeforgetpassword, {"email": email, "code": verifycode});
    return response.fold((l) => l, (r) => r);
  }
}
