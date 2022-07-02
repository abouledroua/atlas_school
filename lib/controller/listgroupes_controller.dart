// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListGroupesController extends GetxController {
  bool loading = false, error = false, searching = false;
  String query = "";
  List<Groupe> groupes = [];

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
                getGroupes();
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

  updateQuery(String newValue) {
    query = newValue;
    update();
  }

  updateSearching() {
    searching = !searching;
    update();
  }

  getGroupes() async {
    updateBooleans(newloading: true, newerror: false);
    groupes.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Groupe e;
            for (var m in responsebody) {
              e = Groupe(
                  designation: m['DESIGNATION'],
                  etat: int.parse(m['ETAT']),
                  id: int.parse(m['ID_GROUPE']));
              groupes.add(e);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            groupes.clear();
            AppData.mySnackBar(
                title: 'Liste des Groupes',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          groupes.clear();
          AppData.mySnackBar(
              title: 'Liste des Groupes',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  deleteGroupe(int ind) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_GROUPE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": groupes[ind].id.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Get.back();
              getGroupes();
              AppData.mySnackBar(
                  title: 'Liste des groupes',
                  message: "Groupe supprimé ...",
                  color: AppColor.green);
            } else {
              AppData.mySnackBar(
                  title: 'Liste des groupes',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Liste des groupes',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Liste des groupes',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getGroupes();
    super.onInit();
  }
}
