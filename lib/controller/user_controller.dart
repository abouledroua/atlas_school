// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserController extends GetxController {
  List<Enfant> enfants = [];
  bool isAdmin = false, error = false, loading = false;

  updateBooleans({required bool newLoading, required bool newError}) {
    loading = newLoading;
    error = newError;
    update();
  }

  getListEnfant() async {
    updateBooleans(newLoading: true, newError: false);
    enfants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANT_PARENT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": User.idParent.toString()})
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
                  etat: int.parse(m['ETAT']),
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  photo: m['PHOTO'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2));
              enfants.add(e);
            }
            updateBooleans(newLoading: false, newError: false);
          } else {
            updateBooleans(newLoading: false, newError: true);
            enfants.clear();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newLoading: false, newError: true);
          enfants.clear();
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
