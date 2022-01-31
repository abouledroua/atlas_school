// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/pages/fiches/fiche_groupe.dart';
import 'package:atlas_school/pages/widgets/widget_info_groupe.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListGroupes extends StatefulWidget {
  const ListGroupes({Key? key}) : super(key: key);

  @override
  _ListGroupesState createState() => _ListGroupesState();
}

List<Groupe> groupes = [];

class _ListGroupesState extends State<ListGroupes> {
  bool loading = true, loadingParent = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    loading = true;
    getGroupes();
    super.initState();
  }

  getGroupes() async {
    setState(() {
      loading = true;
      error = false;
    });
    groupes.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Groupe e;
            for (var m in responsebody) {
              e = Groupe(
                  designation: m['DESIGNATION'],
                  etat: int.parse(m['ETAT']),
                  id: int.parse(m['ID_GROUPE']));
              groupes.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              groupes.clear();
              loading = false;
              error = true;
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
            groupes.clear();
            loading = false;
            error = true;
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

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return SafeArea(
        child: Scaffold(
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                backgroundColor: Colors.cyan,
                centerTitle: true,
                titleSpacing: 0,
                title: const Center(child: Text("Liste des Groupes")),
                actions: [
                  IconButton(
                      onPressed: () {
                        getGroupes();
                      },
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white))
                ],
                leading: (Data.canPop)
                    ? IconButton(
                        onPressed: () {
                          Data.canPop = false;
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white))
                    : null),
            floatingActionButton: FloatingActionButton(
                heroTag: "btn5",
                backgroundColor: Colors.cyan,
                onPressed: btnInsert,
                child: const Icon(Icons.add)),
            body: bodyContent()));
  }

  btnInsert() {
    var route =
        MaterialPageRoute(builder: (context) => const FicheGroupe(id: 0));
    Navigator.of(context).push(route).then((value) {
      getGroupes();
    });
  }

  _showModal(int ind) async {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return InfoGroupe(groupe: groupes[ind]);
        }).then((value) {
      getGroupes();
    });
  }

  bodyContent() {
    return Visibility(
        visible: loading,
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(
                      color: Data.darkColor[
                          Random().nextInt(Data.darkColor.length - 1) + 1])),
              const Text("Chargement en cours ...")
            ])),
        replacement: Visibility(
            visible: groupes.isEmpty,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                          error
                              ? "Erreur de connexion !!!"
                              : "Aucun Groupe !!!!",
                          style: TextStyle(
                              fontSize: 22,
                              color: error ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: getGroupes,
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white),
                      label: const Text("Actualiser"))
                ]),
            replacement: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                primary: false,
                shrinkWrap: true,
                itemCount: groupes.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      onTap: () {
                        _showModal(i);
                      },
                      child: Container(
                          color: groupes[i].etat == 1
                              ? Colors.transparent
                              : Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 6.0),
                          child: Card(
                              child: ListTile(
                                  horizontalTitleGap: 4,
                                  leading: Text((i + 1).toString(),
                                      style: GoogleFonts.laila(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip),
                                  title: Text(groupes[i].designation,
                                      style: GoogleFonts.laila(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip)))));
                })));
  }
}
