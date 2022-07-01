// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottomListEnfantsController extends GetxController {
  int index = 0;
  late Enfant enfant;
  bool loadingPar = false, errorPar = false, loadingGr = false, errorGr = false;
  List<Parent> parents = [];
  List<Groupe> groupes = [];

  BottomListEnfantsController({required int indice}) {
    index = indice;
    ListEnfantsController controller = Get.find();
    enfant = controller.enfants[index];
  }

  updateLoadingPar({required newloading, required newerror}) {
    loadingPar = newloading;
    errorPar = newerror;
    update();
  }

  updateLoadingGr({required newloading, required newerror}) {
    loadingGr = newloading;
    errorGr = newerror;
    update();
  }

  getListParent() async {
    updateLoadingPar(newloading: true, newerror: false);
    parents.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_PARENT_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfant.id.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Parent e;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              e = Parent(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_PARENT']),
                  idUser: int.parse(m['ID_USER']),
                  etat: int.parse(m['ETAT']),
                  userName: m['USERNAME'],
                  password: m['PASSWORD'],
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  tel2: m['TEL2'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  tel1: m['TEL1']);
              parents.add(e);
            }
            updateLoadingPar(newloading: false, newerror: false);
          } else {
            parents.clear();
            updateLoadingPar(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des Enfants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          parents.clear();
          updateLoadingPar(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des Enfants',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getListGroupe() async {
    updateLoadingGr(newloading: true, newerror: false);
    parents.clear();
    groupes.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GROUPE_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfant.id.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Groupe e;
            for (var m in responsebody) {
              e = Groupe(
                  designation: m['DESIGNATION'],
                  id: int.parse(m['ID_GROUPE']),
                  etat: int.parse(m['ETAT']));
              groupes.add(e);
            }
            updateLoadingGr(newloading: false, newerror: false);
          } else {
            groupes.clear();
            updateLoadingGr(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des Enfants',
                message: "Probleme de Connexion avec le serveur3 !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          groupes.clear();
          updateLoadingGr(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des Enfants',
              message: "Probleme de Connexion avec le serveur4 !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getListParent();
    getListGroupe();
    super.onInit();
  }
}
