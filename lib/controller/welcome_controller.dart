import 'dart:async';
import 'package:atlas_school/core/constant/routes.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  @override
  void onReady() {
    Timer(const Duration(seconds: 3), close);
    super.onReady();
  }

  close() {
    Get.offAllNamed(AppRoute.login);
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    super.onInit();
  }
}
