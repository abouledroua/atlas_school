// ignore_for_file: avoid_print

import 'dart:io';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

class FicheEnfantController extends GetxController {
  late int idEnfant;
  String myPhoto = "", nom = "", prenom = "", dateNaiss = "";
  bool loading = false,
      selectPhoto = false,
      valNom = false,
      valPrenom = false,
      valDateNaiss = false,
      valider = false,
      isSwitched = true,
      error = false;
  late TextEditingController txtNom, txtPrenom, txtDateNaiss, txtAdresse;
  int? sexe = 1;
  DateTime? date;

  FicheEnfantController(int id) {
    idEnfant = id;
  }

  updateSexe(int? newValue) {
    sexe = newValue;
    update();
  }

  updateSwitch() {
    isSwitched = !isSwitched;
    update();
  }

  updateValider({required bool newValue}) {
    valider = newValue;
    update();
  }

  selectImage({required String path}) {
    myPhoto = path;
    selectPhoto = true;
    update();
  }

  pickPhoto(source) async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: source);
    if (image == null) return;
    selectImage(path: image.path);
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

  saveEnfant() {
    updateValider(newValue: true);
    valNom = txtNom.text.isEmpty;
    valPrenom = txtPrenom.text.isEmpty;
    valDateNaiss = txtDateNaiss.text.isEmpty;
    if (valNom || valPrenom || valDateNaiss) {
      print("Veuillez saisir les champs obligatoires !!!!");
      updateValider(newValue: true);
      AppData.mySnackBar(
          color: AppColor.red,
          title: 'Fiche Enfant',
          message: "Veuillez remplir les champs oligatoire !!!!");
    } else {
      existEnfant();
    }
  }

  existEnfant() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_ENFANT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text,
          "PRENOM": txtPrenom.text,
          "DATE_NAISS": txtDateNaiss.text,
          "ID_ENFANT": idEnfant.toString(),
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = 0;
            for (var m in responsebody) {
              result = int.parse(m['ID_ENFANT']);
            }
            if (result == 0) {
              if (idEnfant == 0) {
                insertEnfant();
              } else {
                updateEnfant();
              }
            } else {
              updateValider(newValue: false);
              AppData.mySnackBar(
                  title: 'Fiche Enfant',
                  message: "Cet Enfant existe déjà !!!",
                  color: AppColor.red);
            }
          } else {
            updateValider(newValue: false);
            AppData.mySnackBar(
                title: 'Fiche Enfant',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Enfant',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  insertEnfant() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/INSERT_ENFANT.php";
    print(url);
    int petat = isSwitched ? 1 : 2;
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {
      "NOM": txtNom.text.toUpperCase(),
      "PRENOM": txtPrenom.text.toUpperCase(),
      "DATE_NAISS": txtDateNaiss.text,
      "ADRESSE": txtAdresse.text,
      "SEXE": sexe.toString(),
      "ETAT": petat.toString(),
      "EXT": selectPhoto ? p.extension(myPhoto) : "",
      "DATA": selectPhoto ? base64Encode(File(myPhoto).readAsBytesSync()) : ""
    }).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("EnfantResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateValider(newValue: false);
          AppData.mySnackBar(
              title: 'Fiche Enfant',
              message: "Probleme lors de l'ajout !!!",
              color: AppColor.red);
        }
      } else {
        updateValider(newValue: false);
        AppData.mySnackBar(
            title: 'Fiche Enfant',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateValider(newValue: false);
      AppData.mySnackBar(
          title: 'Fiche Enfant',
          message: "Probleme de Connexion avec le serveur !!!",
          color: AppColor.red);
    });
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

  updateLoading({newloading, newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getEnfantInfo() async {
    updateLoading(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_INFO_ENFANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              txtNom.text = m['NOM'];
              txtPrenom.text = m['PRENOM'];
              txtAdresse.text = m['ADRESSE'];
              txtDateNaiss.text = m['DATE_NAISS'];
              myPhoto = m['PHOTO'];
              sexe = int.parse(m['SEXE']);
              int petat = int.parse(m['ETAT']);
              isSwitched = (petat == 1);
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Enfant',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          updateLoading(newloading: false, newerror: true);
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Enfant',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  updateEnfant() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/UPDATE_ENFANT.php";
    print(url);
    int petat = isSwitched ? 1 : 2;
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: {
      "ID_ENFANT": idEnfant.toString(),
      "SEXE": sexe.toString(),
      "NOM": txtNom.text.toUpperCase(),
      "PRENOM": txtPrenom.text.toUpperCase(),
      "DATE_NAISS": txtDateNaiss.text,
      "ADRESSE": txtAdresse.text,
      "ETAT": petat.toString(),
      "EXT": selectPhoto ? p.extension(myPhoto) : "",
      "DATA": selectPhoto ? base64Encode(File(myPhoto).readAsBytesSync()) : ""
    }).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("EnfantResponse=$responsebody");
        if (responsebody != "0") {
          Get.back(result: "success");
        } else {
          updateLoading(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Fiche Enfant',
              message: "Probleme lors de la mise a jour des informations !!!",
              color: AppColor.red);
        }
      } else {
        updateLoading(newloading: false, newerror: true);
        AppData.mySnackBar(
            title: 'Fiche Enfant',
            message: "Probleme de Connexion avec le serveur !!!",
            color: AppColor.red);
      }
    }).catchError((error) {
      print("erreur : $error");
      updateLoading(newloading: false, newerror: true);
      AppData.mySnackBar(
          title: 'Fiche Enfant',
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
    if (idEnfant != 0) getEnfantInfo();
    super.onInit();
  }

  @override
  void onClose() {
    txtNom.dispose();
    txtPrenom.dispose();
    txtDateNaiss.dispose();
    txtAdresse.dispose();
    super.onClose();
  }
}
