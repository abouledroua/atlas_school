// ignore_for_file: avoid_print

import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FicheParentController extends GetxController {
  late int idParent;
  bool loading = false,
      valNom = false,
      valPrenom = false,
      valider = false,
      isSwitched = true,
      error = false;
  DateTime? date;
  int? sexe = 1;
  late int idUser;
  late TextEditingController txtNom,
      txtPrenom,
      txtDateNaiss,
      txtAdresse,
      txtTel1,
      txtTel2;

  FicheParentController(int id) {
    idParent = id;
  }

  updateSexe(int? newValue) {
    sexe = newValue;
    update();
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

  updateDateController() {
    txtDateNaiss.text = DateFormat('yyyy-MM-dd').format(date!);
    update();
  }

  datePicker({required BuildContext context}) {
    showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now())
        .then((value) {
      if (value != null) {
        date = value;
        updateDateController();
      }
    });
  }

  saveParent() {
    updateValider(newValue: true);
    valNom = txtNom.text.isEmpty;
    valPrenom = txtPrenom.text.isEmpty;
    if (valNom || valPrenom) {
      print("Veuillez saisir les champs obligatoires !!!!");
      updateValider(newValue: false);
      AppData.mySnackBar(
          color: AppColor.red,
          title: 'Fiche Parent',
          message: "Veuillez remplir les champs oligatoire !!!!");
    } else {
      existParent();
    }
  }

  existParent() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text,
          "PRENOM": txtPrenom.text,
          "DATE_NAISS": txtDateNaiss.text,
          "ID_PARENT": idParent.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = 0;
            for (var m in responsebody) {
              result = int.parse(m['ID_PARENT']);
            }
            if (result == 0) {
              print("parent n'existe pas ...");
              if (idParent == 0) {
                insertParent();
              } else {
                updateParent();
              }
            } else {
              updateValider(newValue: false);
              AppData.mySnackBar(
                  title: 'Fiche Parent',
                  message: "Ce Parent existe déjà !!!",
                  color: AppColor.red);
            }
          } else {
            updateValider(newValue: false);
            AppData.mySnackBar(
                title: 'Fiche Parent',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Parent',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  insertParent() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/INSERT_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {
      "NOM": txtNom.text.toUpperCase(),
      "PRENOM": txtPrenom.text.toUpperCase(),
      "DATE_NAISS": txtDateNaiss.text,
      "ADRESSE": txtAdresse.text,
      "TEL1": txtTel1.text,
      "TEL2": txtTel2.text,
      "SEXE": sexe.toString()
    }).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("ParentResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Parent',
              message: "Probleme lors de l'ajout !!!",
              color: AppColor.red);
        }
      } else {
        updateValider(newValue: false);
        AppData.mySnackBar(
            title: 'Fiche Parent',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateValider(newValue: false);
      AppData.mySnackBar(
          title: 'Fiche Parent',
          message: "Probleme de Connexion avec le serveur !!!",
          color: AppColor.red);
    });
  }

  updateParent() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/UPDATE_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {
      "ID_PARENT": idParent.toString(),
      "SEXE": sexe.toString(),
      "ID_USER": idUser.toString(),
      "NOM": txtNom.text.toUpperCase(),
      "PRENOM": txtPrenom.text.toUpperCase(),
      "DATE_NAISS": txtDateNaiss.text,
      "ADRESSE": txtAdresse.text,
      "TEL1": txtTel1.text,
      "TEL2": txtTel2.text
    }).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("ParentResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateLoading(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Fiche Parent',
              message: "Probleme lors de la mise a jour des informations !!!",
              color: AppColor.red);
        }
      } else {
        updateLoading(newloading: false, newerror: true);
        AppData.mySnackBar(
            title: 'Fiche Parent',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateLoading(newloading: false, newerror: true);
      AppData.mySnackBar(
          title: 'Fiche Parent',
          message: "Probleme de Connexion avec le serveur !!!",
          color: AppColor.red);
    });
  }

  getParentInfo() async {
    updateLoading(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_INFO_PARENTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": idParent.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              txtNom.text = m['NOM'];
              txtPrenom.text = m['PRENOM'];
              txtAdresse.text = m['ADRESSE'];
              txtDateNaiss.text = m['DATE_NAISS'];
              txtTel1.text = m['TEL1'];
              txtTel2.text = m['TEL2'];
              idUser = int.parse(m['ID_USER']);
              sexe = int.parse(m['SEXE']);
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Parent',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          updateLoading(newloading: false, newerror: true);
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Parent',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    txtNom = TextEditingController();
    txtPrenom = TextEditingController();
    txtDateNaiss = TextEditingController();
    txtAdresse = TextEditingController();
    txtTel1 = TextEditingController();
    txtTel2 = TextEditingController();
    if (idParent != 0) getParentInfo();
    super.onInit();
  }

  @override
  void onClose() {
    txtNom.dispose();
    txtPrenom.dispose();
    txtDateNaiss.dispose();
    txtAdresse.dispose();
    txtTel1.dispose();
    txtTel2.dispose();
    super.onClose();
  }
}
