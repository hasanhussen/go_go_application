import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_go/core/localization/changelocal.dart';
import 'package:go_go/view/widgets/custombuttomlang.dart';

class LanguageEdit extends GetView<LocaleController> {
  const LanguageEdit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("1".tr, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              CustomButtonLang(
                  textbutton: "Ar",
                  onPressed: () {
                    controller.changeLang("ar");
                    Get.back();
                  }),
              CustomButtonLang(
                  textbutton: "En",
                  onPressed: () {
                    controller.changeLang("en");
                    Get.back();
                  }),
            ],
          )),
    );
  }
}
