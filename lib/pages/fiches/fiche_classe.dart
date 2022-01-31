// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FicheClasse extends StatefulWidget {
  final int idGroupe, idEnfant;
  const FicheClasse({Key? key, required this.idGroupe, required this.idEnfant})
      : super(key: key);

  @override
  _FicheClasseState createState() => _FicheClasseState();
}

List<Enfant> allenfants = [];
List<Groupe> allgroupes = [];
List<Groupe> groupes = [];
List<Enfant> enfants = [];

String pNomSel = "";
int pIdSel = 0;

class _FicheClasseState extends State<FicheClasse> {
  late int idEnfant, idGroupe;
  bool loading = true;
  Enfant? enfant;
  Groupe? groupe;

  getListEnfant() async {
    setState(() {
      loading = true;
    });
    enfants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS_GROUPE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": idGroupe.toString(), "WHERE": ""})
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
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              enfants.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              enfants.clear();
              loading = false;
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
            loading = false;
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

  getListGroupe() async {
    setState(() {
      loading = true;
    });
    groupes.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_GROUPE_ENFANT.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
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
              loading = false;
            });
          } else {
            setState(() {
              groupes.clear();
              loading = false;
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

  getListGroupeOfEnfant() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_GROUPES.php";
    String pWhere = "";
    allgroupes.clear();
    for (var item in groupes) {
      pWhere += " AND NOT E.ID_GROUPE = ${item.id}";
    }
    print("groupes.length=${groupes.length}");
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
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
              allgroupes.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allgroupes.clear();
              loading = false;
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
            allgroupes.clear();
            loading = false;
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

  getListEnfantOfGroupe() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS.php";
    String pWhere = "";
    allenfants.clear();
    for (var item in enfants) {
      pWhere += " AND NOT E.ID_ENFANT = ${item.id}";
    }
    print("enfants.length=${enfants.length}");
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
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
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  etat: int.parse(m['ETAT']),
                  photo: m['PHOTO'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2));
              allenfants.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allenfants.clear();
              loading = false;
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
            allenfants.clear();
            loading = false;
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

  getEnfantInfo() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_INFO_ENFANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            late int sexe;
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              enfant = Enfant(
                  adresse: m['ADRESSE'],
                  dateNaiss: m['DATE_NAISS'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  id: idEnfant,
                  isFemme: (sexe == 2),
                  isHomme: (sexe == 1),
                  nom: m['NOM'],
                  etat: int.parse(m['ETAT']),
                  photo: m['PHOTO'],
                  prenom: m['PRENOM'],
                  sexe: sexe);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
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
            loading = false;
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

  getGroupeInfo() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_INFO_GROUPE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_GROUPE": idGroupe.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              groupe = Groupe(
                  designation: m['DESIGNATION'],
                  id: int.parse(m['ID_GROUPE']),
                  etat: int.parse(m['ETAT']));
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              loading = false;
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
            loading = false;
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

  chargerDonnees() {
    if (idEnfant != 0) {
      getEnfantInfo();
      getListGroupe().then((value) {
        getListGroupeOfEnfant();
      });
    } else {
      getGroupeInfo();
      getListEnfant().then((value) {
        getListEnfantOfGroupe();
      });
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    idEnfant = widget.idEnfant;
    idGroupe = widget.idGroupe;
    chargerDonnees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return SafeArea(
        child: Scaffold(
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                centerTitle: true,
                title: const Text("Classe Groupe - Enfant"),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white))),
            body: Padding(
                padding: const EdgeInsets.all(10), child: bodyContent())));
  }

  enfantContent() {
    return Visibility(
        visible: groupes.isEmpty,
        child: const Center(
            child: Text("Aucun Groupe !!!!",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold))),
        replacement: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: groupes.length,
            itemBuilder: (context, i) {
              return Card(
                  elevation: 4,
                  child: ListTile(
                      title: Text(groupes[i].designation,
                          style: GoogleFonts.laila(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip),
                      trailing: GestureDetector(
                          child: const Icon(Icons.delete, color: Colors.red),
                          onTap: () {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    showCloseIcon: true,
                                    title: 'Erreur',
                                    btnOkText: "Oui",
                                    btnCancelText: "Non",
                                    btnOkOnPress: () {
                                      print(
                                          "suppression de la relation ${groupes[i].id},$idEnfant");
                                      deleteClasse(
                                              groupes[i].id, idEnfant, context)
                                          .then((value) {
                                        chargerDonnees();
                                      });
                                    },
                                    btnCancelOnPress: () {},
                                    desc:
                                        'Voulez vraiment supprimer cette relation ?')
                                .show();
                          })));
            }));
  }

  groupeContent() {
    return Visibility(
        visible: enfants.isEmpty,
        child: const Center(
            child: Text("Aucun Enfants !!!!",
                style: TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight: FontWeight.bold))),
        replacement: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: enfants.length,
            itemBuilder: (context, i) {
              return Container(
                  color: enfants[i].isHomme
                      ? Colors.blue.shade100
                      : Colors.pink.shade100,
                  child: ListTile(
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
                                              color: Data.darkColor[Random()
                                                      .nextInt(Data.darkColor
                                                              .length -
                                                          1) +
                                                  1]));
                                    }))),
                      title: Text(enfants[i].fullName,
                          style: GoogleFonts.laila(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip),
                      subtitle: Text(enfants[i].adresse,
                          style: GoogleFonts.laila(
                              fontSize: 12, color: Colors.grey.shade800),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(enfants[i].dateNaiss,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 5),
                        GestureDetector(
                            child: const Icon(Icons.delete, color: Colors.red),
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      showCloseIcon: true,
                                      title: 'Erreur',
                                      btnOkText: "Oui",
                                      btnCancelText: "Non",
                                      btnOkOnPress: () {
                                        print(
                                            "suppression de la relation $idGroupe,${enfants[i].id}");
                                        deleteClasse(idGroupe, enfants[i].id,
                                                context)
                                            .then((value) {
                                          chargerDonnees();
                                        });
                                      },
                                      btnCancelOnPress: () {},
                                      desc:
                                          'Voulez vraiment supprimer cette relation ?')
                                  .show();
                            })
                      ])));
            }));
  }

  Widget circularPhoto() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: showPhoto(), fit: BoxFit.contain)));
  }

  showPhoto() {
    if (enfant!.photo == "") {
      return const AssetImage("images/noPhoto.png");
    } else {
      return NetworkImage(Data.getImage(enfant!.photo, "PHOTO/ENFANT"));
    }
  }

  bodyContent() {
    return loading
        ? Center(
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
              ]))
        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            idEnfant != 0
                ? enfant != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            circularPhoto(),
                            const SizedBox(width: 10),
                            Text(enfant!.fullName,
                                style: GoogleFonts.laila(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip)
                          ])
                    : Container()
                : groupe != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text("Groupe : " + groupe!.designation,
                                style: GoogleFonts.laila(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.clip)
                          ])
                    : Container(),
            const Divider(),
            Row(children: [
              Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                      (idEnfant != 0)
                          ? "Liste des Groupes"
                          : "Liste des Enfants",
                      style: GoogleFonts.adamina(
                          color: Colors.blue.shade700,
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip)),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: () {
                        if (idEnfant != 0) {
                          showModalAjoutGroupe();
                        } else {
                          showModalAjoutEnfant();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Ajouter")))
            ]),
            const Divider(),
            Visibility(
                visible: ((idEnfant != 0 && groupes.isEmpty) ||
                    (idGroupe != 0 && enfants.isEmpty)),
                child: const Spacer()),
            Visibility(
                visible: ((idEnfant != 0 && groupes.isEmpty) ||
                    (idGroupe != 0 && enfants.isEmpty)),
                child: Center(
                    child: Text(
                        "Aucun " +
                            (idEnfant != 0 ? "Groupes" : "Enfant") +
                            " !!!!",
                        style: const TextStyle(
                            fontSize: 22,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)))),
            Visibility(
                visible: ((idEnfant != 0 && groupes.isEmpty) ||
                    (idGroupe != 0 && enfants.isEmpty)),
                child: const Spacer()),
            Visibility(
                visible: ((idEnfant != 0 && groupes.isNotEmpty) ||
                    (idGroupe != 0 && enfants.isNotEmpty)),
                child: Visibility(
                    visible: (idEnfant != 0),
                    child: enfantContent(),
                    replacement: groupeContent()))
          ]);
  }

  showModalAjoutEnfant() async {
    await showDialog(
        context: context,
        builder: (_) => SearchEnfant(idGroupe: idGroupe)).then((value) {
      setState(() {});
    });
  }

  showModalAjoutGroupe() async {
    await showDialog(
        context: context,
        builder: (_) => SearchGroup(idEnfant: idEnfant)).then((value) {
      setState(() {});
    });
  }

  nomSelect() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(((idEnfant != 0) ? "Groupe" : "Enfant") + " Sélectionné : ",
          style: const TextStyle(color: Colors.black)),
      Text(pNomSel,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
    ]);
  }
}

