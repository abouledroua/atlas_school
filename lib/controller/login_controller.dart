// ignore_for_file: avoid_print

import 'dart:async';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  bool isBack = Get.routing.isBack!;
  late TextEditingController userController, passController;
  bool valider = false;

  Future<bool> onWillPop() async {
    return (await showDialog(
            context: Get.context!,
            builder: (context) => AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.exit_to_app_sharp, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Etes-vous sur ?'))
                    ]),
                    content: const Text(
                        "Voulez-vous vraiment quitter l'application ?"),
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

  setValider(pValue) {
    valider = pValue;
    update();
  }

  onValidate() {
    setValider(true);
    print("valider=$valider");
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/EXIST_USER.php";
    String userName = userController.text.toUpperCase();
    String password = passController.text.toUpperCase();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"USERNAME": userName, "PASSWORD": password})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            User.idUser = 0;
            for (var m in responsebody) {
              User.idUser = int.parse(m['ID_USER']);
              User.name = m['NAME'];
              User.phone = m['PHONE'];
              User.msgBlock = int.parse(m['BLOCK_MSG']);
              User.etat = int.parse(m['ETAT']);
              User.idEns = int.parse(m['ID_ENSEIGNANT']);
              User.idParent = int.parse(m['ID_PARENT']);
              User.type = int.parse(m['TYPE']);
              User.username = userName;
              User.password = password;
              User.isAdmin = (User.type == 2);
              User.isEns = (User.type == 3);
              User.isParent = (User.type == 1);
            }
            if (User.idUser == 0) {
              effacerLastUser();
              print("Nom d' 'utilisateur ou mot de passe invalide !!!");
              setValider(false);
              AppData.mySnackBar(
                  title: 'Login',
                  message: "Nom d' 'utilisateur ou mot de passe invalide !!!",
                  color: AppColor.red);
            } else if (User.etat == 1) {
              print("Its Ok ----- Connected ----------------");
              SettingServices c = Get.find();
              c.sharedPrefs.setString('LastUser', userName);
              c.sharedPrefs.setString('LastPass', password);
              c.sharedPrefs.setBool('LastConnected', true);
              String privacy =
                  c.sharedPrefs.getString('Privacy${User.idUser}') ?? "";
              if (privacy.isEmpty) {
                Get.toNamed('/privacy');
              }
              Get.offAllNamed('/homepage');
            } else {
              effacerLastUser();
              AppData.mySnackBar(
                  title: 'Login',
                  message:
                      "Utilisateur inactif !!! \nVeuillez contacter l'administration ...",
                  color: AppColor.red);
              print(
                  "Utilisateur inactif !!! \nVeuillez contacter l'administration ...");
              setValider(false);
              print("etat = ${User.etat}");
            }
          } else {
            effacerLastUser();
            AppData.mySnackBar(
                title: 'Login',
                message: "Probleme lors de la connexion avec le serveur !!!",
                color: AppColor.red);
            print("Probleme lors de la connexion avec le serveur !!!");
            setValider(false);
          }
        })
        .catchError((error) {
          effacerLastUser();
          AppData.mySnackBar(
              title: 'Login',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
          print("erreur : $error");
          print("Probleme de Connexion avec le serveur !!!");
          setValider(false);
          print("error : ${error.toString()}");
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    userController = TextEditingController();
    passController = TextEditingController();
    SettingServices c = Get.find();
    //effacerLastUser();
    String userPref = c.sharedPrefs.getString('LastUser') ?? "";
    String passPref = c.sharedPrefs.getString('LastPass') ?? "";
    bool connect = c.sharedPrefs.getBool('LastConnected') ?? false;
    if (userPref.isNotEmpty && connect) {
      userController.text = userPref;
      passController.text = passPref;
      onValidate();
    }
    super.onInit();
  }

  effacerLastUser() {
    SettingServices c = Get.find();
    c.sharedPrefs.setString('LastUser', "");
    c.sharedPrefs.setString('LastPass', "");
    c.sharedPrefs.setBool('LastConnected', false);
  }

  @override
  void onClose() {
    userController.dispose();
    passController.dispose();
    super.onClose();
  }
}
