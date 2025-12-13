import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class CategoryData {
  Crud crud;
  CategoryData(this.crud);
  getdata() async {
    var response = await crud.getData(AppLink.categories);
    return response.fold((l) => l, (r) => r);
  }
}
