// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/parent.dart';
import 'package:atlas_school/pages/fiches/fiche_classe.dart';
import 'package:atlas_school/pages/fiches/fiche_enfants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:atlas_school/pages/fiches/fiche_relation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoEnfant extends StatefulWidget {
  final Enfant enfants;
  const InfoEnfant({Key? key, required this.enfants}) : super(key: key);

  @override
  _InfoEnfantState createState() => _InfoEnfantState();
}

class _InfoEnfantState extends State<InfoEnfant> {
  late Enfant enfants;
  List<Parent> parents = [];
  List<Groupe> groupes = [];
  bool loadingParent = true, loadingGroupe = true;

  getListParent() async {
    setState(() {
      loadingParent = true;
    });
    parents.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_PARENT_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfants.id.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Parent e;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              e = Parent(
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
              parents.add(e);
            }
            setState(() {
              loadingParent = false;
            });
          } else {
            setState(() {
              parents.clear();
              loadingParent = false;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 1!!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            parents.clear();
            loadingParent = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 2!!!')
              .show();
        });
  }

  getListGroupe() async {
    setState(() {
      loadingGroupe = true;
    });
    groupes.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_GROUPE_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfants.id.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Groupe e;
            for (var m in responsebody) {
              e = Groupe(
                  designation: m['DESIGNATION'],
                  id: int.parse(m['ID_GROUPE']),
                  etat: int.parse(m['ETAT']));
              groupes.add(e);
            }
            setState(() {
              loadingGroupe = false;
            });
          } else {
            setState(() {
              groupes.clear();
              loadingGroupe = false;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 3!!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            groupes.clear();
            loadingGroupe = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 4!!!')
              .show();
        });
  }

