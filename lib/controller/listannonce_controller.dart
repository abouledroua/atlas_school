// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListAnnonceController extends GetxController {
  bool loading = false, error = false;
  List<Annonce> annonces = [];

  getAnnonces() {
    if (User.isAdmin) {
      getAllAnnonces();
    } else {
      getUserAnnonces();
    }
  }

  getAllAnnonces() async {
    updateBooleans(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_ANNONCES.php";
    print("url=$url");
    annonces.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_USER": User.idUser.toString(), "WHERE": ""})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Annonce e;
            String s = "";
            late List<String> im, gr, en, pr;
            for (var m in responsebody) {
              s = m['IMAGES'];
              (s.isEmpty) ? im = [] : im = s.split(",");
              s = m['GROUPES'];
              (s.isEmpty) ? gr = [] : gr = s.split(",");
              s = m['ENFANTS'];
              (s.isEmpty) ? en = [] : en = s.split(",");
              s = m['PARENTS'];
              (s.isEmpty) ? pr = [] : pr = s.split(",");
              e = Annonce(
                  strEnfants: en,
                  strGroupes: gr,
                  strParents: pr,
                  date: m['DATE_ANNONCE'],
                  heure: m['HEURE_ANNONCE'],
                  images: im,
                  detail: m['DETAILS'],
                  dateTime: DateTime.parse(m['DATETIME']),
                  pin: (int.parse(m['PIN']) == 1),
                  id: int.parse(m['ID_ANNONCE']),
                  visiblite: int.parse(m['VISIBILITE']),
                  etat: int.parse(m['ETAT']),
                  titre: m['TITRE']);
              annonces.add(e);
            }
            print(
                "la liste de tous les annonces a été chargés ${annonces.length}...");
            for (var i = 0; i < annonces.length; i++) {
              if (annonces[i].strEnfants.isNotEmpty) await getMyEnfants(i);
              if (annonces[i].strParents.isNotEmpty) await getMyParents(i);
              if (annonces[i].strGroupes.isNotEmpty) await getMyGroupes(i);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            annonces.clear();
            updateBooleans(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des Annonces',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          annonces.clear();
          updateBooleans(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des Annonces',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getUserAnnonces() async {
    updateBooleans(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_USER_ANNONCES.php";
    print("url=$url");
    annonces.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_USER": User.idUser.toString(),
          "ID_PARENT": User.idParent.toString(),
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Annonce e;
            String s = "";
            late List<String> im, gr, en, pr;
            for (var m in responsebody) {
              s = m['IMAGES'];
              (s.isEmpty) ? im = [] : im = s.split(",");
              s = m['GROUPES'];
              (s.isEmpty) ? gr = [] : gr = s.split(",");
              s = m['ENFANTS'];
              (s.isEmpty) ? en = [] : en = s.split(",");
              s = m['PARENTS'];
              (s.isEmpty) ? pr = [] : pr = s.split(",");
              e = Annonce(
                  strEnfants: en,
                  strGroupes: gr,
                  strParents: pr,
                  date: m['DATE_ANNONCE'],
                  heure: m['HEURE_ANNONCE'],
                  images: im,
                  detail: m['DETAILS'],
                  dateTime: DateTime.parse(m['DATETIME']),
                  pin: (int.parse(m['PIN']) == 1),
                  id: int.parse(m['ID_ANNONCE']),
                  visiblite: int.parse(m['VISIBILITE']),
                  etat: int.parse(m['ETAT']),
                  titre: m['TITRE']);
              annonces.add(e);
            }
            print("la liste des annonces a été chargés ${annonces.length} ...");
            for (var i = 0; i < annonces.length; i++) {
              if (annonces[i].strEnfants.isNotEmpty) await getMyEnfants(i);
              if (annonces[i].strParents.isNotEmpty) await getMyParents(i);
              if (annonces[i].strGroupes.isNotEmpty) await getMyGroupes(i);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            annonces.clear();
            updateBooleans(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des Annonces',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          annonces.clear();
          updateBooleans(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des Annonces',
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
                      Icon(Icons.refresh),
                      SizedBox(width: 10),
                      Text("Actualiser")
                    ]))
              ],
          offset: const Offset(30, 30),
          elevation: 2,
          onSelected: (value) {
            if (value == 1) {
              getAnnonces();
            }
          })
    ];
  }

  getMyEnfants(int index) async {
    ListAnnonceController controller = Get.find();
    List s = controller.annonces[index].strEnfants;
    String serverDir = AppData.getServerDirectory();
    String pWhere = "";
    controller.annonces[index].enfants.clear();
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_ENFANT = " + item;
    }
    if (pWhere.isNotEmpty) {
      pWhere = " AND (" + pWhere + " )";
    }
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url \n pWhere=$pWhere");
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
                  sexe: sexe,
                  etat: int.parse(m['ETAT']),
                  adresse: m['ADRESSE'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              controller.annonces[index].enfants.add(e);
            }
            print(
                "la liste des enfants de l'annonce ont été chargés ${controller.annonces[index].parents.length}...");
          } else {
            controller.annonces[index].enfants.clear();
            AppData.mySnackBar(
                title: 'Liste des Enfants de l' 'annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          controller.annonces[index].enfants.clear();
          AppData.mySnackBar(
              title: 'Liste des Enfants de l' 'annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getMyParents(int index) async {
    ListAnnonceController controller = Get.find();
    List s = controller.annonces[index].strParents;
    String serverDir = AppData.getServerDirectory();
    String pWhere = "";
    controller.annonces[index].parents.clear();
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_PARENT = " + item;
    }
    if (pWhere.isNotEmpty) {
      pWhere = " AND (" + pWhere + " )";
    }
    var url = "$serverDir/GET_PARENTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    await http
        .post(myUri, body: {"WHERE": pWhere})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Parent p;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              p = Parent(
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
              controller.annonces[index].parents.add(p);
            }
            print(
                "la liste des parents de l'annonce ont été chargés ${controller.annonces[index].parents.length}...");
          } else {
            controller.annonces[index].parents.clear();
            AppData.mySnackBar(
                title: 'Liste des Parents de l' 'annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          controller.annonces[index].parents.clear();
          AppData.mySnackBar(
              title: 'Liste des Parents de l' 'annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  getMyGroupes(int index) async {
    ListAnnonceController controller = Get.find();
    List s = controller.annonces[index].strGroupes;
    String serverDir = AppData.getServerDirectory();

    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_GROUPE = " + item;
    }
    if (pWhere.isNotEmpty) {
      pWhere = " AND (" + pWhere + " )";
    }
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    controller.annonces[index].groupes.clear();
    Uri myUri = Uri.parse(url);
    await http
        .post(myUri, body: {"WHERE": pWhere})
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
              controller.annonces[index].groupes.add(e);
            }
            print(
                "la liste des groupes de l'annonce ont été chargés ${controller.annonces[index].parents.length}...");
          } else {
            controller.annonces[index].groupes.clear();
            AppData.mySnackBar(
                title: 'Liste des Groupes de l' 'annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          controller.annonces[index].groupes.clear();
          AppData.mySnackBar(
              title: 'Liste des Groupes de l' 'annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  unpinAnnonce(int index) async {
    int idAnnonce = annonces[index].id;
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/UNPIN_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    await http
        .post(myUri, body: {
          "ID_ANNONCE": idAnnonce.toString(),
          "ID_USER": User.idUser.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result == "0") {
              AppData.mySnackBar(
                  title: 'Lacher l' 'annonce',
                  message: "Probleme de Connexion avec le serveur !!!",
                  color: AppColor.red);
            } else {
              annonces[index].pin = false;
              update();
            }
          } else {
            AppData.mySnackBar(
                title: 'Lacher l' 'annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Lacher l' 'annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  pinAnnonce(int index) async {
    int idAnnonce = annonces[index].id;
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/PIN_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_ANNONCE": idAnnonce.toString(),
          "ID_USER": User.idUser.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result == "0") {
              AppData.mySnackBar(
                  title: 'Epingler l' 'annonce',
                  message: "Probleme de Connexion avec le serveur !!!",
                  color: AppColor.red);
            } else {
              annonces[index].pin = true;
              update();
            }
          } else {
            AppData.mySnackBar(
                title: 'Epingler l' 'annonce',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Epingler l' 'annonce',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  updateBooleans({newloading, newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getAnnonces();
    super.onInit();
  }
}
