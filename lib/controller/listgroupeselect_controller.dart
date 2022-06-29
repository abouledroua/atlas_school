// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListGroupeSelectController extends GetxController {
  bool loading = false, error = false;
  List<Groupe> allgroupes = [];
  String query = "";
  List<int> indDes = [];

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getAllGroupes() async {
    updateBooleans(newloading: true, newerror: false);
    allgroupes.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ''})
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
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            AppData.mySnackBar(
                title: 'Liste des groupes',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          AppData.mySnackBar(
              title: 'Liste des groupes',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  updateQuery(String pQuery) {
    query = pQuery;
    update();
  }

  List<Groupe> filtrerCours() {
    indDes = [];
    List<Groupe> list = [];
    for (var item in allgroupes) {
      if (item.designation.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indDes.add(item.designation.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existGroup(int id) {
    FicheAnnonceController fcontroller = Get.find();
    for (var i = 0; i < fcontroller.groupes.length; i++) {
      if (fcontroller.groupes[i].id == id) {
        return true;
      }
    }
    return false;
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getAllGroupes();
    super.onInit();
  }
}
