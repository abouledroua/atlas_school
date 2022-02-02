// ignore_for_file: avoid_print

import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enseignant.dart';
import 'package:atlas_school/pages/fiches/fiche_enseignant.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:atlas_school/pages/fiches/fiche_relation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoEnseignant extends StatefulWidget {
  final Enseignant enseignant;
  const InfoEnseignant({Key? key, required this.enseignant}) : super(key: key);

  @override
  _InfoEnfantState createState() => _InfoEnfantState();
}

class _InfoEnfantState extends State<InfoEnseignant> {
  late Enseignant enseignant;

  deleteEnseignant() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/DELETE_ENSEIGNANT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_ENSEIGNANT": enseignant.id.toString(),
          "ID_USER": enseignant.idUser.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Data.showSnack(
                  msg: 'Enseignant supprimé ...', color: Colors.green);
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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    enseignant = widget.enseignant;
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
                child: ListView(controller: controller, children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(enseignant.fullName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.laila(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.clip),
                  ),
                  Visibility(
                      visible: enseignant.dateNaiss.isNotEmpty,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(children: [
                            const Icon(Icons.date_range_rounded),
                            const SizedBox(width: 20),
                            Text(enseignant.dateNaiss + " ("),
                            Text(
                                enseignant.dateNaiss.isEmpty
                                    ? ""
                                    : Data.calculateAge(
                                        DateTime.parse(enseignant.dateNaiss)),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Text(" )")
                          ]))),
                  Visibility(
                      visible: (enseignant.adresse != ""),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(children: [
                            const Icon(Icons.gps_fixed),
                            const SizedBox(width: 20),
                            Text(enseignant.adresse)
                          ]))),
                  Visibility(
                      visible: (enseignant.tel1 != ""),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 20),
                            Text(enseignant.tel1)
                          ]))),
                  Visibility(
                      visible: (enseignant.matiere != ""),
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(children: [
                            const Icon(Icons.book),
                            const SizedBox(width: 20),
                            Text(enseignant.matiere)
                          ]))),
                  const Divider(),
                  Visibility(
                      visible: (enseignant.userName != ""),
                      child: Row(children: [
                        const Icon(Icons.verified_user),
                        const SizedBox(width: 20),
                        Text(enseignant.userName)
                      ])),
                  Visibility(
                      visible: (enseignant.password != ""),
                      child: Row(children: [
                        const Icon(Icons.password),
                        const SizedBox(width: 20),
                        Text(enseignant.password)
                      ])),
                  const Divider(),
                  Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green, onPrimary: Colors.white),
                        onPressed: () {
                          Data.updList = true;
                          var route = MaterialPageRoute(
                              builder: (context) =>
                                  FicheEnseignant(id: enseignant.id));
                          Navigator.of(context).push(route).then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Infos")),
                    Visibility(
                        visible: enfants.isEmpty,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.red, onPrimary: Colors.white),
                            onPressed: () {
                              Data.updList = true;
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.QUESTION,
                                      showCloseIcon: true,
                                      title: 'Confirmation',
                                      btnOkText: "Oui",
                                      btnCancelText: "Non",
                                      btnOkOnPress: deleteEnseignant,
                                      btnCancelOnPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      desc:
                                          'Voulez vraiment supprimer cet enseignant ? \n Attention tous les messages de ce enseignant seront supprimés !!!!')
                                  .show();
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Supprimer")))
                  ])
                ]))));
  }
}
