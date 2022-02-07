// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enseignant.dart';
import 'package:atlas_school/pages/fiches/fiche_enseignant.dart';
import 'package:atlas_school/pages/widgets/widget_info_enseignant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:azlistview/azlistview.dart';

List<Enseignant> enseignants = [];
String query = "";

class ListEnseignant extends StatefulWidget {
  const ListEnseignant({Key? key}) : super(key: key);

  @override
  _ListEnseignantState createState() => _ListEnseignantState();
}

class _ListEnseignantState extends State<ListEnseignant> {
  bool loading = true, loadingEnfant = true, error = false, searching = false;

  getEnseignants() async {
    setState(() {
      loading = true;
      error = false;
    });
    enseignants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENSEIGNANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {'WHERE': ""})
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
              enseignants.add(p);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              enseignants.clear();
              loading = false;
              error = true;
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
            enseignants.clear();
            loading = false;
            error = true;
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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    loading = true;
    getEnseignants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return SafeArea(
        child: Scaffold(
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                backgroundColor: Colors.brown,
                centerTitle: true,
                titleSpacing: 5,
                title: const FittedBox(child: Text("Liste des Enseignants")),
                actions: [
                  IconButton(
                      onPressed: () {
                        getEnseignants();
                      },
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white)),
                  IconButton(
                      onPressed: () {
                        if (searching) {
                          query = "";
                        }
                        setState(() {
                          searching = !searching;
                        });
                      },
                      icon: const FaIcon(FontAwesomeIcons.search,
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
              heroTag: "btn4",
              backgroundColor: Colors.brown,
              onPressed: btnInsert,
              child: const Icon(Icons.add),
            ),
            body: bodyContent()));
  }

  btnInsert() {
    var route =
        MaterialPageRoute(builder: (context) => const FicheEnseignant(id: 0));
    Navigator.of(context).push(route).then((value) {
      getEnseignants();
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
            visible: enseignants.isEmpty,
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
                              color: error ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: getEnseignants,
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white),
                      label: const Text("Actualiser"))
                ]),
            replacement: Column(children: [
              Visibility(
                  visible: searching,
                  child: TextFormField(
                      initialValue: query,
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Recherche",
                          suffixIcon: InkWell(
                              onTap: () {
                                if (searching) {
                                  query = "";
                                }
                                setState(() {
                                  searching = !searching;
                                });
                              },
                              child: Ink(child: const Icon(Icons.clear))),
                          prefixIcon: const Icon(Icons.search)))),
              Expanded(
                  child: AlphabetScrollPage(
                      items: enseignants,
                      onCLickedItem: (int i) {
                        print("item:${enseignants[i].fullName}");
                        _showModal(i);
                      }))
            ])));
  }

  _showModal(int ind) async {
    Data.updList = false;
    showModalBottomSheet(
        context: context,
        elevation: 5,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return InfoEnseignant(enseignant: enseignants[ind]);
        }).then((value) {
      if (Data.updList) {
        getEnseignants();
      }
    });
  }
}

class AlphabetScrollPage extends StatefulWidget {
  final List<Enseignant> items;
  final ValueChanged<int> onCLickedItem;
  const AlphabetScrollPage(
      {Key? key, required this.items, required this.onCLickedItem})
      : super(key: key);

  @override
  _AlphabetScrollPageState createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  late List<Enseignant> items;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    initList(widget.items);
    super.initState();
  }

  void initList(List<Enseignant> items) {
    this.items = widget.items;
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => AzListView(
      indexBarItemHeight: (Data.heightScreen - 80) / 40,
      data: items,
      itemCount: items.length,
      itemBuilder: (context, i) {
        Enseignant item = items[i];
        if ((query.isEmpty) ||
            (item.fullName.toUpperCase().contains(query.toUpperCase()))) {
          return _buildListItem(item);
        } else {
          return Container();
        }
      },
      indexHintBuilder: (context, tag) => Container(
          alignment: Alignment.center,
          width: 60,
          height: 60,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Text(tag,
              style: const TextStyle(color: Colors.white, fontSize: 28))),
      indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle: TextStyle(
              color: Colors.white, fontSize: Data.isPortrait ? 12 : 7),
          textStyle: TextStyle(
              color: Colors.black, fontSize: Data.isPortrait ? 12 : 7),
          selectItemDecoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: const Offset(-20, 0)),
      padding: const EdgeInsets.all(16));

  Widget _buildListItem(Enseignant item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(children: [
      Offstage(offstage: offstage, child: buildHeader(tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          subtitle: Text(item.tel1.isEmpty ? item.matiere : item.tel1,
              style: const TextStyle(fontSize: 11)),
          horizontalTitleGap: 6,
          onTap: () {
            widget.onCLickedItem(enseignants.indexOf(item));
          })
    ]);
  }

  buildHeader(String tag) => Container(
      height: 40,
      color: Colors.grey.shade300,
      padding: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.center,
      child: Text(tag,
          softWrap: false,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)));
}
