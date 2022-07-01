// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:math';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:atlas_school/view/screen/listannonce.dart';
import 'package:atlas_school/view/screen/listenfants.dart';
import 'package:atlas_school/view/screen/listparents.dart';
import 'package:atlas_school/view/screen/photoview.dart';
import 'package:cached_network_image/cached_network_image.dart';
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

  static setServerIP(ip) async {
    serverIP = ip;
    SettingServices c = Get.find();
    c.sharedPrefs.setString('ServerIp', serverIP);
  }

  static mySnackBar({required title, required message, required color}) =>
      Get.snackbar(title, message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: color,
          colorText: AppColor.white);

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

  static showImage(Annonce annonce, int i) => InkWell(
      onTap: () async {
        List<Photo> gallery = [];
        for (var item in annonce.images) {
          gallery.add(Photo(chemin: item, date: '', heure: '', id: 0));
        }
        Get.to(PhotoViewPage(
            index: i, folder: "ANNONCE", myImages: gallery, delete: false));
      },
      child: Center(
          child: Ink(
              padding: const EdgeInsets.all(2),
              child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: AppData.getImage(annonce.images[i], "ANNONCE"),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator()))));

  static calculateAge(DateTime birthDate) {
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

  static makeExternalRequest(String url) async {
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
                          Navigator.of(context).pushNamed("ListGroupes");
                        },
                        text: "Liste des Groupes"),
                  if (User.isAdmin)
                    _drawerButton(
                        color: AppColor.enseignant.withOpacity(0.3),
                        icon: Icons.person_pin_outlined,
                        context: context,
                        onTap: () {
                          Get.back();
                          Navigator.of(context).pushNamed("ListEnseignants");
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
                        Navigator.of(context).pushNamed("ListMessages");
                      },
                      text: "Liste des Messages"),
                  _drawerButton(
                      color: AppColor.gallery.withOpacity(0.3),
                      context: context,
                      icon: Icons.photo,
                      onTap: () {
                        Get.back();
                        Navigator.of(context).pushNamed("ListPhotos");
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
                        //  _logout();
                      },
                      text: "Déconnecter"),
                  if (User.isParent) const Divider(),
                  if (User.isParent) const SizedBox(height: 25),
                ]))
              ]))));

  //
  //
  //
  //
  //
  //
  //                   Visibility(
  //                       visible: currentUser!.isParent,
  //                       child: Visibility(
  //                           visible: _loadingEnfant,
  //                           child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 CircularProgressIndicator(
  //                                     color: AppColor
  //                                         .darkColor[Random().nextInt(
  //                                             AppColor.darkColor.length - 1) +
  //                                         1]),
  //                                 const SizedBox(width: 20),
  //                                 const Text("chargement ...")
  //                               ]),
  //                           replacement: Center(
  //                               child: Text(
  //                                   _enfants.isEmpty
  //                                       ? "Aucun Enfant"
  //                                       : "List des Enfants",
  //                                   style: GoogleFonts.laila(
  //                                       decoration: TextDecoration.underline,
  //                                       fontSize: 20,
  //                                       fontWeight: FontWeight.bold),
  //                                   overflow: TextOverflow.clip)))),
  //                   Visibility(
  //                       visible: (!currentUser!.isParent) ||
  //                           _loadingEnfant ||
  //                           _enfants.isEmpty,
  //                       child: Visibility(
  //                           visible: _errorEnfant,
  //                           child: ElevatedButton.icon(
  //                               style: ElevatedButton.styleFrom(
  //                                   primary: Colors.blue,
  //                                   onPrimary: Colors.white),
  //                               onPressed: getListEnfant,
  //                               icon: const FaIcon(FontAwesomeIcons.sync,
  //                                   color: Colors.white),
  //                               label: const Text("Actualiser"))),
  //                       replacement: Expanded(
  //                           child: Padding(
  //                               padding: const EdgeInsets.only(top: 10),
  //                               child: ListView.builder(
  //                                   shrinkWrap: true,
  //                                   primary: false,
  //                                   itemCount: _enfants.length,
  //                                   itemBuilder: (context, i) {
  //                                     return ListTile(
  //                                         horizontalTitleGap: 4,
  //                                         title: Text(_enfants[i].fullName,
  //                                             style: GoogleFonts.laila(
  //                                                 fontSize: 12),
  //                                             overflow: TextOverflow.clip),
  //                                         leading: Padding(
  //                                             padding:
  //                                                 const EdgeInsets.all(2.0),
  //                                             child: SizedBox(
  //                                                 width: 60,
  //                                                 child: (_enfants[i].photo == "")
  //                                                     ? Image.asset(
  //                                                         "images/noPhoto.png")
  //                                                     : CachedNetworkImage(
  //                                                         placeholder: (context, url) =>
  //                                                             CircularProgressIndicator(
  //                                                                 color: AppColor.darkColor[Random().nextInt(AppColor.darkColor.length - 1) +
  //                                                                     1]),
  //                                                         imageUrl: getImage(
  //                                                             _enfants[i].photo,
  //                                                             "PHOTO/ENFANT")))));
  //                                   }))))
  //                 ]))

}
