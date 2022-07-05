// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enseignant.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchEnseignantListMessageController extends GetxController {
  String query = "";
  List<int> indName = [];
  bool loading = true, error = false;
  List<Enseignant> allEnseignants = [];

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  List<Enseignant> filtrerCours() {
    indName = [];
    List<Enseignant> list = [];
    for (var item in allEnseignants) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  updateQuery(String pQuery) {
    query = pQuery;
    update();
  }

  getAllEnseignants() async {
    updateBooleans(newloading: true, newerror: false);
    allEnseignants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENSEIGNANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Enseignant p;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              p = Enseignant(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_ENSEIGNANT']),
                  idUser: int.parse(m['ID_USER']),
                  etat: int.parse(m['ETAT']),
                  userName: m['USERNAME'],
                  password: m['PASSWORD'],
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  matiere: m['MATIERE'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  tel1: m['TEL1']);
              allEnseignants.add(p);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            allEnseignants.clear();
            AppData.mySnackBar(
                title: 'Liste des Messages',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          allEnseignants.clear();
          AppData.mySnackBar(
              title: 'Liste des Messages',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getAllEnseignants();
    super.onInit();
  }
}
