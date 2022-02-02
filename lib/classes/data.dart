// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/gest_gallery_images.dart';
import 'package:atlas_school/classes/user.dart';
import 'package:atlas_school/pages/lists/list_enfants.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Data {
  static bool production = true;
  static String serverIP = "";
  static String localIP = "";
  static String internetIP = "";
  static int networkMode = 1;
  static int nbArticle = 0;
  static bool _loadingEnfant = false,
      canPop = false,
      loadingAdmin = false,
      _errorEnfant = false,
      errorAdmin = false,
      isLandscape = false,
      isPortrait = false,
      updList = false;
  static int timeOut = 0;
  static int specId = -1;
  static double minTablet = 450;
  static double widthScreen = double.infinity;
  static late double heightScreen;
  static late double heightmyAppBar;
  static String www = "ATLAS";
  static int index = 0;
  static final List<Enfant> _enfants = [];
  static late BuildContext myContext;
  static User? currentUser;
  static late int? adminId;
  static List<bool> selections = [];
  static const MaterialColor white = MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
  static List<Color> lightColor = [
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.amber.shade50,
    Colors.blueGrey.shade50,
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.deepPurple.shade50,
    Colors.cyan.shade50,
    Colors.brown.shade50,
    Colors.deepOrange.shade50,
    Colors.deepPurple.shade50,
    Colors.lightBlue.shade50,
    Colors.lime.shade50,
    Colors.orange.shade50,
    Colors.teal.shade50,
    Colors.pink.shade50,
    Colors.indigo.shade50,
    Colors.grey.shade50,
    Colors.yellow.shade50,
    Colors.black12,
    Colors.amberAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.cyanAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.tealAccent.shade100
  ];
  static List<Color> darkColor = [
    Colors.amberAccent,
    Colors.blue,
    Colors.red,
    Colors.amber,
    Colors.blueGrey,
    Colors.blue,
    Colors.green,
    Colors.deepPurple,
    Colors.greenAccent,
    Colors.cyan,
    Colors.blueAccent,
    Colors.brown,
    Colors.cyanAccent,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.lime,
    Colors.orange,
    Colors.purpleAccent,
    Colors.tealAccent,
    Colors.deepPurpleAccent,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.grey,
    Colors.yellow,
    Colors.black12
  ];

  static int getTimeOut() => timeOut;

  static User? getCurrentUser() => currentUser;

  static int getNbArticle() => nbArticle;

  static int getNetworkMode() => networkMode;

  static String getServerIP() => serverIP;

  static String getLocalIP() => localIP;

  static String getInternetIP() => internetIP;

  static String getFile(pFile) => getServerDirectory("80") + "/FILES/$pFile";

  static String getServerDirectory([port = "80"]) => ((serverIP == "")
      ? ""
      : "https://$serverIP" +
          (port != "" && networkMode == 1 ? ":" + port : "") +
          "/" +
          www);

  static String getImage(pImage, pType) =>
      getServerDirectory("80") + "/IMAGE/$pType/$pImage";

  static setCurrentUser(User u) {
    currentUser = u;
  }

  static setNbArticle(nb) {
    nbArticle = nb;
  }

  static setServerIP(ip) async {
    serverIP = ip;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('ServerIp', serverIP);
  }

  static setLocalIP(ip) async {
    localIP = ip;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LocalIP', ip);
  }

  static setInternetIP(ip) async {
    internetIP = ip;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('InternetIP', ip);
  }

  static setNetworkMode(mode) async {
    networkMode = mode;
    (mode == 1) ? timeOut = 5 : timeOut = 7;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('NetworkMode', mode);
    prefs.setInt('TIMEOUT', timeOut);
  }

  static showSnack({required String msg, required Color color}) {
    ScaffoldMessenger.of(myContext)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  static setSizeScreen(context) {
    widthScreen = MediaQuery.of(context).size.width;
    heightScreen = MediaQuery.of(context).size.height;
    isLandscape = widthScreen > heightScreen;
    isPortrait = !isLandscape;
    heightmyAppBar = heightScreen * 0.2;
  }

  static Widget _drawerButton(
      {required String text,
      required IconData icon,
      required Color? color,
      required onTap}) {
    return InkWell(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            margin: EdgeInsets.symmetric(
                horizontal: min(heightScreen, widthScreen) / 14, vertical: 4),
            decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Ink(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, color: Colors.black, size: 26),
              const SizedBox(width: 10),
              Text(text,
                  style: GoogleFonts.laila(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold))
            ]))));
  }

  static Drawer myDrawer(context, {Color? color}) {
    return Drawer(
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
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text("Hi",
                                    style: GoogleFonts.donegalOne(
                                        color: Colors.indigoAccent,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold))),
                            Center(
                                child: Wrap(children: [
                              Text(
                                  currentUser!.isAdmin
                                      ? "Administrateur"
                                      : currentUser!.parentName,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.laila(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold))
                            ]))
                          ])),
                  const Divider(height: 30),
                  Expanded(
                      child:
                          ListView(shrinkWrap: true, primary: false, children: [
                    Visibility(
                        visible: currentUser!.isAdmin,
                        child: _drawerButton(
                            color: Colors.blueGrey.shade50,
                            icon: Icons.person_outline_sharp,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              var route = MaterialPageRoute(
                                  builder: (context) => const ListEnfant());
                              Navigator.of(context).push(route);
                            },
                            text: "Liste des Enfants")),
                    Visibility(
                        visible: currentUser!.isAdmin,
                        child: _drawerButton(
                            color: Colors.amber.shade50,
                            icon: Icons.group_outlined,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("ListParents");
                            },
                            text: "Liste des Parents")),
                    Visibility(
                        visible: currentUser!.isAdmin,
                        child: _drawerButton(
                            color: Colors.cyan.shade50,
                            icon: Icons.groups_outlined,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("ListGroupes");
                            },
                            text: "Liste des Groupes")),
                    Visibility(
                        visible: currentUser!.isAdmin,
                        child: _drawerButton(
                            color: Colors.brown.shade50,
                            icon: Icons.person_pin_outlined,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed("ListEnseignants");
                            },
                            text: "Liste des Enseigants")),
                    Visibility(
                        visible: currentUser!.isAdmin, child: const Divider()),
                    Visibility(
                        visible: !currentUser!.isEns,
                        child: _drawerButton(
                            color: Colors.indigo.shade50,
                            icon: Icons.announcement_outlined,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("ListAnnonces");
                            },
                            text: "Liste des Annonces")),
                    _drawerButton(
                        color: Colors.green.shade50,
                        icon: Icons.sms,
                        onTap: () {
                          canPop = true;
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("ListMessages");
                        },
                        text: "Liste des Messages"),
                    _drawerButton(
                        color: Colors.black12,
                        icon: Icons.photo,
                        onTap: () {
                          canPop = true;
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed("ListPhotos");
                        },
                        text: "Gallerie des Photos"),
                    Visibility(visible: !production, child: const Divider()),
                    Visibility(
                        visible: currentUser!.isAdmin,
                        child: _drawerButton(
                            color: Colors.blue.shade50,
                            icon: Icons.settings,
                            onTap: () {
                              Navigator.pop(context);
                              reparerBDD();
                            },
                            text: "Réparer La BDD")),
                    Visibility(
                        visible: !production,
                        child: _drawerButton(
                            color: Colors.blue.shade50,
                            icon: Icons.settings,
                            onTap: () {
                              canPop = true;
                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed("setting");
                            },
                            text: "Paramêtres")),
                    _drawerButton(
                        color: Colors.red.shade50,
                        icon: Icons.logout,
                        onTap: _logout,
                        text: "Déconnecter"),
                    Visibility(
                        visible: currentUser!.isParent, child: const Divider()),
                    Visibility(
                        visible: currentUser!.isParent,
                        child: const SizedBox(height: 25)),
                    Visibility(
                        visible: currentUser!.isParent,
                        child: Visibility(
                            visible: _loadingEnfant,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: darkColor[Random()
                                              .nextInt(darkColor.length - 1) +
                                          1]),
                                  const SizedBox(width: 20),
                                  const Text("chargement ...")
                                ]),
                            replacement: Center(
                                child: Text(
                                    _enfants.isEmpty
                                        ? "Aucun Enfant"
                                        : "List des Enfants",
                                    style: GoogleFonts.laila(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.clip)))),
                    Visibility(
                        visible: (!currentUser!.isParent) ||
                            _loadingEnfant ||
                            _enfants.isEmpty,
                        child: Visibility(
                            visible: _errorEnfant,
                            child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white),
                                onPressed: getListEnfant,
                                icon: const FaIcon(FontAwesomeIcons.sync,
                                    color: Colors.white),
                                label: const Text("Actualiser"))),
                        replacement: Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: _enfants.length,
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                          horizontalTitleGap: 4,
                                          title: Text(_enfants[i].fullName,
                                              style: GoogleFonts.laila(
                                                  fontSize: 12),
                                              overflow: TextOverflow.clip),
                                          leading: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                  width: 60,
                                                  child: (_enfants[i].photo ==
                                                          "")
                                                      ? Image.asset(
                                                          "images/noPhoto.png")
                                                      : Image.network(
                                                          getImage(
                                                              _enfants[i].photo,
                                                              "PHOTO/ENFANT"),
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                              child: CircularProgressIndicator(
                                                                  color: darkColor[
                                                                      Random().nextInt(darkColor.length -
                                                                              1) +
                                                                          1]));
                                                        }))));
                                    }))))
                  ]))
                ]))));
  }

  static getListEnfant() async {
    _errorEnfant = false;
    _loadingEnfant = true;
    _enfants.clear();
    String serverDir = getServerDirectory();
    var url = "$serverDir/GET_ENFANT_PARENT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": currentUser!.idParent.toString()})
        .timeout(Duration(seconds: timeOut))
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
                  photo: m['PHOTO'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2));
              _enfants.add(e);
            }
          } else {
            _errorEnfant = true;
            _enfants.clear();
          }
          _loadingEnfant = false;
        })
        .catchError((error) {
          print("erreur : $error");
          _errorEnfant = true;
          _enfants.clear();
          _loadingEnfant = false;
        });
  }

  static getAdminUser() async {
    errorAdmin = false;
    loadingAdmin = true;
    String serverDir = getServerDirectory();
    var url = "$serverDir/GET_ADMIN.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {})
        .timeout(Duration(seconds: timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              adminId = int.parse(m['USER']);
            }
            loadingAdmin = false;
          } else {
            errorAdmin = true;
            loadingAdmin = false;
          }
        })
        .catchError((error) {
          print("erreur : $error");
          errorAdmin = true;
          loadingAdmin = false;
        });
  }

  static makeExternalRequest(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

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
              showSnack(
                  msg: 'La base de données à été réparer ...',
                  color: Colors.green);
            } else {
              AwesomeDialog(
                      context: myContext,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: 'Erreur',
                      desc:
                          "Probleme lors de la réparation de la base de données !!!")
                  .show();
            }
          } else {
            AwesomeDialog(
                    context: myContext,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 5!!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AwesomeDialog(
                  context: myContext,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 6!!!')
              .show();
        });
  }

  static _logout() {
    String alert = '';
    (currentUser!.isEns && GestGalleryImages.myImages.isNotEmpty)
        ? alert =
            '\n Attention tous LES chargement des images seront arrêter ....'
        : alert = '';
    AwesomeDialog(
            context: myContext,
            dialogType: DialogType.QUESTION,
            title: '',
            btnOkText: "Oui",
            btnCancelText: "Non",
            btnCancelOnPress: () {},
            btnOkOnPress: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('LastConnected', false);
              // prefs.setString('LastUser', "");
              // prefs.setString('LastPass', "");
              currentUser = null;
              while (Navigator.of(myContext).canPop()) {
                Navigator.of(myContext).pop();
              }
              Navigator.of(myContext).pushReplacementNamed("login");
            },
            showCloseIcon: true,
            desc: 'Voulez-vous vraiment déconnecter ??' + alert)
        .show();
  }
}
