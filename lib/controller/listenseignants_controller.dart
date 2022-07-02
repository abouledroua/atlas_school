// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enseignant.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListEnseignantsController extends GetxController {
  bool loading = false, error = false, searching = false;
  String query = "";
  List<Enseignant> enseignants = [];

  myActions() {
    return [
      PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(children: const [
                      Icon(Icons.search),
                      SizedBox(width: 10),
                      Text("Recherche")
                    ])),
                PopupMenuItem(
                    value: 2,
                    child: Row(children: const [
                      Icon(Icons.refresh),
                      SizedBox(width: 10),
                      Text("Actualiser")
                    ])),
              ],
          offset: const Offset(30, 30),
          elevation: 2,
          onSelected: (value) {
            switch (value) {
              case 1:
                if (searching) {
                  updateQuery("");
                }
                updateSearching();
                break;
              case 2:
                getEnseignants();
                break;
              default:
            }
          })
    ];
  }

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getEnseignants() async {
    updateBooleans(newloading: true, newerror: false);
    enseignants.clear();
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
              enseignants.add(p);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            enseignants.clear();
            AppData.mySnackBar(
                title: 'Liste des Enseignants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          enseignants.clear();
          AppData.mySnackBar(
              title: 'Liste des Enseignants',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  updateQuery(String newValue) {
    query = newValue;
    update();
  }

  updateSearching() {
    searching = !searching;
    update();
  }

  deleteEnseignant(int ind) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_ENSEIGNANT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_ENSEIGNANT": enseignants[ind].id.toString(),
          "ID_USER": enseignants[ind].idUser.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Get.back();
              getEnseignants();
              AppData.mySnackBar(
                  title: 'Liste des Enseignants',
                  message: "Enseignant supprimé ...",
                  color: AppColor.green);
            } else {
              AppData.mySnackBar(
                  title: 'Liste des Enseignants',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Liste des Enseignants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Liste des parents',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getEnseignants();
    super.onInit();
  }
}
