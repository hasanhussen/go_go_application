import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_go/bindings/intialbindings.dart';
import 'package:go_go/core/localization/changelocal.dart';
import 'package:go_go/core/localization/translation.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/routes.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await GetStorage.init();
    await initialServices();
    runApp(MyApp());
  } catch (e) {
    print("Critical Initialization Error: $e");
    runApp(MaterialApp(
        home: Scaffold(body: Center(child: Text("Error launching app")))));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر المسؤول عن اللغة والثيم
    LocaleController controller = Get.put(LocaleController());

    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Go Go',
      locale: controller.language,
      theme: controller.appTheme,
      initialBinding: InitialBindings(),
      getPages: routes, // تأكد أن routes تحتوي على صفحة البداية بشكل صحيح
    );
  }
}
