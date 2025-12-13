import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:go_go/core/class/statusrequest.dart';
import 'package:go_go/core/functions/checkinternet.dart';
import 'package:go_go/core/services/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Crud {
  Future<void> uploadImageWithName(File imageFile) async {
    try {
      // 1. تحويل الصورة إلى base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // 2. استخراج اسم الصورة وامتدادها
      String imageName = path.basename(imageFile.path);
      String extension = path.extension(imageFile.path).replaceFirst('.', '');

      // 3. إنشاء body للإرسال
      Map<String, dynamic> requestBody = {
        "image_name": imageName,
        "image_data": base64Image,
        "extension": extension,
      };

      // 4. إرسال الطلب إلى الـ API
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/upload'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      // 5. معالجة الرد
      if (response.statusCode == 200) {
        print('تم رفع الصورة بنجاح');
        print('الرد: ${response.body}');
      } else {
        print('فشل في رفع الصورة: ${response.statusCode}');
        print('الخطأ: ${response.body}');
      }
    } catch (e) {
      print('حدث خطأ أثناء رفع الصورة: $e');
    }
  }

  Future<Either<StatusRequest, dynamic>> addRequestWithImageOne(
      url, data, File? image,
      [File? cover]) async {
    MyServices myServices = Get.find();
    final String token = myServices.sharedPreferences.getString("token") ?? "";

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);

    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead().cast());
      var multipartFile = http.MultipartFile("image", stream, length,
          filename: path.basename(image.path));
      request.files.add(multipartFile);
    }

    if (cover != null) {
      var length = await cover.length();
      var stream = http.ByteStream(cover.openRead().cast());
      var multipartFile = http.MultipartFile("cover", stream, length,
          filename: path.basename(cover.path));
      request.files.add(multipartFile);
    }

    // تحويل كل القيم إلى نصوص
    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);

    print("Response code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responsebody = jsonDecode(response.body);
      print(responsebody);

      return Right(responsebody);
    } else if (response.statusCode == 429) {
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      return Right(
          {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      var responsebody = jsonDecode(response.body);
      if (responsebody is Map && responsebody.containsKey('error')) {
        return Right(responsebody);
      }
      return const Left(StatusRequest.serverException);
    } else {
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postData(
      String linkurl, Map data) async {
    if (await checkInternet()) {
      MyServices myServices = Get.find();
      final String token =
          myServices.sharedPreferences.getString("token") ?? "";
      print("Sending to: $linkurl");
      print("Token: $token");
      print("Data: $data");
      var response = await http.post(
        Uri.parse(linkurl),
        body: data,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          // 'Content-Type': 'application/json',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> mypostData(
      String linkurl, Map data) async {
    if (await checkInternet()) {
      MyServices myServices = Get.find();
      final String token =
          myServices.sharedPreferences.getString("token") ?? "";
      print("Sending to: $linkurl");
      print("Token: $token");
      print("Data: $data");
      var response = await http.post(
        Uri.parse(linkurl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else if (response.statusCode == 400) {
        return const Left(StatusRequest.serverException);
      } else {
        print("Response code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postDatawitherror(
      String linkurl, Map data) async {
    if (await checkInternet()) {
      MyServices myServices = Get.find();
      final String token =
          myServices.sharedPreferences.getString("token") ?? "";
      print("Sending to: $linkurl");
      print("Token: $token");
      print("Data: $data");
      var response = await http.post(
        Uri.parse(linkurl),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        var responsebody = jsonDecode(response.body);
        if (responsebody is Map && responsebody.containsKey('error')) {
          return Right(responsebody);
        }
        return const Left(StatusRequest.serverException);
      } else {
        print("Response code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> myaddRequestWithImageOne(
      url, data, File? image,
      [String? namerequest]) async {
    if (namerequest == null) {
      namerequest = "image";
    }

    MyServices myServices = Get.find();
    final String token = myServices.sharedPreferences.getString("token") ?? "";

    var uri = Uri.parse(url);
    var request = http.MultipartRequest("POST", uri);
    //request.headers.addAll(myheaders);

    if (image != null) {
      var length = await image.length();
      var stream = http.ByteStream(image.openRead());
      stream.cast();
      var multipartFile = http.MultipartFile(namerequest, stream, length,
          filename: path.basename(image.path));
      request.files.add(multipartFile);
    }

    // add Data to request
    request.fields['data'] = jsonEncode(data);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
    // add Data to request
    // Send Request
    var myrequest = await request.send();
    // For get Response Body
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      Map responsebody = jsonDecode(response.body);
      return Right(responsebody);
    } else if (response.statusCode == 429) {
      var responsebody = jsonDecode(response.body);
      print(responsebody);
      return Right(
          {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
    } else {
      return const Left(StatusRequest.serverfailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> postDatawithoutToken(
      String linkurl, Map data) async {
    if (await checkInternet()) {
      var response = await http.post(
        Uri.parse(linkurl),
        body: data,
        headers: {
          // 'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        var responsebody = jsonDecode(response.body);
        if (responsebody is Map && responsebody.containsKey('error')) {
          return Right(responsebody);
        }
        return const Left(StatusRequest.serverException);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> getData(String linkurl) async {
    if (await checkInternet()) {
      MyServices myServices = Get.find();
      final String token =
          myServices.sharedPreferences.getString("token") ?? "";
      print("Sending to: $linkurl");
      print("Token: $token");
      var response = await http.get(
        Uri.parse(linkurl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        var responsebody = jsonDecode(response.body);
        if (responsebody is Map && responsebody.containsKey('error')) {
          return Right(responsebody);
        }
        return const Left(StatusRequest.serverException);
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }

  Future<Either<StatusRequest, dynamic>> deleteData(String linkurl) async {
    if (await checkInternet()) {
      MyServices myServices = Get.find();
      final String token =
          myServices.sharedPreferences.getString("token") ?? "";
      var response = await http.delete(
        Uri.parse(linkurl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);

        return Right(responsebody);
      } else if (response.statusCode == 429) {
        var responsebody = jsonDecode(response.body);
        print(responsebody);
        return Right(
            {'error': 'حدث خطأ بسبب المحاولات الكثيرة يرجى المحاولة لاحقاً'});
      } else {
        return const Left(StatusRequest.serverfailure);
      }
    } else {
      return const Left(StatusRequest.offlinefailure);
    }
  }
}