deleteClasse(int idGroupe, int idEnfant, BuildContext context) async {
  String serverDir = Data.getServerDirectory();
  var url = "$serverDir/DELETE_CLASSE.php";
  print(url);
  Uri myUri = Uri.parse(url);
  http
      .post(myUri, body: {
        "ID_ENFANT": idEnfant.toString(),
        "ID_GROUPE": idGroupe.toString()
      })
      .timeout(Duration(seconds: Data.timeOut))
      .then((response) async {
        if (response.statusCode == 200) {
          var result = response.body;
          if (result != "0") {
            Data.showSnack('Classe supprimée ...', Colors.green);
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: "Probleme lors de l'ajout !!!")
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

insertClasse(int idGroupe, int idEnfant, BuildContext context) async {
  String serverDir = Data.getServerDirectory();
  var url = "$serverDir/INSERT_CLASSE.php";
  print(url);
  Uri myUri = Uri.parse(url);
  http
      .post(myUri, body: {
        "ID_ENFANT": idEnfant.toString(),
        "ID_GROUPE": idGroupe.toString()
      })
      .timeout(Duration(seconds: Data.timeOut))
      .then((response) async {
        if (response.statusCode == 200) {
          var responsebody = jsonDecode(response.body);
          int result = int.parse(responsebody);
          if (result == 0) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: "Probleme lors de l'ajout !!!")
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

class SearchEnfant extends StatefulWidget {
  final int idGroupe;
  const SearchEnfant({Key? key, required this.idGroupe}) : super(key: key);

  @override
  _SearchEnfantState createState() => _SearchEnfantState();
}

class _SearchEnfantState extends State<SearchEnfant> {
  late String query;
  late int idGroupe;
  late List<int> indName;
  bool loading = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    query = "";
    idGroupe = widget.idGroupe;
    loading = true;
    getAllEnfants();
    super.initState();
  }

  getAllEnfants() async {
    setState(() {
      loading = true;
      error = false;
    });
    allenfants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
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
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              allenfants.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allenfants.clear();
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
            allenfants.clear();
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

  List<Enfant> filtrerCours() {
    indName = [];
    List<Enfant> list = [];
    for (var item in allenfants) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existEnfant(int id) {
    for (var i = 0; i < enfants.length; i++) {
      if (enfants[i].id == id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Enfant> suggestionList =
        query.isEmpty ? allenfants : filtrerCours();
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: const Text("Selectionner Enfant(s)",
                    style: TextStyle(color: Colors.black)),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black))),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                    visible: loading,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Data.darkColor[
                                Random().nextInt(Data.darkColor.length - 1) +
                                    1])),
                    replacement: Visibility(
                        visible: allenfants.isEmpty,
                        child: Container(
                            color: Colors.white,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(
                                          error
                                              ? "Erreur de connexion !!!"
                                              : "Aucun Enfant !!!!",
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: error
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white),
                                      onPressed: getAllEnfants,
                                      icon: const FaIcon(FontAwesomeIcons.sync,
                                          color: Colors.white),
                                      label: const Text("Actualiser"))
                                ])),
                        replacement: Column(children: [
                          Visibility(
                              visible: enfants.isEmpty,
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      color: Colors.amber,
                                      child: const Text(
                                          "Pas d'enfant sélectionné",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)))),
                              replacement: Wrap(
                                  children: enfants
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .ERROR,
                                                              showCloseIcon:
                                                                  true,
                                                              title: 'Erreur',
                                                              btnOkText: "Oui",
                                                              btnCancelText:
                                                                  "Non",
                                                              btnOkOnPress: () {
                                                                int i = enfants
                                                                    .indexOf(
                                                                        item);
                                                                print(
                                                                    "suppression de la classe $idGroupe,${enfants[i].id}");
                                                                deleteClasse(
                                                                    idGroupe,
                                                                    enfants[i]
                                                                        .id,
                                                                    context);
                                                                setState(() {
                                                                  enfants.removeAt(
                                                                      enfants.indexOf(
                                                                          item));
                                                                });
                                                              },
                                                              btnCancelOnPress:
                                                                  () {},
                                                              desc:
                                                                  'Voulez vraiment supprimer cette relation ?')
                                                          .show();
                                                    },
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red)),
                                                Container(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            item.fullName,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    color: Colors.blue)
                                              ])))
                                      .toList()
                                      .cast<Widget>())),
                          const Divider(),
                          TextFormField(
                              initialValue: query,
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "Recherche",
                                  suffixIcon: const Icon(Icons.clear),
                                  prefixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          query = "";
                                        });
                                      },
                                      child: const Icon(Icons.search)))),
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: suggestionList.length,
                                  itemBuilder: (context, i) => Visibility(
                                      visible:
                                          !existEnfant(suggestionList[i].id),
                                      child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                  onTap: () {
                                                    print(suggestionList[i]
                                                        .fullName);
                                                    if (!existEnfant(
                                                        suggestionList[i].id)) {
                                                      insertClasse(
                                                          idGroupe,
                                                          suggestionList[i].id,
                                                          context);
                                                      setState(() {
                                                        enfants.add(
                                                            suggestionList[i]);
                                                      });
                                                    }
                                                  },
                                                  title: Text(
                                                      suggestionList[i]
                                                          .fullName,
                                                      style: TextStyle(
                                                          color: existEnfant(
                                                                  suggestionList[
                                                                          i]
                                                                      .id)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .black))))))))
                        ]))))));
  }
}

