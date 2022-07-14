// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/message.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/fichemessage/bottomfichemessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FicheMessageController extends GetxController {
  int idUser = 0;
  String parentName = "";
  bool loading = true, error = false;
  TextEditingController txtMsg = TextEditingController(text: "");
  List<Message> messages = [];

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  FicheMessageController({required int idU, required String pName}) {
    idUser = idU;
    parentName = pName;
  }

  getMessages() async {
    updateBooleans(newloading: true, newerror: false);
    messages.clear();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_MESSAGES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_USER": User.idUser.toString(),
          "ID_OTHER": idUser.toString()
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Message e;
            for (var m in responsebody) {
              e = Message(
                  sent: 1,
                  body: m['MSG'],
                  date: DateTime.parse(m['DATEMSG']),
                  idRecept: int.parse(m['ID_RECEPT']),
                  idMessage: int.parse(m['ID_MESSAGE']),
                  etat: int.parse(m['ETAT']),
                  idSend: int.parse(m['ID_SEND']));
              messages.add(e);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            messages.clear();
            AppData.mySnackBar(
                title: 'Fiche Message',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          messages.clear();
          AppData.mySnackBar(
              title: 'Fiche Message',
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
              getMessages();
            }
          })
    ];
  }

  sendMessage() {
    if (txtMsg.text.isNotEmpty) {
      DateTime currentDate = DateTime.now();
      Message msg = Message(
          sent: 0,
          idMessage: 0,
          body: txtMsg.text,
          date: currentDate,
          etat: 1,
          idRecept: idUser,
          idSend: User.idUser);
      messages.add(msg);
      txtMsg.text = "";
      update();
      insertMsg(msg, messages.indexOf(msg));
    }
  }

  insertMsg(Message msg, int i) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/INSERT_MESSAGE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    String msgBody = msg.body.toString();
    http
        .post(myUri, body: {
          "ID_SEND": msg.idSend.toString(),
          "ID_RECEPT": msg.idRecept.toString(),
          "BODY": msgBody
        })
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              messages[i].sent = 1;
              messages[i].idMessage = int.parse(result);
              update();
            } else {
              messages[i].sent = -1;
              update();
              AppData.mySnackBar(
                  title: 'Fiche Message',
                  message: "Probleme lors de l'envoi du message !!!",
                  color: AppColor.red);
            }
          } else {
            messages[i].sent = -1;
            update();
            AppData.mySnackBar(
                title: 'Fiche Message',
                message: "Probleme de Connexion avec le serveur 2 !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          messages[i].sent = -1;
          update();
          AppData.mySnackBar(
              title: 'Fiche Message',
              message: "Probleme de Connexion avec le serveur 1 !!!",
              color: AppColor.red);
        });
  }

  showModal(int i) {
    Get.bottomSheet(BottomFicheMessage(i: i),
        elevation: 5,
        isScrollControlled: true,
        enterBottomSheetDuration: const Duration(milliseconds: 600),
        exitBottomSheetDuration: const Duration(milliseconds: 600));
  }

  resendMsg(int i) {
    txtMsg.text = messages[i].body;
    messages.removeAt(i);
    sendMessage();
    Get.back();
  }

  deleteMessage(int i) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_MESSAGE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_MESSAGE": messages[i].idMessage.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Get.back();
              AppData.mySnackBar(
                  title: 'Fiche Message',
                  message: "Message supprimé ...",
                  color: AppColor.green);
              messages.removeAt(i);
              update();
            } else {
              AppData.mySnackBar(
                  title: 'Fiche Message',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Fiche Message',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Fiche Message',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    print('on Init FicheMessageController');
    getMessages();
    super.onInit();
  }
}
