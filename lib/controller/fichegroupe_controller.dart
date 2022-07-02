// ignore_for_file: avoid_print

import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FicheGroupeController extends GetxController {
  late int idGroupe;
  bool loading = false, valDes = false, valider = false, error = false;
  int? etat = 1;
  late int idUser;
  late TextEditingController txtDes;

  FicheGroupeController(int id) {
    idGroupe = id;
  }

  updateValider({required bool newValue}) {
    valider = newValue;
    update();
  }

  updateLoading({newloading, newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.cancel_outlined, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Annuler ?'))
                    ]),
                    content: const Text(
                        "Voulez-vous vraiment annuler tous les changements !!!"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Non',
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Oui',
                              style: TextStyle(color: Colors.green)))
                    ]))) ??
        false;
  }

  saveGroupe() {
    updateValider(newValue: true);
    valDes = txtDes.text.isEmpty;
    if (valDes) {
      print("Veuillez saisir les champs obligatoires !!!!");
      updateValider(newValue: false);
      AppData.mySnackBar(
          color: AppColor.red,
          title: 'Fiche Groupe',
          message: "Veuillez remplir les champs oligatoire !!!!");
    } else {
      existGroupe();
    }
  }

  existGroupe() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_GROUPE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "DESIGNATION": txtDes.text,
          "ID_GROUPE": idGroupe.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = 0;
            for (var m in responsebody) {
              result = int.parse(m['ID_GROUPE']);
            }
            if (result == 0) {
              print("Groupe n'existe pas ...");
              if (idGroupe == 0) {
                insertGroupe();
              } else {
                updateGroupe();
              }
            } else {
              updateValider(newValue: false);
              AppData.mySnackBar(
                  title: 'Fiche Groupe',
                  message: "Ce Groupe existe déjà !!!",
                  color: AppColor.red);
            }
          } else {
            updateValider(newValue: false);
            AppData.mySnackBar(
                title: 'Fiche Groupe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Groupe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  insertGroupe() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/INSERT_GROUPE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {"DESIGNATION": txtDes.text.toUpperCase()}).then(
        (response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("GroupeResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Groupe',
              message: "Probleme lors de l'ajout !!!",
              color: AppColor.red);
        }
      } else {
        updateValider(newValue: false);
        AppData.mySnackBar(
            title: 'Fiche Groupe',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateValider(newValue: false);
      AppData.mySnackBar(
          title: 'Fiche Groupe',
          message: "Probleme de Connexion avec le serveur !!!",
          color: AppColor.red);
    });
  }

  updateGroupe() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/UPDATE_GROUPE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {
      "ID_GROUPE": idGroupe.toString(),
      "DESIGNATION": txtDes.text.toUpperCase()
    }).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("GroupeResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateLoading(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Fiche Groupe',
              message: "Probleme lors de la mise a jour des informations !!!",
              color: AppColor.red);
        }
      } else {
        updateLoading(newloading: false, newerror: true);
        AppData.mySnackBar(
            title: 'Fiche Groupe',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateLoading(newloading: false, newerror: true);
      AppData.mySnackBar(
          title: 'Fiche Groupe',
          message: "Probleme de Connexion avec le serveur !!!",
          color: AppColor.red);
    });
  }

  getGroupeInfo() async {
    updateLoading(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_INFO_GROUPE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": idGroupe.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              txtDes.text = m['DESIGNATION'];
              etat = int.parse(m['ETAT']);
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Groupe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          updateLoading(newloading: false, newerror: true);
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Groupe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    txtDes = TextEditingController();
    if (idGroupe != 0) getGroupeInfo();
    super.onInit();
  }

  @override
  void onClose() {
    txtDes.dispose();
    super.onClose();
  }
}
