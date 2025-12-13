import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_go/bindings/intialbindings.dart';
import 'package:go_go/core/localization/changelocal.dart';
import 'package:go_go/core/localization/translation.dart';
import 'package:go_go/core/services/services.dart';
import 'package:go_go/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  //await Firebase.initializeApp();
  await initialServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocaleController controller = Get.put(LocaleController());
    return GetMaterialApp(
      translations: MyTranslation(),
      debugShowCheckedModeBanner: false,
      title: 'Go Go',
      locale: controller.language,
      theme: controller.appTheme,
      initialBinding: InitialBindings(),
      // routes: routes,
      getPages: routes,
    );
  }
}
