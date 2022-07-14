// ignore_for_file: avoid_print

import 'dart:async';
import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Fetch {
  static bool _fetchSms = false;

  static searchNewMessages() {
    print("start fetching new messages ...");
    // SettingServices c = Get.find();
    // String prefKey = 'messages_' + User.idUser.toString();
    // c.sharedPrefs.setStringList(prefKey, []);
    if (User.idUser != 0 && !_fetchSms) {
      _getNewMessages();
    } else {
      print(_fetchSms
          ? "Someone else is fetching Messages ..."
          : "you are not connected");
    }
    const delayDuration = Duration(seconds: 2);
    Timer(delayDuration, searchNewMessages);
    print("finish fetching new messages ...");
  }

  static _getNewMessages() async {
    _fetchSms = true;
    HomePageController controller = Get.find();
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_NEW_MESSAGES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_USER": User.idUser.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            String msgs = "", idParent = "";
            List<int> idP = [], idM = [];
            for (var m in responsebody) {
              msgs = m['MSG'];
              idParent = m['ID_USER'];
              if (msgs.isNotEmpty) {
                int id = int.parse(msgs);
                idM.add(id);
                id = int.parse(idParent);
                idP.add(id);
              }
            }
            controller.updateUnreadMsg(idm: idM, idp: idP);
            print("responsebody=$responsebody");
          }
        })
        .catchError((error) {
          print("erreur : $error");
        });
    _fetchSms = false;
  }

  // static _existMessages(List<String> idMessages) async {
  //   SettingServices c = Get.find();
  //   String prefKey = 'messages_' + User.idUser.toString();
  //   _msgs = c.sharedPrefs.getStringList(prefKey);
  //   if (_msgs == null) {
  //     unReadMsgs = idMessages;
  //     // _addMessages(idMessages);
  //   } else {
  //     for (var item in idMessages) {
  //       if (!_msgs!.contains(item)) {
  //         unReadMsgs.add(item);
  //       }
  //     }
  //     if (unReadMsgs.isNotEmpty) {
  //       HomePageController controller = Get.find();
  //       controller.updateNewMessage(true);
  //       // _addMessages(list);
  //     }
  //   }
  //   isExistUnreadMsgs();
  // }

  // static _addMessages(List<String> list) async {
  //   SettingServices c = Get.find();
  //   String prefKey = 'messages_' + User.idUser.toString();
  //   _msgs = c.sharedPrefs.getStringList(prefKey);
  //   _msgs ??= [];
  //   for (var item in list) {
  //     _msgs!.add(item);
  //   }
  //   c.sharedPrefs.setStringList(prefKey, _msgs!);
  //   HomePageController controller = Get.find();
  //   controller.updateNewMessage(true);
  // }

}
