import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class AboutUsData {
  Crud crud;
  AboutUsData(this.crud);
  getContactInfo() async {
    var response = await crud.getData(AppLink.contactInfo);
    return response.fold((l) => l, (r) => r);
  }
}
