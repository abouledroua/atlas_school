// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enseignant.dart';
import 'package:atlas_school/classes/fetch.dart';
import 'package:atlas_school/classes/parent.dart';
import 'package:atlas_school/classes/personne.dart';
import 'package:atlas_school/pages/fiches/fiche_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  _ListMessagesState createState() => _ListMessagesState();
}

List<Personne> personnes = [];

class _ListMessagesState extends State<ListMessages> {
  bool loading = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    loading = true;
    getListMessages();
    Fetch.newMessage = false;
    listenNewMessages();
    super.initState();
  }

  listenNewMessages() async {
    while (true) {
      if (!Fetch.newMessage) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        Fetch.newMessage = false;
        getListMessages();
      }
    }
  }

  getListMessages() async {
    setState(() {
      loading = true;
      error = false;
    });
    personnes.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_LIST_MESSAGES.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_USER": Data.currentUser!.idUser.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Personne e;
            String? s;
            late bool vu;
            for (var m in responsebody) {
              s = m['VU'];
              vu = (s == null);
              e = Personne(
                  name: m['NAME'],
                  newMsg: vu,
                  lastMsg: m['MSG'],
                  isAdmin: int.parse(m['ISADMIN']) == 1,
                  date: DateTime.parse(m['DATEMSG']),
                  idUser: int.parse(m['USER']),
                  idParent: int.parse(m['PARENT']));
              personnes.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              personnes.clear();
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
            personnes.clear();
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
    return SafeArea(
        child: Scaffold(
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                backgroundColor: Colors.green.shade700,
                centerTitle: true,
                titleSpacing: 0,
                title: const Center(child: Text("Liste des Messages")),
                leading: (Data.canPop)
                    ? IconButton(
                        onPressed: () {
                          Data.canPop = false;
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white))
                    : null,
                actions: [
                  IconButton(
                      onPressed: () {
                        getListMessages();
                      },
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white))
                ]),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green.shade600,
                onPressed: Data.currentUser!.isAdmin ? newMessage : null,
                child: const Icon(Icons.add)),
            body: bodyContent()));
  }

  bodyContent() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
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
                              Random().nextInt(Data.darkColor.length - 1) +
                                  1])),
                  const Text("Chargement en cours ...")
                ])),
            replacement: Visibility(
                visible: personnes.isEmpty,
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
                                      : "Aucun Message !!!!",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: error ? Colors.red : Colors.green,
                                      fontWeight: FontWeight.bold))),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  onPrimary: Colors.white),
                              onPressed: getListMessages,
                              icon: const FaIcon(FontAwesomeIcons.sync,
                                  color: Colors.white),
                              label: const Text("Actualiser"))
                        ])),
                replacement: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: personnes.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (context) => FicheMessage(
                                    idUser: personnes[i].idUser,
                                    parentName: personnes[i].name));
                            Navigator.of(context).push(route).then((value) {
                              getListMessages();
                            });
                          },
                          child: Container(
                              color: personnes[i].newMsg
                                  ? Colors.grey.shade400
                                  : Colors.transparent,
                              child: listTile(i)));
                    }))));
  }

  newMessage() async {
    print("new message");
    showModalBottomSheet(
        context: context,
        builder: (context) => SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Envoyer le message vers : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                            onTap: () async {
                              await showDialog(
                                      context: context,
                                      builder: (_) => const SearchParent())
                                  .then((value) {
                                setState(() {
                                  getListMessages();
                                  Navigator.pop(context);
                                });
                              });
                            },
                            child: Row(children: const [
                              Icon(Icons.group_outlined),
                              SizedBox(width: 10),
                              Text("Parent", style: TextStyle(fontSize: 20))
                            ])),
                        InkWell(
                            onTap: () async {
                              await showDialog(
                                      context: context,
                                      builder: (_) => const SearchEnseignant())
                                  .then((value) {
                                setState(() {
                                  getListMessages();
                                  Navigator.pop(context);
                                });
                              });
                            },
                            child: Row(children: const [
                              Icon(Icons.person_pin_outlined),
                              SizedBox(width: 10),
                              Text("Enseignant", style: TextStyle(fontSize: 20))
                            ]))
                      ])
                ]))));
  }

  iconName(letter) {
    int i = Random().nextInt(4) + 1;
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Data.darkColor[
                      Random().nextInt(Data.darkColor.length - 1) + 1],
                  Data.darkColor[
                      Random().nextInt(Data.darkColor.length - 1) + 1],
                  Data.darkColor[
                      Random().nextInt(Data.darkColor.length - 1) + 1],
                  Data.darkColor[
                      Random().nextInt(Data.darkColor.length - 1) + 1],
                ],
                begin: (i == 1)
                    ? Alignment.topLeft
                    : (i == 2)
                        ? Alignment.bottomRight
                        : (i == 3)
                            ? Alignment.topCenter
                            : Alignment.centerRight,
                end: (i == 1)
                    ? Alignment.bottomRight
                    : (i == 2)
                        ? Alignment.topLeft
                        : (i == 3)
                            ? Alignment.bottomLeft
                            : Alignment.topLeft),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(letter,
                style:
                    GoogleFonts.adamina(fontSize: 16, color: Colors.white))));
  }

  listTile(int i) {
    return ListTile(
        title: Text(personnes[i].name,
            style:
                GoogleFonts.adamina(fontSize: 14, fontWeight: FontWeight.bold)),
        leading: personnes[i].isAdmin
            ? const Icon(Icons.admin_panel_settings_outlined,
                size: 40, color: Colors.blue)
            : iconName(personnes[i].name.isEmpty
                ? ""
                : personnes[i].name.substring(0, 1)),
        subtitle: Text(personnes[i].lastMsg,
            maxLines: 1, style: GoogleFonts.adamina(fontSize: 11)),
        trailing: Text(Data.printDate(personnes[i].date),
            style: const TextStyle(fontSize: 13)));
  }
}

