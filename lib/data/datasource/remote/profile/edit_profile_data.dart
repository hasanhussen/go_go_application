import 'dart:io';

import 'package:go_go/core/class/crud.dart';
import 'package:go_go/linkapi.dart';
import 'package:path/path.dart' as path;

class EditProfileData {
  Crud crud;
  EditProfileData(this.crud);
  editData(String newName, String newPhone, String newEmail, String gender,
      String token) async {
    var response = await crud.postData(AppLink.editProfile, {
      "name": newName,
      "phone": newPhone,
      "token": token,
      "email": newEmail,
      "gender": gender
    });
    return response.fold((l) => l, (r) => r);
  }

  editDatawithfile(String newName, String newPhone, String newEmail,
      String gender, String token, File? image) async {
    List<int> imageBytes = await image!.readAsBytes();
    // String base64Image = base64Encode(imageBytes);
    String imageName = path.basename(image.path);
    print("imageName = $imageName");
    // print("base64Image = $base64Image");
    var response = await crud.addRequestWithImageOne(
        AppLink.editProfile,
        {
          "name": newName,
          "phone": newPhone,
          "token": token,
          "email": newEmail,
          "gender": gender,
          'imgname': imageName,
          // 'image': base64Image
        },
        image);
    return response.fold((l) => l, (r) => r);
  }
}
