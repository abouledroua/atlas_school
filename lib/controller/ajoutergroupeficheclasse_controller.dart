import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutGroupeFicheClasseController extends GetxController {
  String query = "";
  List<int> indName = [];

  updateQuery(String newvalue) {
    query = newvalue;
    update();
  }

  List<Groupe> filtrerCours() {
    indName = [];
    List<Groupe> list = [];
    FicheClasseController controller = Get.find();
    for (var item in controller.allgroupes) {
      if (item.designation.toUpperCase().contains(query.toUpperCase()) &&
          !existGroupe(item.id)) {
        list.add(item);
        indName
            .add(item.designation.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existGroupe(int id) {
    FicheClasseController controller = Get.find();
    for (var i = 0; i < controller.groupes.length; i++) {
      if (controller.groupes[i].id == id) {
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
