import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/dataservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  int pageIndex = 0;

  Future initialService() async {
    await Get.putAsync(() => DataServices().init());
  }

  changePage(newIndex) {
    pageIndex = newIndex;
    update();
  }

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    await initialService();
    super.onInit();
  }
}
