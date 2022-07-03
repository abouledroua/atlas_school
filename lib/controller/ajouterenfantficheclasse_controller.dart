import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutEnfantFicheClasseController extends GetxController {
  String query = "";
  List<int> indName = [];

  updateQuery(String newvalue) {
    query = newvalue;
    update();
  }

  List<Enfant> filtrerCours() {
    indName = [];
    List<Enfant> list = [];
    FicheClasseController controller = Get.find();
    for (var item in controller.allenfants) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase()) &&
          !existEnfant(item.id)) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existEnfant(int id) {
    FicheClasseController controller = Get.find();
    for (var i = 0; i < controller.enfants.length; i++) {
      if (controller.enfants[i].id == id) {
        return true;
      }
    }
    return false;
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    super.onInit();
  }
}
