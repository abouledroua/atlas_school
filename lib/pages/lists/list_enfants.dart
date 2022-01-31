// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/pages/fiches/fiche_enfants.dart';
import 'package:atlas_school/pages/widgets/widget_info_enfant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:azlistview/azlistview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListEnfant extends StatefulWidget {
  const ListEnfant({Key? key}) : super(key: key);

  @override
  _ListEnfantState createState() => _ListEnfantState();
}

List<Enfant> enfants = [];
String query = "";

class _ListEnfantState extends State<ListEnfant> {
  bool loading = true, loadingParent = true, error = false, searching = false;

  getEnfants() async {
    setState(() {
      loading = true;
      error = false;
    });
    enfants.clear();
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""}) //, "CODE": code
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
          } else {
            setState(() {
              enfants.clear();
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
          setState(() {
            loading = false;
          });
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            enfants.clear();
            error = true;
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

  @override
  void initState() {
    print("initialise list_enfant");
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    loading = true;
    getEnfants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build list_enfant");
    Data.setSizeScreen(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                backgroundColor: Colors.blueGrey,
                centerTitle: true,
                titleSpacing: 0,
                title: const Center(child: Text("Liste des Enfants")),
                actions: [
                  IconButton(
                      onPressed: () {
                        getEnfants();
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
                heroTag: "btn3",
                backgroundColor: Colors.blueGrey,
                onPressed: btnInsert,
                child: const Icon(Icons.add)),
            body: bodyContent()));
  }

  btnInsert() {
    var route =
        MaterialPageRoute(builder: (context) => const FicheEnfant(id: 0));
    Navigator.of(context).push(route).then((value) {
      getEnfants();
    });
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
          return InfoEnfant(enfants: enfants[ind]);
        }).then((value) {
      if (Data.updList) {
        getEnfants();
      }
    });
  }

  showPhoto(int ind) {
    if (enfants[ind].photo == "") {
      return const AssetImage("images/noPhoto.png");
    } else {
      return NetworkImage(Data.getImage(enfants[ind].photo, "PHOTO/ENFANT"));
    }
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
            visible: enfants.isEmpty,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                          error
                              ? "Erreur de connexion !!!"
                              : "Aucun Enfants !!!!",
                          style: TextStyle(
                              fontSize: 22,
                              color: error ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: getEnfants,
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
                      items: enfants,
                      onCLickedItem: (int i) {
                        print("item:${enfants[i].fullName}");
                        _showModal(i);
                      }))
            ])));
  }
}

class AlphabetScrollPage extends StatefulWidget {
  final List<Enfant> items;
  final ValueChanged<int> onCLickedItem;
  const AlphabetScrollPage(
      {Key? key, required this.items, required this.onCLickedItem})
      : super(key: key);

  @override
  _AlphabetScrollPageState createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  late List<Enfant> items;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    initList(widget.items);
    super.initState();
  }

  void initList(List<Enfant> items) {
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
        Enfant item = items[i];
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

  Widget _buildListItem(Enfant item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    final photo = Data.getImage(item.photo, "PHOTO/ENFANT");
    print("photo=$photo");
    return Column(children: [
      Offstage(offstage: offstage, child: buildHeader(tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SizedBox(
                  width: 60,
                  child: (item.photo == "")
                      ? Image.asset("images/noPhoto.png")
                      : Image.network(photo,
                          errorBuilder: (context, url, error) =>
                              const Icon(Icons.error),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Data.darkColor[Random().nextInt(
                                            Data.darkColor.length - 1) +
                                        1]));
                          }))),
          subtitle: Row(children: [
            Text(item.dateNaiss + "  --  ",
                style: const TextStyle(fontSize: 11)),
            Text(Data.calculateAge(DateTime.parse(item.dateNaiss)),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
          ]),
          horizontalTitleGap: 6,
          onTap: () {
            widget.onCLickedItem(enfants.indexOf(item));
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
