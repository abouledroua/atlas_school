// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FicheClasseController extends GetxController {
  late int idEnfant, idGroupe;
  bool loading = false, error = false;
  Enfant? enfant;
  Groupe? groupe;
  List<Enfant> allenfants = [];
  List<Groupe> allgroupes = [];
  List<Groupe> groupes = [];
  List<Enfant> enfants = [];

  FicheClasseController({required int idE, required int idG}) {
    idEnfant = idE;
    idGroupe = idG;
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

  chargerDonnees() async {
    if (idEnfant != 0) {
      getEnfantInfo();
    } else {
      getGroupeInfo();
    }
  }

  getAllGroupes() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GROUPES.php";
    allgroupes.clear();
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {})
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
              allgroupes.add(e);
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            allgroupes.clear();
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateLoading(newloading: false, newerror: true);
          allgroupes.clear();
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getAllEnfants() async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS.php";
    String pWhere = "";
    allenfants.clear();
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
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
              allenfants.add(e);
            }
            updateLoading(newloading: false, newerror: false);
          } else {
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateLoading(newloading: false, newerror: true);
          allenfants.clear();
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getListEnfant() async {
    enfants.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS_GROUPE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": idGroupe.toString(), "WHERE": ""})
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
            getAllEnfants();
          } else {
            enfants.clear();
            updateLoading(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          enfants.clear();
          updateLoading(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getListGroupe() async {
    groupes.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GROUPE_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
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
            getAllGroupes();
          } else {
            updateLoading(newloading: false, newerror: true);
            groupes.clear();
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateLoading(newloading: false, newerror: true);
          groupes.clear();
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getGroupeInfo() async {
    updateLoading(newloading: true, newerror: false);
    groupe = null;
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
              groupe = Groupe(
                  designation: m['DESIGNATION'],
                  id: int.parse(m['ID_GROUPE']),
                  etat: int.parse(m['ETAT']));
            }
            getListEnfant();
          } else {
            updateLoading(newloading: false, newerror: true);
            groupe = null;
            AppData.mySnackBar(
                title: 'Fiche Groupe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          updateLoading(newloading: false, newerror: true);
          groupe = null;
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Groupe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getEnfantInfo() async {
    updateLoading(newloading: true, newerror: false);
    enfant = null;
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
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              enfant = Enfant(
                  adresse: m['ADRESSE'],
                  dateNaiss: m['DATE_NAISS'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  id: idEnfant,
                  etat: int.parse(m['ETAT']),
                  isFemme: (sexe == 2),
                  isHomme: (sexe == 1),
                  nom: m['NOM'],
                  photo: m['PHOTO'],
                  prenom: m['PRENOM'],
                  sexe: sexe);
            }
            getListGroupe();
          } else {
            updateLoading(newloading: false, newerror: true);
            enfant = null;
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          updateLoading(newloading: false, newerror: true);
          enfant = null;
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  insertClasse(
      {int idGroupe = 0,
      int idEnfant = 0,
      required BuildContext context}) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/INSERT_CLASSE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_ENFANT": idEnfant.toString(),
          "ID_GROUPE": idGroupe.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = int.parse(responsebody);
            if (result == 0) {
              AppData.mySnackBar(
                  title: 'Fiche Classe',
                  message: "Probleme lors de l'ajout !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur 12!!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur 13 !!!",
              color: AppColor.red);
        });
  }

  deleteClasse(
      {int idGroupe = 0,
      int idEnfant = 0,
      required BuildContext context}) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_CLASSE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_ENFANT": idEnfant.toString(),
          "ID_GROUPE": idGroupe.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = int.parse(responsebody);
            if (result == 0) {
              AppData.mySnackBar(
                  title: 'Fiche Classe',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Fiche Classe',
                message: "Probleme de Connexion avec le serveur 14!!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Classe',
              message: "Probleme de Connexion avec le serveur 15!!!",
              color: AppColor.red);
        });
  }

  addGroupe(Groupe p) {
    groupes.add(p);
    update();
  }

  addEnfant(Enfant p) {
    enfants.add(p);
    update();
  }

  removeGroupe(Groupe p) {
    groupes.removeAt(groupes.indexOf(p));
    update();
  }

  removeEnfant(Enfant p) {
    enfants.removeAt(enfants.indexOf(p));
    update();
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    chargerDonnees();
    super.onInit();
  }
}
