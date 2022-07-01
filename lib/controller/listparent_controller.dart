// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/listparent/bottomwidgetlistparents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListParentsController extends GetxController {
  bool loading = false, error = false, searching = false;
  String query = "";
  List<Parent> parents = [];

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
                getParents();
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

  getParents() async {
    updateBooleans(newloading: true, newerror: false);
    parents.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_PARENTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
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
              parents.add(p);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            parents.clear();
            AppData.mySnackBar(
                title: 'Liste des Parents',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          parents.clear();
          AppData.mySnackBar(
              title: 'Liste des Parents',
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

  deleteParent(int ind) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_PARENT": parents[ind].id.toString(),
          "ID_USER": parents[ind].idUser.toString(),
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Get.back();
              getParents();
              AppData.mySnackBar(
                  title: 'Liste des parents',
                  message: "Parent supprimé ...",
                  color: AppColor.green);
            } else {
              AppData.mySnackBar(
                  title: 'Liste des parents',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Liste des parents',
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

  static buildHeader(String tag) => Container(
      height: 40,
      color: Colors.grey.shade300,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(tag,
          softWrap: false,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));

  Widget buildListItem(Parent item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(children: [
      Offstage(offstage: offstage, child: buildHeader(tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          subtitle: Row(children: [
            Text(item.dateNaiss + "  --  ",
                style: const TextStyle(fontSize: 11)),
            Text(item.tel1.isEmpty ? item.tel2 : item.tel1,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
          ]),
          horizontalTitleGap: 6,
          onTap: () {
            int i = parents.indexOf(item);
            print("item:${item.fullName}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListParents(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
            // showModal(i);
          })
    ]);
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getParents();
    super.onInit();
  }
}
