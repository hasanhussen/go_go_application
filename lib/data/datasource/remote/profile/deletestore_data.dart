import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class DeletestoreData {
  Crud crud;
  DeletestoreData(this.crud);
  deletestore(String id) async {
    var response = await crud.deleteData(AppLink.deletestore + '/' + id);
    return response.fold((l) => l, (r) => r);
  }
}
