// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/pages/fiches/fiche_classe.dart';
import 'package:atlas_school/pages/fiches/fiche_groupe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoGroupe extends StatefulWidget {
  final Groupe groupe;
  const InfoGroupe({Key? key, required this.groupe}) : super(key: key);

  @override
  _InfoGroupeState createState() => _InfoGroupeState();
}

class _InfoGroupeState extends State<InfoGroupe> {
  late Groupe groupe;
  List<Enfant> enfants = [];
  bool loadingEnfant = true;

  getListEnfant() async {
    setState(() {
      loadingEnfant = true;
    });
    enfants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS_GROUPE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": groupe.id.toString(), "WHERE": ""})
        .timeout(Duration(seconds: Data.timeOut))
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
              enfants.add(e);
            }
            setState(() {
              loadingEnfant = false;
            });
          } else {
            setState(() {
              enfants.clear();
              loadingEnfant = false;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            enfants.clear();
            loadingEnfant = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur !!!')
              .show();
        });
  }

  deleteGroupe() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/DELETE_GROUPE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": groupe.id.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Data.showSnack('Groupe supprimé ...', Colors.green);
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
                    desc: 'Probleme de Connexion avec le serveur !!!')
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
                  desc: 'Probleme de Connexion avec le serveur !!!')
              .show();
        });
  }

  listGroupeEnfant() {
    if (enfants.isEmpty) {
      return Column(children: [
        const Divider(),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.warning, color: Colors.amber),
          const SizedBox(width: 10),
          Text("Aucun Enfant !!!",
              textAlign: TextAlign.center,
              style: GoogleFonts.laila(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip)
        ])
      ]);
    } else {
      return Column(children: [
        const Divider(),
        Text("Liste des Enfants (" + enfants.length.toString() + " enfants)",
            textAlign: TextAlign.center,
            style: GoogleFonts.laila(
                decoration: TextDecoration.underline,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip),
        ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: enfants.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => ListTile(
                horizontalTitleGap: 4,
                leading: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                        width: 60,
                        child: (enfants[i].photo == "")
                            ? Image.asset("images/noPhoto.png")
                            : Image.network(
                                Data.getImage(enfants[i].photo, "PHOTO/ENFANT"),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Data.darkColor[Random().nextInt(
                                                Data.darkColor.length - 1) +
                                            1]));
                              }))),
                title: Text(enfants[i].fullName,
                    style: GoogleFonts.laila(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.clip)))
      ]);
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    groupe = widget.groupe;
    loadingEnfant = true;
    getListEnfant();
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
            builder: (_, controller) => Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25))),
                padding: const EdgeInsets.all(10),
                child: loadingEnfant
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const Text("Chargement en cours ..."),
                            const SizedBox(width: 10),
                            CircularProgressIndicator(
                                color: Data.darkColor[Random()
                                        .nextInt(Data.darkColor.length - 1) +
                                    1])
                          ])
                    : ListView(controller: controller, children: [
                        Text(groupe.designation.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.laila(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.clip),
                        listGroupeEnfant(),
                        const Divider(),
                        Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  onPrimary: Colors.white),
                              onPressed: () {
                                var route = MaterialPageRoute(
                                    builder: (context) =>
                                        FicheGroupe(id: groupe.id));
                                Navigator.of(context).push(route).then((value) {
                                  Navigator.of(context).pop();
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text("Infos")),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueGrey,
                                  onPrimary: Colors.white),
                              onPressed: () {
                                var route = MaterialPageRoute(
                                    builder: (context) => FicheClasse(
                                        idEnfant: 0, idGroupe: groupe.id));
                                Navigator.of(context).push(route).then((value) {
                                  Navigator.of(context).pop();
                                });
                              },
                              icon: const Icon(Icons.person_outline_sharp),
                              label: const Text("Enfants")),
                          Visibility(
                              visible: enfants.isEmpty,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      onPrimary: Colors.white),
                                  onPressed: () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.QUESTION,
                                            showCloseIcon: true,
                                            title: 'Confirmation',
                                            btnOkText: "Oui",
                                            btnCancelText: "Non",
                                            btnOkOnPress: deleteGroupe,
                                            btnCancelOnPress: () {
                                              Navigator.of(context).pop();
                                            },
                                            desc:
                                                'Voulez vraiment supprimer cet groupe ?')
                                        .show();
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Supprimer")))
                        ])
                      ]))));
  }
}