class SearchGroup extends StatefulWidget {
  final int idEnfant;
  const SearchGroup({Key? key, required this.idEnfant}) : super(key: key);

  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  late String query;
  late List<int> indDes;
  late int idEnfant;
  bool loading = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    query = "";
    loading = true;
    idEnfant = widget.idEnfant;
    getAllGroupes();
    super.initState();
  }

  getAllGroupes() async {
    setState(() {
      loading = true;
      error = false;
    });
    allgroupes.clear();
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
              allgroupes.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allgroupes.clear();
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
            allgroupes.clear();
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

  List<Groupe> filtrerCours() {
    indDes = [];
    List<Groupe> list = [];
    for (var item in allgroupes) {
      if (item.designation.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indDes.add(item.designation.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  bool existGroup(int id) {
    for (var i = 0; i < groupes.length; i++) {
      if (groupes[i].id == id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Groupe> suggestionList =
        query.isEmpty ? allgroupes : filtrerCours();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: const Text("Selectionner Groupe(s)",
                    style: TextStyle(color: Colors.black)),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black))),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                    visible: loading,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Data.darkColor[
                                Random().nextInt(Data.darkColor.length - 1) +
                                    1])),
                    replacement: Visibility(
                        visible: allgroupes.isEmpty,
                        child: Container(
                            color: Colors.white,
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
                                              color: error
                                                  ? Colors.red
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold))),
                                  const SizedBox(height: 10),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white),
                                      onPressed: getAllGroupes,
                                      icon: const FaIcon(FontAwesomeIcons.sync,
                                          color: Colors.white),
                                      label: const Text("Actualiser"))
                                ])),
                        replacement: Column(children: [
                          Visibility(
                              visible: groupes.isEmpty,
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      color: Colors.amber,
                                      child: const Text(
                                          "Pas de groupe sélectionné",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)))),
                              replacement: Wrap(
                                  children: groupes
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .ERROR,
                                                              showCloseIcon:
                                                                  true,
                                                              title: 'Erreur',
                                                              btnOkText: "Oui",
                                                              btnCancelText:
                                                                  "Non",
                                                              btnOkOnPress: () {
                                                                int i = groupes
                                                                    .indexOf(
                                                                        item);
                                                                print(
                                                                    "suppression de la relation ${groupes[i].id},$idEnfant");
                                                                deleteClasse(
                                                                    groupes[i]
                                                                        .id,
                                                                    idEnfant,
                                                                    context);
                                                                setState(() {
                                                                  groupes
                                                                      .removeAt(
                                                                          i);
                                                                });
                                                              },
                                                              btnCancelOnPress:
                                                                  () {},
                                                              desc:
                                                                  'Voulez vraiment supprimer cette relation ?')
                                                          .show();
                                                    },
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red)),
                                                Container(
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            item.designation,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                    color: Colors.blue)
                                              ])))
                                      .toList()
                                      .cast<Widget>())),
                          const Divider(),
                          TextFormField(
                              initialValue: query,
                              onChanged: (value) {
                                setState(() {
                                  query = value;
                                });
                              },
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "Recherche",
                                  suffixIcon: const Icon(Icons.clear),
                                  prefixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          query = "";
                                        });
                                      },
                                      child: const Icon(Icons.search)))),
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: suggestionList.length,
                                  itemBuilder: (context, i) => Visibility(
                                      visible:
                                          !existGroup(suggestionList[i].id),
                                      child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                  onTap: () {
                                                    print(suggestionList[i]
                                                        .designation);
                                                    if (!existGroup(
                                                        suggestionList[i].id)) {
                                                      insertClasse(
                                                          suggestionList[i].id,
                                                          idEnfant,
                                                          context);
                                                      setState(() {
                                                        groupes.add(
                                                            suggestionList[i]);
                                                      });
                                                    }
                                                  },
                                                  title: Text(
                                                      suggestionList[i]
                                                          .designation,
                                                      style: TextStyle(
                                                          color: existGroup(
                                                                  suggestionList[
                                                                          i]
                                                                      .id)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .black))))))))
                        ]))))));
  }
}
