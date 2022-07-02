// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListEnfantsController extends GetxController {
  bool loading = false, error = false, searching = false;
  String query = "";
  List<Enfant> enfants = [];

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getEnfants() async {
    updateBooleans(newloading: true, newerror: false);
    enfants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""}) //, "CODE": code
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
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              enfants.add(e);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            enfants.clear();
            AppData.mySnackBar(
                title: 'Liste des Enfants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          enfants.clear();
          AppData.mySnackBar(
              title: 'Liste des Enfants',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

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
                getEnfants();
                break;
              default:
            }
          })
    ];
  }

  updateQuery(String newValue) {
    query = newValue;
    update();
  }

  updateSearching() {
    searching = !searching;
    update();
  }

  deleteEnfant(int ind) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_ENFANT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfants[ind].id.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Get.back();
              getEnfants();
              AppData.mySnackBar(
                  title: 'Liste des enfants',
                  message: "Enfant supprimé ...",
                  color: AppColor.green);
            } else {
              AppData.mySnackBar(
                  title: 'Liste des enfants',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Liste des enfants',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Liste des enfants',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getEnfants();
    super.onInit();
  }
}
