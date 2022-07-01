// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../view/widget/listenfants/bottomwidgetlistenfants.dart';

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

  static buildHeader(String tag) => Container(
      height: 40,
      color: Colors.grey.shade300,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(tag,
          softWrap: false,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));

  Widget buildListItem(Enfant item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    final photo = AppData.getImage(item.photo, "PHOTO/ENFANT");
    return Column(children: [
      Offstage(offstage: offstage, child: buildHeader(tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SizedBox(
                  width: 60,
                  child: (item.photo == "")
                      ? Image.asset(AppImageAsset.noPhoto)
                      : CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          imageUrl: photo))),
          subtitle: Row(children: [
            Text(item.dateNaiss + "  --  ",
                style: const TextStyle(fontSize: 11)),
            Text(AppData.calculateAge(DateTime.parse(item.dateNaiss)),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
          ]),
          horizontalTitleGap: 6,
          onTap: () {
            int i = enfants.indexOf(item);
            print("item:${item.fullName}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListEnfant(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
            // showModal(i);
          })
    ]);
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
