import 'dart:async';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyController extends GetxController {
  bool accept = false;

  updateAccepte() {
    accept = !accept;
    update();
  }

  Future<bool> onWillPop() async {
    return false;
  }

  continuer() {
    SettingServices c = Get.find();
    c.sharedPrefs.setString("Privacy${User.idUser}", "1");
    Get.back();
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    super.onInit();
  }
}