  deleteEnfant() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/DELETE_ENFANT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": enfants.id.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Data.showSnack(msg: 'Enfant supprimé ...', color: Colors.green);
              Navigator.of(context).pop();
            } else {
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      showCloseIcon: true,
                      title: 'Erreur',
                      desc: "Probleme lors de la suppression !!!")
                  .show();
            }
          } else {
            AwesomeDialog(
                    context: context,
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
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 6!!!')
              .show();
        });
  }

  listEnfantParent() {
    if (parents.isEmpty) {
      return Container(
          color: Colors.green.shade50,
          child: Column(children: [
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.warning, color: Colors.amber),
              const SizedBox(width: 10),
              Text("Aucun Parent !!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.laila(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip)
            ])
          ]));
    } else {
      return Container(
          color: Colors.green.shade50,
          child: Column(children: [
            const Divider(),
            Text("Liste des Parents ",
                textAlign: TextAlign.center,
                style: GoogleFonts.laila(
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: parents.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => ListTile(
                    horizontalTitleGap: 4,
                    title: Text(parents[i].fullName,
                        style: GoogleFonts.laila(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip),
                    trailing: Column(children: [
                      (parents[i].tel1 != "")
                          ? GestureDetector(
                              onTap: () {
                                Data.makeExternalRequest(
                                    'tel:${parents[i].tel1}');
                              },
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(parents[i].tel1,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 11)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.call, color: Colors.green)
                                  ]))
                          : const SizedBox(width: 0, height: 0),
                      (parents[i].tel2 != "")
                          ? GestureDetector(
                              onTap: () {
                                Data.makeExternalRequest(
                                    'tel:${parents[i].tel2}');
                              },
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(parents[i].tel2,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 11)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.call, color: Colors.green)
                                  ]))
                          : const SizedBox(width: 0, height: 0)
                    ])))
          ]));
    }
  }

  listEnfantGroupe() {
    if (groupes.isEmpty) {
      return Container(
          color: Colors.amber.shade50,
          child: Column(children: [
            const Divider(),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.warning, color: Colors.amber),
              const SizedBox(width: 10),
              Text("Aucun Groupe !!!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.laila(
                      decoration: TextDecoration.underline,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip)
            ])
          ]));
    } else {
      return Container(
          color: Colors.amber.shade50,
          child: Column(children: [
            const Divider(),
            Text("Inscrit dans le groupe ",
                textAlign: TextAlign.center,
                style: GoogleFonts.laila(
                    decoration: TextDecoration.underline,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: groupes.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) => ListTile(
                    horizontalTitleGap: 4,
                    leading: Text((i + 1).toString(),
                        style: GoogleFonts.laila(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip),
                    title: Text(groupes[i].designation,
                        style: GoogleFonts.laila(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip)))
          ]));
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    enfants = widget.enfants;
    loadingParent = true;
    getListParent();
    getListGroupe();
    super.initState();
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child));

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
        child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.9,
            builder: (_, controller) => SafeArea(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(25))),
                      padding: const EdgeInsets.all(10),
                      child: loadingParent
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  const Text("Chargement en cours ..."),
                                  const SizedBox(width: 10),
                                  CircularProgressIndicator(
                                      color: Data.darkColor[Random()
                                          .nextInt(Data.darkColor.length)])
                                ])
                          : ListView(controller: controller, children: [
                              Text(enfants.fullName.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.laila(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip),
                              circularPhoto(),
                              Row(children: [
                                const Icon(Icons.date_range_rounded),
                                const SizedBox(width: 20),
                                Text(enfants.dateNaiss + " ("),
                                Text(
                                    Data.calculateAge(
                                        DateTime.parse(enfants.dateNaiss)),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text(" )")
                              ]),
                              Visibility(
                                  visible: (enfants.adresse != ""),
                                  child: Row(children: [
                                    const Icon(Icons.gps_fixed),
                                    const SizedBox(width: 20),
                                    Text(enfants.adresse)
                                  ])),
                              listEnfantParent(),
                              const Divider(),
                              listEnfantGroupe(),
                              const Divider(),
                              Wrap(
                                  alignment: WrapAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.green,
                                            onPrimary: Colors.white),
                                        onPressed: () {
                                          Data.updList = true;
                                          var route = MaterialPageRoute(
                                              builder: (context) =>
                                                  FicheEnfant(id: enfants.id));
                                          Navigator.of(context)
                                              .push(route)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: const Icon(Icons.edit),
                                        label: const Text("Infos")),
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.amber,
                                            onPrimary: Colors.white),
                                        onPressed: () {
                                          Data.updList = true;
                                          var route = MaterialPageRoute(
                                              builder: (context) =>
                                                  FicheRelation(
                                                      idEnfant: enfants.id,
                                                      idParent: 0));
                                          Navigator.of(context)
                                              .push(route)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: const Icon(Icons.group_outlined),
                                        label: const Text("Parents")),
                                    ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.cyan,
                                            onPrimary: Colors.white),
                                        onPressed: () {
                                          Data.updList = true;
                                          var route = MaterialPageRoute(
                                              builder: (context) => FicheClasse(
                                                  idEnfant: enfants.id,
                                                  idGroupe: 0));
                                          Navigator.of(context)
                                              .push(route)
                                              .then((value) {
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        icon: const Icon(Icons.groups_outlined),
                                        label: const Text("Groupes")),
                                    Visibility(
                                        visible: parents.isEmpty,
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.red,
                                                onPrimary: Colors.white),
                                            onPressed: () {
                                              Data.updList = true;
                                              AwesomeDialog(
                                                      context: context,
                                                      dialogType:
                                                          DialogType.QUESTION,
                                                      showCloseIcon: true,
                                                      title: 'Confirmation',
                                                      btnOkText: "Oui",
                                                      btnCancelText: "Non",
                                                      btnOkOnPress:
                                                          deleteEnfant,
                                                      btnCancelOnPress: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      desc:
                                                          'Voulez vraiment supprimer cet enfant ?')
                                                  .show();
                                            },
                                            icon: const Icon(Icons.delete),
                                            label: const Text("Supprimer")))
                                  ])
                            ])),
                )));
  }

  Widget circularPhoto() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: showPhoto(), fit: BoxFit.contain)));
  }

  showPhoto() {
    if (enfants.photo == "") {
      return const AssetImage("images/noPhoto.png");
    } else {
      return NetworkImage(Data.getImage(enfants.photo, "PHOTO/ENFANT"));
    }
  }
}
