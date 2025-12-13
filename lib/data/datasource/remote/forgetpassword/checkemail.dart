import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class CheckEmailData {
  Crud crud;
  CheckEmailData(this.crud);
  postdata(String email) async {
    var response =
        await crud.postDatawithoutToken(AppLink.checkEmail, {"email": email});
    return response.fold((l) => l, (r) => r);
  }
}
