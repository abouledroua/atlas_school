// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/personne.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/listmessages/bottomwidgetlistmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListMessagesController extends GetxController {
  List<Personne> personnes = [];
  bool loading = true, error = false;
  TextEditingController txtMsg = TextEditingController(text: "");

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getListMessages() async {
    updateBooleans(newloading: true, newerror: false);
    personnes.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_LIST_MESSAGES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_USER": User.idUser.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Personne e;
            String? s;
            late bool vu;
            for (var m in responsebody) {
              s = m['VU'];
              vu = (s == null);
              e = Personne(
                  name: m['NAME'],
                  newMsg: vu,
                  lastMsg: m['MSG'],
                  isAdmin: int.parse(m['ISADMIN']) == 1,
                  date: DateTime.parse(m['DATEMSG']),
                  idUser: int.parse(m['USER']),
                  idParent: int.parse(m['PARENT']));
              personnes.add(e);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            personnes.clear();
            AppData.mySnackBar(
                title: 'Liste des Messages',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          personnes.clear();
          AppData.mySnackBar(
              title: 'Liste des Messages',
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
              getListMessages();
            }
          })
    ];
  }

  newMessage() async {
    print("new message");
    Get.bottomSheet(const BottomWidgetListMessages(),
        isScrollControlled: true,
        enterBottomSheetDuration: const Duration(milliseconds: 600),
        exitBottomSheetDuration: const Duration(milliseconds: 600));
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getListMessages();
    super.onInit();
  }
}
