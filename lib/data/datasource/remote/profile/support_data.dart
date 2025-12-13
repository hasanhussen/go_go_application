import 'dart:io';

import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';

class SupportData {
  Crud crud;
  SupportData(this.crud);
  postdata(
    String role,
    String subject,
    String message,
    File? imagefile,
  ) async {
    var response;
    Map<dynamic, dynamic> data = {
      "role": role,
      "subject": subject,
      "message": message,
    };

    if (imagefile != null) {
      response =
          await crud.addRequestWithImageOne(AppLink.support, data, imagefile);
    } else {
      response = await crud.postData(AppLink.support, data);
    }

    return response.fold((l) => l, (r) => r);
  }
}
