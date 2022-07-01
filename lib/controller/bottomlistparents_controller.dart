// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottomListParentsController extends GetxController {
  int index = 0;
  late Parent parent;
  bool loadingEnf = false, errorEnf = false;
  List<Enfant> enfants = [];

  BottomListParentsController({required int indice}) {
    index = indice;
    ListParentsController controller = Get.find();
    parent = controller.parents[index];
  }

  updateloadingEnf({required newloading, required newerror}) {
    loadingEnf = newloading;
    errorEnf = newerror;
    update();
  }

  getListEnfant() async {
    updateloadingEnf(newloading: true, newerror: false);
    enfants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANT_PARENT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": parent.id.toString(), "WHERE": ""})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Enfant e;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              e = Enfant(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_ENFANT']),
                  sexe: sexe,
                  etat: int.parse(m['ETAT']),
                  adresse: m['ADRESSE'],
                  photo: m['PHOTO'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2));
              enfants.add(e);
            }
            updateloadingEnf(newloading: false, newerror: false);
          } else {
            enfants.clear();
            updateloadingEnf(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des Enfants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          enfants.clear();
          updateloadingEnf(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des Enfants',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getListEnfant();
    super.onInit();
  }
}
