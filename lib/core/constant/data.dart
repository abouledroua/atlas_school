// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:math';
import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/controller/listgroupes_controller.dart';
import 'package:atlas_school/controller/listmessages_controller.dart';
import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/controller/user_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/routes.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:atlas_school/view/screen/listannonce.dart';
import 'package:atlas_school/view/screen/listenfants.dart';
import 'package:atlas_school/view/screen/listenseignant.dart';
import 'package:atlas_school/view/screen/listgroupe.dart';
import 'package:atlas_school/view/screen/listmessages.dart';
import 'package:atlas_school/view/screen/listparents.dart';
import 'package:atlas_school/view/widget/drawer/listenfantsdrawer.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AppData {
  static String www = "ATLAS", serverIP = "atlasschool.dz";
  static int timeOut = 8;

  static String getServerIP() => serverIP;

  static int getTimeOut() => timeOut;

  static String getServerDirectory([port = ""]) => ((serverIP == "")
      ? ""
      : "https://$serverIP" + (port != "" ? ":" + port : "") + "/" + www);

  static String getImage(pImage, pType) =>
      getServerDirectory() + "/IMAGE/$pType/$pImage";

  static void setServerIP(ip) async {
    serverIP = ip;
    SettingServices c = Get.find();
    c.sharedPrefs.setString('ServerIp', serverIP);
  }

  static void mySnackBar({required title, required message, required color}) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: color,
        colorText: AppColor.white);
  }

  static String printDate(DateTime? date) {
    DateTime currentDate = DateTime.now();
    int yy = currentDate.year - date!.year;
    String str = "";
    if (yy > 0) {
      str = DateFormat('yyyy-MM-dd').format(date);
    } else {
      int mm = currentDate.month - date.month;
      int dd = currentDate.day - date.day;
      int hh = currentDate.hour - date.hour;
      int min = currentDate.minute - date.minute;
      if (mm < 0) {
        yy--;
        mm += 12;
      }
      if (dd < 0) {
        mm--;
        dd += 30;
      }
      if (hh < 0) {
        dd--;
        hh += 24;
      }
      if (min < 0) {
        hh--;
        min += 60;
      }
      if (dd > 6) {
        str = DateFormat('dd MMM à HH:mm').format(date);
      } else {
        String ch = "";
        switch (dd) {
          case 0:
            if (hh > 0) {
              ch = "0" + hh.toString();
              ch = ch.substring(ch.length - 2);
              str = "Il y'a " + ch + " heure(s)";
            } else {
              if (min > 0) {
                ch = "0" + min.toString();
                ch = ch.substring(ch.length - 2);
                str = "Il y'a " + ch + " minute(s)";
              } else {
                str = "Il y a un instant";
              }
            }
            break;
          case 1:
            str = "Hier " + DateFormat('HH:mm').format(date);
            break;
          default:
            str = DateFormat('EEE à HH:mm').format(date);
            break;
        }
      }
    }
    return str;
  }

  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int yy = currentDate.year - birthDate.year;
    int mm = currentDate.month - birthDate.month;
    int dd = currentDate.day - birthDate.day;
    if (mm < 0) {
      yy--;
      mm += 12;
    }
    if (dd < 0) {
      mm--;
      dd += 30;
    }
    String age = "";
    if (yy > 1) {
      age = "$yy an(s)";
    } else {
      mm = yy * 12 + mm;
      if (mm > 0) {
        age = "$mm mois";
      } else if (dd > 0) {
        age = "$dd jours";
      }
    }
    return age;
  }

  static void makeExternalRequest(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Widget _drawerButton(
          {required String text,
          required IconData icon,
          required Color? color,
          required BuildContext context,
          required onTap}) =>
      InkWell(
          onTap: onTap,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(
                  horizontal:
                      min(AppSizes.heightScreen, AppSizes.widthScreen) / 14,
                  vertical: 4),
              decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Ink(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(icon, color: Colors.black, size: 26),
                    const SizedBox(width: 10),
                    Text(text,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold))
                  ]))));

  static void reparerBDD() {
    String serverDir = getServerDirectory();
    var url = "$serverDir/REPARER_BDD.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {})
        .timeout(Duration(seconds: timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              AppData.mySnackBar(
                  title: 'Base de Données',
                  message: "La base de données à été réparer ...",
                  color: AppColor.green);
            } else {
              AppData.mySnackBar(
                  title: 'Base de Données',
                  message:
                      "Probleme lors de la réparation de la base de données !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Base de Données',
                message: "Probleme de Connexion avec le serveur 5!!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Base de Données',
              message: "Probleme de Connexion avec le serveur 6!!!",
              color: AppColor.red);
        });
  }

  static void logout() {
    String alert = '';
    (User.isEns) //&& GestGalleryImages.myImages.isNotEmpty)
        ? alert =
            '\n Attention tous LES chargement des images seront arrêter ....'
        : alert = '';
    AwesomeDialog(
            context: Get.context!,
            dialogType: DialogType.QUESTION,
            title: '',
            btnOkText: "Oui",
            btnCancelText: "Non",
            width: min(AppSizes.maxWidth, AppSizes.widthScreen),
            btnCancelOnPress: () {
              HomePageController hc = Get.find();
              if (hc.pageIndex == 7) {
                hc.changePage(hc.oldPage);
              }
            },
            btnOkOnPress: () async {
              SettingServices c = Get.find();
              c.sharedPrefs.setBool('LastConnected', false);
              User.idUser = 0;
              UserController userController = Get.find();
              userController.enfants = [];
              Get.delete<HomePageController>();
              Get.delete<ListAnnonceController>();
              Get.delete<ListEnfantsController>();
              Get.delete<ListParentsController>();
              Get.delete<ListEnseignantsController>();
              Get.delete<ListGroupesController>();
              Get.delete<ListMessagesController>();
              Get.offAllNamed(AppRoute.login);
            },
            showCloseIcon: true,
            desc: 'Voulez-vous vraiment déconnecter ??' + alert)
        .show();
  }

  static Drawer myDrawer(BuildContext context, {Color? color}) => Drawer(
      child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text("Hi",
                                  style:
                                      Theme.of(context).textTheme.headline1)),
                          Center(
                              child: Wrap(children: [
                            Text(User.isAdmin ? "Administrateur" : User.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline1)
                          ]))
                        ])),
                const Divider(),
                Expanded(
                    child:
                        ListView(shrinkWrap: true, primary: false, children: [
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.enfant.withOpacity(0.3),
                        icon: Icons.person_outline_sharp,
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(() => const ListEnfants());
                        },
                        text: "Liste des Enfants"),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.parent.withOpacity(0.3),
                        icon: Icons.group_outlined,
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(() => const ListParents());
                        },
                        text: "Liste des Parents"),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.groupe.withOpacity(0.3),
                        icon: Icons.groups_outlined,
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(() => const ListGroupes());
                        },
                        text: "Liste des Groupes"),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.enseignant.withOpacity(0.3),
                        icon: Icons.person_pin_outlined,
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(() => const ListEnseignants());
                        },
                        text: "Liste des Enseigants"),
                  if (User.isAdmin) const Divider(),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.annocne.withOpacity(0.3),
                        icon: Icons.announcement_outlined,
                        context: context,
                        onTap: () {
                          Get.back();
                          Get.to(() => const ListAnnonces());
                        },
                        text: "Liste des Annonces"),
                  _drawerButton(
                      color: AppColor.message.withOpacity(0.3),
                      context: context,
                      icon: Icons.sms,
                      onTap: () {
                        Get.back();
                        Get.to(() => const ListMessages());
                      },
                      text: "Liste des Messages"),
                  _drawerButton(
                      color: AppColor.gallery.withOpacity(0.3),
                      context: context,
                      icon: Icons.photo,
                      onTap: () {
                        // Get.back();
                        // Get.to(() => const ListPhotos());
                      },
                      text: "Gallerie des Photos"),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.blue1.withOpacity(0.3),
                        context: context,
                        icon: Icons.settings,
                        onTap: () {
                          Get.back();
                          reparerBDD();
                        },
                        text: "Réparer La BDD"),
                  _drawerButton(
                      color: AppColor.red.withOpacity(0.3),
                      context: context,
                      icon: Icons.logout,
                      onTap: () {
                        logout();
                      },
                      text: "Déconnecter"),
                  if (User.isParent) const Divider(),
                  if (User.isParent) const SizedBox(height: 25),
                  if (User.isParent)
                    GetBuilder<UserController>(
                        builder: (controller) => Visibility(
                            visible: controller.loading,
                            child: const LoadingWidget(),
                            replacement: Center(
                                child: Text(
                                    controller.enfants.isEmpty
                                        ? "Aucun Enfant"
                                        : "List des Enfants",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold))))),
                  if (User.isParent) const ListOfEnfantDrawer()
                ]))
              ]))));
}
