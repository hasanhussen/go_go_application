import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class CouponData {
  Crud crud;
  CouponData(this.crud);

  checkCoupon(String couponname) async {
    var response =
        await crud.postData(AppLink.checkcoupon, {"name": couponname});
    return response.fold((l) => l, (r) => r);
  }
}
