// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/core/class/enseignant.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomListEnseignantsController extends GetxController {
  int index = 0;
  late Enseignant enseignant;

  BottomListEnseignantsController({required int indice}) {
    index = indice;
    ListEnseignantsController controller = Get.find();
    enseignant = controller.enseignants[index];
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    super.onInit();
  }
}
