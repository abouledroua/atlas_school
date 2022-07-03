import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutParentFicheRelationController extends GetxController {
  String query = "";
  List<int> indName = [];

  updateQuery(String newvalue) {
    query = newvalue;
    update();
  }

  List<Parent> filtrerCours() {
    indName = [];
    List<Parent> list = [];
    FicheRelationController controller = Get.find();
    for (var item in controller.allparents) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase()) &&
          !existParent(item.id)) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existParent(int id) {
    FicheRelationController controller = Get.find();
    for (var i = 0; i < controller.parents.length; i++) {
      if (controller.parents[i].id == id) {
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
