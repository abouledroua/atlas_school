import 'dart:math';
import 'package:atlas_school/controller/welcome_controller.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WelcomeController());
    return MyWidget(
        child: Padding(
            padding: EdgeInsets.all(
                min(AppSizes.heightScreen, AppSizes.widthScreen) / 6),
            child: Center(
                child: Image.asset(AppImageAsset.logo, fit: BoxFit.cover))));
  }
}
