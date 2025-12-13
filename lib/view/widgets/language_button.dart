import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/localization/changelocal.dart';

class LanguageButton extends GetView<LocaleController> {
  final String text;
  final String language;
  LanguageButton({required this.text, required this.language});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.changeLang(language),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