List<Parent> allparents = [];

class SearchParent extends StatefulWidget {
  const SearchParent({Key? key}) : super(key: key);

  @override
  _SearchParentState createState() => _SearchParentState();
}

class _SearchParentState extends State<SearchParent> {
  late String query;
  late List<int> indName;
  bool loading = true, error = false;

  @override
  void initState() {
    query = "";
    loading = true;
    getAllParents();
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    super.initState();
  }

  getAllParents() async {
    setState(() {
      loading = true;
      error = false;
    });
    allparents.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_PARENTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Parent p;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              p = Parent(
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
              allparents.add(p);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allparents.clear();
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
            allparents.clear();
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

  List<Parent> filtrerCours() {
    indName = [];
    List<Parent> list = [];
    for (var item in allparents) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Parent> suggestionList =
        query.isEmpty ? allparents : filtrerCours();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: const Text("Selectionner Parent(s)",
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
                        visible: allparents.isEmpty,
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
                                              : "Aucun Parent !!!!",
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
                                      onPressed: getAllParents,
                                      icon: const FaIcon(FontAwesomeIcons.sync,
                                          color: Colors.white),
                                      label: const Text("Actualiser"))
                                ])),
                        replacement: Column(children: [
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
                                  itemBuilder: (context, i) => Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                              onTap: () {
                                                print(
                                                    suggestionList[i].fullName);
                                                var route = MaterialPageRoute(
                                                    builder: (context) =>
                                                        FicheMessage(
                                                            idUser:
                                                                suggestionList[
                                                                        i]
                                                                    .idUser,
                                                            parentName:
                                                                suggestionList[
                                                                        i]
                                                                    .fullName));
                                                Navigator.of(context)
                                                    .push(route)
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              title: Text(
                                                  suggestionList[i].fullName,
                                                  style: const TextStyle(
                                                      color: Colors.black)))))))
                        ]))))));
  }
}

List<Enseignant> allEnseignants = [];

class SearchEnseignant extends StatefulWidget {
  const SearchEnseignant({Key? key}) : super(key: key);

  @override
  _SearchEnseignantState createState() => _SearchEnseignantState();
}

class _SearchEnseignantState extends State<SearchEnseignant> {
  late String query;
  late List<int> indName;
  bool loading = true, error = false;

  @override
  void initState() {
    query = "";
    loading = true;
    getAllEnseignants();
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    super.initState();
  }

  getAllEnseignants() async {
    setState(() {
      loading = true;
      error = false;
    });
    allEnseignants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENSEIGNANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Enseignant p;
            late int sexe;
            for (var m in responsebody) {
              sexe = int.parse(m['SEXE']);
              p = Enseignant(
                  nom: m['NOM'],
                  prenom: m['PRENOM'],
                  fullName: m['NOM'] + "  " + m['PRENOM'],
                  dateNaiss: m['DATE_NAISS'],
                  id: int.parse(m['ID_ENSEIGNANT']),
                  idUser: int.parse(m['ID_USER']),
                  etat: int.parse(m['ETAT']),
                  userName: m['USERNAME'],
                  password: m['PASSWORD'],
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  matiere: m['MATIERE'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  tel1: m['TEL1']);
              allEnseignants.add(p);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              allEnseignants.clear();
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
            allEnseignants.clear();
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

  List<Enseignant> filtrerCours() {
    indName = [];
    List<Enseignant> list = [];
    for (var item in allEnseignants) {
      if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
        list.add(item);
        indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final List<Enseignant> suggestionList =
        query.isEmpty ? allEnseignants : filtrerCours();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.white,
                title: const Text("Selectionner Enseignant(s)",
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
                        visible: allEnseignants.isEmpty,
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
                                              : "Aucun Enseignant !!!!",
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
                                      onPressed: getAllEnseignants,
                                      icon: const FaIcon(FontAwesomeIcons.sync,
                                          color: Colors.white),
                                      label: const Text("Actualiser"))
                                ])),
                        replacement: Column(children: [
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
                                  itemBuilder: (context, i) => Card(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                              onTap: () {
                                                print(
                                                    suggestionList[i].fullName);
                                                var route = MaterialPageRoute(
                                                    builder: (context) =>
                                                        FicheMessage(
                                                            idUser:
                                                                suggestionList[
                                                                        i]
                                                                    .idUser,
                                                            parentName:
                                                                suggestionList[
                                                                        i]
                                                                    .fullName));
                                                Navigator.of(context)
                                                    .push(route)
                                                    .then((value) {
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              title: Text(
                                                  suggestionList[i].fullName,
                                                  style: const TextStyle(
                                                      color: Colors.black)))))))
                        ]))))));
  }
}
