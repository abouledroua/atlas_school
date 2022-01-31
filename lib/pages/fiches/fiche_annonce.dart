// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'package:atlas_school/classes/ann_image.dart';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/gest_annonce_images.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/parent.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Groupe> groupes = [], allgroupes = [];
List<Parent> parents = [], allparents = [];
List<Enfant> enfants = [], allenfants = [];
int visibiliteMode = 1;
String radio = "Public";

class FicheAnnonce extends StatefulWidget {
  final int id;
  const FicheAnnonce({Key? key, required this.id}) : super(key: key);

  @override
  _FicheAnnonceState createState() => _FicheAnnonceState();
}

class _FicheAnnonceState extends State<FicheAnnonce> {
  TextEditingController txtTitre = TextEditingController(text: "");
  TextEditingController txtDetails = TextEditingController(text: "");
  late int idAnnonce, mode;

  bool _valTitre = false,
      loading = false,
      uploadFinished = false,
      valider = false;
  DateTime? datetime;
  late String heure, date;
  int nbAnnImg = 0;
  List<int> deletedImages = [];
  List<MyAnnonceImage> myImages = [];

  getMyGroupes(List s) async {
    String serverDir = Data.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_GROUPE = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_GROUPES.php";
    print("url=$url");
    groupes.clear();
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
                  etat: int.parse(m['ETAT']),
                  id: int.parse(m['ID_GROUPE']));
              groupes.add(e);
            }
          } else {
            groupes.clear();
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
          groupes.clear();
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 2!!!')
              .show();
        });
    setState(() {});
  }

  getMyParents(List s) async {
    String serverDir = Data.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_PARENT = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_PARENTS.php";
    print("url=$url");
    parents.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": pWhere})
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
              parents.add(p);
            }
          } else {
            parents.clear();
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
          parents.clear();
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 4!!!')
              .show();
        });
    setState(() {});
  }

  getMyEnfants(List s) async {
    String serverDir = Data.getServerDirectory();
    String pWhere = "";
    for (var item in s) {
      if (pWhere != "") {
        pWhere += " OR ";
      }
      pWhere += " E.ID_ENFANT = " + item;
    }
    pWhere = " AND (" + pWhere + " )";
    var url = "$serverDir/GET_ENFANTS.php";
    print("url=$url");
    enfants.clear();
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
                  etat: int.parse(m['ETAT']),
                  sexe: sexe,
                  adresse: m['ADRESSE'],
                  isHomme: (sexe == 1),
                  isFemme: (sexe == 2),
                  photo: m['PHOTO']);
              enfants.add(e);
            }
          } else {
            enfants.clear();
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
          enfants.clear();
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 6!!!')
              .show();
        });
    setState(() {});
  }

  getAnnonceInfo() async {
    setState(() {
      loading = true;
    });
    myImages = [];
    nbAnnImg = 0;
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_INFO_ANNONCE.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_ANNONCE": idAnnonce.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            String s = "", ns = "";
            List ls = [], nls = [];
            MyAnnonceImage e;
            for (var m in responsebody) {
              txtTitre.text = m['TITRE'];
              txtDetails.text = m['DETAILS'];
              visibiliteMode = int.parse(m['VISIBILITE']);

              // partie groupes
              s = m['GROUPES'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                getMyGroupes(ls);
              }

              // partie PARENT
              s = m['PARENTS'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                getMyParents(ls);
              }

              // partie ENFANT
              s = m['ENFANTS'];
              if (s.isNotEmpty) {
                ls = s.split(",");
                getMyEnfants(ls);
              }

              // partie images
              ns = m['NUMS'];
              s = m['IMAGES'];
              s.isEmpty ? ls = [] : ls = s.split(",");
              ns.isEmpty ? nls = [] : nls = ns.split(",");
              for (var i = 0; i < ls.length; i++) {
                e = MyAnnonceImage(chemin: ls[i], num: int.parse(nls[i]));
                myImages.add(e);
              }
              nbAnnImg = myImages.length;
              setState(() {});
            }
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 7!!!')
                .show();
          }
          setState(() {
            loading = false;
          });
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
                  desc: 'Probleme de Connexion avec le serveur 8!!!')
              .show();
        });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    idAnnonce = widget.id;
    parents = [];
    groupes = [];
    enfants = [];
    myImages = [];
    nbAnnImg = 0;
    visibiliteMode = 1;
    radio = "Public";
    if (idAnnonce == 0) {
      setState(() {
        loading = false;
      });
    } else {
      getAnnonceInfo();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Data.setSizeScreen(context);
    return SafeArea(
        child: Stack(children: [
      Container(
          color: Colors.white,
          height: Data.heightScreen,
          width: Data.widthScreen),
      Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
              height: Data.heightScreen,
              width: Data.widthScreen,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15), BlendMode.dstATop),
                      image: const AssetImage('images/annonce.png'))))),
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              drawer: Data.myDrawer(context),
              appBar: AppBar(
                  backgroundColor: Colors.indigo,
                  centerTitle: true,
                  title: const Text("Fiche Annonce"),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white))),
              body: bodyContent()))
    ]));
  }

  pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null) return;
    MyAnnonceImage m;
    for (var image in images) {
      m = MyAnnonceImage(chemin: image.path, num: 0);
      myImages.add(m);
    }
    setState(() {});
  }

  captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    MyAnnonceImage m = MyAnnonceImage(chemin: image.path, num: 0);
    setState(() {
      myImages.add(m);
    });
  }

  bodyContent() {
    double padLeft = 10, padBottom = 30;
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
        replacement: Padding(
            padding: EdgeInsets.all(Data.widthScreen / 30),
            child: ListView(primary: false, shrinkWrap: true, children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padLeft, vertical: padBottom),
                  child: TextField(
                      enabled: !valider,
                      controller: txtTitre,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          errorText: _valTitre ? 'Champs Obligatoire' : null,
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.title_rounded,
                                  color: Colors.black)),
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: "Titre",
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Titre de l'annonce",
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding: EdgeInsets.only(
                      left: padLeft, right: padLeft, bottom: padBottom / 2),
                  child: TextField(
                      enabled: !valider,
                      maxLines: null,
                      controller: txtDetails,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.description_outlined,
                                  color: Colors.black)),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Détails",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Détails sur l'annonce",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              const Divider(),
              Stack(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.image),
                  const SizedBox(width: 10),
                  Text("Images ( ${myImages.length} )",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.laila(
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip)
                ]),
                Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                        onTap: valider
                            ? null
                            : () {
                                showModal();
                              },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.green),
                            child: const Icon(Icons.add, color: Colors.white))))
              ]),
              imageSpace(),
              const Divider(),
              Stack(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.gpp_maybe),
                  const SizedBox(width: 10),
                  Text("Visiblitée",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.laila(
                          decoration: TextDecoration.underline,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip)
                ]),
                Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                        onTap: valider
                            ? null
                            : () async {
                                await showDialog(
                                        context: context,
                                        builder: (_) => const PermissionPage())
                                    .then((value) {
                                  setState(() {});
                                });
                              },
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.blue),
                            child:
                                const Icon(Icons.edit, color: Colors.white))))
              ]),
              Padding(
                  padding: EdgeInsets.all(padBottom / 2),
                  child: Text(
                      (visibiliteMode == 1)
                          ? "Tous le Monde"
                          : (visibiliteMode == 2)
                              ? "Seulement les groupes suivants : "
                              : (visibiliteMode == 3)
                                  ? "Seulement les parents suivants : "
                                  : "Seulement les enfants suivants : ",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.laila(fontSize: 14),
                      overflow: TextOverflow.clip)),
              Visibility(
                  visible: (visibiliteMode != 1),
                  child: Visibility(
                      visible: (visibiliteMode == 2),
                      child: showListGroupeSelected(),
                      replacement: Visibility(
                          visible: (visibiliteMode == 3),
                          child: showListParentSelected(),
                          replacement: showListEnfantSelected()))),
              Visibility(
                  visible: (visibiliteMode == 2 && groupes.isEmpty ||
                      visibiliteMode == 3 && parents.isEmpty ||
                      visibiliteMode == 4 && enfants.isEmpty),
                  child: Center(
                      child: Text(
                          (visibiliteMode == 2)
                              ? "Aucun groupe séléctionné !!!"
                              : (visibiliteMode == 3)
                                  ? "Aucun parent séléctionné !!!"
                                  : "Aucun enfant séléctionné !!!",
                          style: GoogleFonts.laila(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold)))),
              const Divider(),
              Visibility(
                  visible: valider,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                            color: Data.darkColor[
                                Random().nextInt(Data.darkColor.length - 1) +
                                    1]),
                        const SizedBox(width: 20),
                        const Text("validation en cours ...")
                      ]),
                  replacement: Container(
                      margin: EdgeInsets.only(top: Data.widthScreen / 20),
                      child: Visibility(
                          visible: valider,
                          child: const Center(
                              child: Text("Validation en cours ...")),
                          replacement: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                                  context: context,
                                                  dialogType:
                                                      DialogType.QUESTION,
                                                  showCloseIcon: true,
                                                  btnCancelText: "Non",
                                                  btnOkText: "Oui",
                                                  btnCancelOnPress: () {},
                                                  btnOkOnPress: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  desc:
                                                      'Voulez-vous vraiment annuler tous les changements !!!')
                                              .show();
                                        },
                                        child: const Text("Annuler",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)))),
                                Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        border: Border.all(
                                            color: Colors.black, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: TextButton(
                                        onPressed: valider ? null : saveAnnonce,
                                        child: const Text("Valider",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white))))
                              ]))))
            ])));
  }

  imageSpace() {
    return SizedBox(
        height: Data.heightScreen / 6,
        child: Visibility(
            visible: myImages.isEmpty,
            child: const Center(
                child: Text("Pas d'images",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold))),
            replacement: ListView.builder(
                itemCount: myImages.length,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Stack(children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: i < nbAnnImg
                            ? Image.network(
                                Data.getImage(myImages[i].chemin, "ANNONCE"),
                                fit: BoxFit.contain, loadingBuilder:
                                    (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Data.darkColor[Random().nextInt(
                                                Data.darkColor.length - 1) +
                                            1]));
                              })
                            : Image.file(File(myImages[i].chemin),
                                fit: BoxFit.contain)),
                    Positioned(
                        top: -16,
                        right: -16,
                        child: IconButton(
                            onPressed: valider
                                ? null
                                : () {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.QUESTION,
                                            showCloseIcon: true,
                                            btnCancelText: "Non",
                                            btnOkText: "Oui",
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              if (i < nbAnnImg) {
                                                deletedImages
                                                    .add(myImages[i].num);
                                                nbAnnImg--;
                                              }
                                              setState(() {
                                                myImages.removeAt(i);
                                              });
                                            },
                                            desc:
                                                'Voulez-vous vraiment supprimer cette image ?')
                                        .show();
                                  },
                            icon: const Icon(Icons.delete, color: Colors.red)))
                  ]);
                })));
  }

  showListGroupeSelected() {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(children: [
                  Text((i + 1).toString() + " -  " + groupes[i].designation,
                      style: GoogleFonts.laila(fontSize: 16)),
                  const Spacer(),
                  InkWell(
                      onTap: valider
                          ? null
                          : () {
                              setState(() {
                                groupes.removeAt(i);
                              });
                            },
                      child: const Icon(Icons.delete, color: Colors.red))
                ]))),
        itemCount: groupes.length,
        primary: false,
        shrinkWrap: true);
  }

  showListParentSelected() {
    return ListView.builder(
        itemCount: parents.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(children: [
                  Text((i + 1).toString() + " -  " + parents[i].fullName,
                      style: GoogleFonts.laila(fontSize: 16)),
                  const Spacer(),
                  InkWell(
                      onTap: valider
                          ? null
                          : () {
                              setState(() {
                                parents.removeAt(i);
                              });
                            },
                      child: const Icon(Icons.delete, color: Colors.red))
                ]))));
  }

  showListEnfantSelected() {
    return ListView.builder(
        itemCount: enfants.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(children: [
                  Text((i + 1).toString() + " -  ",
                      style: GoogleFonts.laila(fontSize: 16)),
                  SizedBox(
                      width: 40,
                      child: (enfants[i].photo == "")
                          ? Image.asset("images/noPhoto.png")
                          : Image.network(
                              Data.getImage(enfants[i].photo, "PHOTO/ENFANT"),
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: Data.darkColor[Random().nextInt(
                                              Data.darkColor.length - 1) +
                                          1]));
                            })),
                  const SizedBox(width: 5),
                  Text(enfants[i].fullName,
                      style: GoogleFonts.laila(fontSize: 16)),
                  const Spacer(),
                  InkWell(
                      onTap: valider
                          ? null
                          : () {
                              setState(() {
                                enfants.removeAt(i);
                              });
                            },
                      child: const Icon(Icons.delete, color: Colors.red))
                ]))));
  }

  saveAnnonce() {
    setState(() {
      valider = true;
      _valTitre = txtTitre.text.isEmpty;
    });

    if (_valTitre) {
      setState(() {
        valider = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc: 'Veuillez remplir tous les champs obligatoire !!!')
          .show();
    } else if ((visibiliteMode == 2 && groupes.isEmpty) ||
        (visibiliteMode == 3 && parents.isEmpty) ||
        (visibiliteMode == 4 && enfants.isEmpty)) {
      setState(() {
        valider = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc:
                  "Veuillez régler les paramêtres de visible de  l'annonce !!!")
          .show();
    } else {
      existAnnonce();
    }
  }

  existAnnonce() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/EXIST_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "TITRE": txtTitre.text,
          "ID_ANNONCE": idAnnonce.toString(),
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            int result = 0;
            for (var m in responsebody) {
              result = int.parse(m['ID_ANNONCE']);
            }
            if (result == 0) {
              if (idAnnonce == 0) {
                insertAnnonce();
              } else {
                updateAnnonce();
              }
            } else {
              setState(() {
                valider = false;
              });
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: "Il existe déjà une annonce avec ce même titre !!!");
            }
          } else {
            setState(() {
              valider = false;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 9!!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          print("erreur : $error");
          setState(() {
            valider = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur 10!!!')
              .show();
        });
  }

  updateAnnonce() async {
    String serverDir = Data.getServerDirectory();

    String pGroupe = "", pParent = "", pEnfant = "";
    if (visibiliteMode == 2) {
      for (var i = 0; i < groupes.length; i++) {
        if (pGroupe.isNotEmpty) {
          pGroupe += ",";
        }
        pGroupe += groupes[i].id.toString();
      }
    } else if (visibiliteMode == 3) {
      for (var i = 0; i < parents.length; i++) {
        if (pParent.isNotEmpty) {
          pParent += ",";
        }
        pParent += parents[i].id.toString();
      }
    } else if (visibiliteMode == 4) {
      for (var i = 0; i < enfants.length; i++) {
        if (pEnfant.isNotEmpty) {
          pEnfant += ",";
        }
        pEnfant += enfants[i].id.toString();
      }
    }
    var body = {};
    body['ID_ANNONCE'] = idAnnonce.toString();
    body['TITRE'] = txtTitre.text;
    body['DETAILS'] = txtDetails.text;
    body['TYPE'] = visibiliteMode.toString();
    body['GROUPES'] = pGroupe;
    body['PARENTS'] = pParent;
    body['ENFANTS'] = pEnfant;
    for (var i = 0; i < deletedImages.length; i++) {
      body['DEL_' + i.toString()] = deletedImages[i].toString();
    }
    body['NB_DELETED'] = deletedImages.length.toString();
    var url = "$serverDir/UPDATE_ANNONCE.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: body).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.toString();
        print("responsebody=${response.body}");
        if (responsebody != "0") {
          loadImages();
          Data.showSnack('Annonce mis à jours ...', Colors.green);
          Navigator.of(context).pop();
        } else {
          setState(() {
            valider = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: "Probleme lors de la mise à jours !!!")
              .show();
        }
      } else {
        setState(() {
          valider = false;
        });
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                showCloseIcon: true,
                title: 'Erreur',
                desc: 'Probleme de Connexion avec le serveur 11!!!')
            .show();
      }
    }).catchError((error) {
      print("erreur : $error");
      setState(() {
        valider = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc: 'Probleme de Connexion avec le serveur 12!!!')
          .show();
    });
  }

  String getFileName(String chemin, File updfile) {
    String ext = updfile.path.split('.').last;
    String bddFileName = idAnnonce.toString() + "." + ext;
    String fileName = chemin + "\\" + bddFileName;
    return fileName;
  }

  loadImages() {
    late ImageAnnounce e;
    bool exist = false;
    for (var i = nbAnnImg; i < myImages.length; i++) {
      var item = myImages[i];
      e = ImageAnnounce(
          idAnnonce: idAnnonce,
          extension:
              p.extension(getFileName("IMAGE\\ANNONCE", File(item.chemin))),
          base64Image: base64Encode(File(item.chemin).readAsBytesSync()));
      GestAnnounceImages.myImages.add(e);
      exist = true;
    }
    if (exist) {
      Data.showSnack("En cours de chargement des images ...", Colors.amber);
    }
  }

  insertAnnonce() async {
    String serverDir = Data.getServerDirectory();

    String pGroupe = "", pParent = "", pEnfant = "";
    if (visibiliteMode == 2) {
      for (var i = 0; i < groupes.length; i++) {
        if (pGroupe.isNotEmpty) {
          pGroupe += ",";
        }
        pGroupe += groupes[i].id.toString();
      }
    } else if (visibiliteMode == 3) {
      for (var i = 0; i < parents.length; i++) {
        if (pParent.isNotEmpty) {
          pParent += ",";
        }
        pParent += parents[i].id.toString();
      }
    } else if (visibiliteMode == 4) {
      for (var i = 0; i < enfants.length; i++) {
        if (pEnfant.isNotEmpty) {
          pEnfant += ",";
        }
        pEnfant += enfants[i].id.toString();
      }
    }
    var body = {};
    body['TITRE'] = txtTitre.text;
    body['DETAILS'] = txtDetails.text;
    body['TYPE'] = visibiliteMode.toString();
    body['GROUPES'] = pGroupe;
    body['PARENTS'] = pParent;
    body['ENFANTS'] = pEnfant;
    var url = "$serverDir/INSERT_ANNONCE.php";
    Uri myUri = Uri.parse(url);
    http.post(myUri, body: body).then((response) async {
      if (response.statusCode == 200) {
        var responsebody = response.body;
        print("responsebody=${response.body}");
        if (responsebody != "0") {
          idAnnonce = int.parse(responsebody);
          loadImages();
          Data.showSnack('Annonce ajoutée ...', Colors.green);
          Navigator.of(context).pop();
        } else {
          setState(() {
            valider = false;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: "Probleme lors de l'ajout !!!")
              .show();
        }
      } else {
        setState(() {
          valider = false;
        });
        AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                showCloseIcon: true,
                title: 'Erreur',
                desc: 'Probleme de Connexion avec le serveur 13!!!')
            .show();
      }
    }).catchError((error) {
      print("erreur : $error");
      setState(() {
        valider = false;
      });
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc: 'Probleme de Connexion avec le serveur 14!!!')
          .show();
    });
  }

  void showModal() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () {
                            pickImages();
                            Navigator.of(context).pop();
                          },
                          child: Column(children: const [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.photo_album, size: 30)),
                            Text("Gallery", style: TextStyle(fontSize: 20))
                          ])),
                      GestureDetector(
                          onTap: () {
                            captureImage();
                            Navigator.of(context).pop();
                          },
                          child: Column(children: const [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.camera, size: 30)),
                            Text("Camera", style: TextStyle(fontSize: 20))
                          ]))
                    ]))
          ]);
        });
  }
}

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  _PermissionPageState createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  bool loading = true;

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    switch (visibiliteMode) {
      case 1:
        radio = "Public";
        break;
      case 2:
        radio = "Groupe";
        break;
      case 3:
        radio = "Parent";
        break;
      case 4:
        radio = "Enfant";
        break;
      default:
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                appBar: AppBar(
                    elevation: 1,
                    backgroundColor: Colors.white,
                    title: const Text("Audience",
                        style: TextStyle(color: Colors.black))),
                body: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Qui peut voir votre annonce ?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 30),
                          myradios("Public", "Tous le monde", "Public",
                              Icons.all_inclusive),
                          myradios(
                              "Groupes spécifié",
                              "Seulement les groupes sélectionnés",
                              "Groupe",
                              Icons.people_alt_outlined),
                          myradios(
                              "Parents spécifié",
                              "Seulement les parents sélectionnés",
                              "Parent",
                              Icons.group_rounded),
                          myradios(
                              "Enfants spécifié",
                              "Seulement les enfants sélectionnés",
                              "Enfant",
                              Icons.person_outline_outlined),
                          const SizedBox(height: 10),
                          const Divider(),
                          Visibility(
                              visible: (visibiliteMode == 2),
                              child: Visibility(
                                  visible: groupes.isNotEmpty,
                                  child: titleList("List des Groupes"),
                                  replacement: noSelected(
                                      "Aucun groupe séléctionné !!!")),
                              replacement: Visibility(
                                  visible: (visibiliteMode == 3),
                                  child: Visibility(
                                      visible: parents.isNotEmpty,
                                      child: titleList("List des Parents"),
                                      replacement: noSelected(
                                          "Aucun parent séléctionné !!!")),
                                  replacement: Visibility(
                                      visible: (visibiliteMode == 4),
                                      child: Visibility(
                                          visible: enfants.isNotEmpty,
                                          child: titleList("List des Enfants"),
                                          replacement: noSelected(
                                              "Aucun enfant séléctionné !!!"))))),
                          Visibility(
                              visible:
                                  (visibiliteMode == 2 && groupes.isNotEmpty),
                              child: Expanded(child: showSelectedGroupes()),
                              replacement: Visibility(
                                  visible: (visibiliteMode == 3 &&
                                      parents.isNotEmpty),
                                  child: Expanded(child: showSelectedParents()),
                                  replacement: Visibility(
                                      visible: (visibiliteMode == 4 &&
                                          enfants.isNotEmpty),
                                      child: Expanded(
                                          child: showSelectedEnfants())))),
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.center,
                              child: Row(children: [
                                Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(shape:
                                            MaterialStateProperty.resolveWith<
                                                    OutlinedBorder>(
                                                (Set<MaterialState> states) {
                                          return const StadiumBorder();
                                        })),
                                        onPressed: () {
                                          if (visibiliteMode == 2 &&
                                              groupes.isEmpty) {
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("Ok",
                                                style:
                                                    TextStyle(fontSize: 20)))))
                              ]))
                        ])))));
  }

  noSelected(String msg) {
    return Expanded(
      child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(msg,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold))),
    );
  }

  titleList(String msg) {
    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 20.0, bottom: 8),
        child: Text(msg,
            style: GoogleFonts.laila(
                decoration: TextDecoration.underline,
                fontSize: 20,
                fontWeight: FontWeight.bold)));
  }

  showSelectedGroupes() {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    (i + 1).toString() + " -  " + groupes[i].designation,
                    style: GoogleFonts.laila(fontSize: 16)))),
        itemCount: groupes.length,
        primary: false,
        shrinkWrap: true);
  }

  showSelectedParents() {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text((i + 1).toString() + " -  " + parents[i].fullName,
                    style: GoogleFonts.laila(fontSize: 16)))),
        itemCount: parents.length,
        primary: false,
        shrinkWrap: true);
  }

  showSelectedEnfants() {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(
                  children: [
                    Text((i + 1).toString() + " -  ",
                        style: GoogleFonts.laila(fontSize: 16)),
                    SizedBox(
                        width: 40,
                        child: (enfants[i].photo == "")
                            ? Image.asset("images/noPhoto.png")
                            : Image.network(
                                Data.getImage(enfants[i].photo, "PHOTO/ENFANT"),
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Data.darkColor[Random().nextInt(
                                                Data.darkColor.length - 1) +
                                            1]));
                              })),
                    const SizedBox(width: 5),
                    Text(enfants[i].fullName,
                        style: GoogleFonts.laila(fontSize: 16)),
                  ],
                ))),
        itemCount: enfants.length,
        primary: false,
        shrinkWrap: true);
  }

  onRadioChange(val) async {
    switch (val) {
      case "Public":
        setState(() {
          visibiliteMode = 1;
          radio = val;
        });
        print("Every one ....");
        break;
      case "Groupe":
        setState(() {
          visibiliteMode = 2;
          radio = val;
        });
        print("search for groupes");
        await showDialog(context: context, builder: (_) => const SearchGroup())
            .then((value) {
          setState(() {});
        });
        break;
      case "Parent":
        setState(() {
          visibiliteMode = 3;
          radio = val;
        });
        print("search for parents");
        await showDialog(context: context, builder: (_) => const SearchParent())
            .then((value) {
          setState(() {});
        });
        break;
      case "Enfant":
        setState(() {
          visibiliteMode = 4;
          radio = val;
        });
        print("search for kids");
        await showDialog(context: context, builder: (_) => const SearchEnfant())
            .then((value) {
          setState(() {});
        });
        break;
      default:
    }
  }

  myradios(String title, String sub, String val, IconData icon) {
    return RadioListTile(
        selected: radio == val,
        title: InkWell(
            onTap: () {
              onRadioChange(val);
            },
            child: Row(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(icon)),
              const SizedBox(width: 6),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title),
                Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(sub,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 11)))
              ])
            ])),
        groupValue: radio,
        onChanged: (value) {
          onRadioChange(value);
        },
        value: val);
  }
}

class SearchGroup extends StatefulWidget {
  const SearchGroup({Key? key}) : super(key: key);

  @override
  _SearchGroupState createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  late String query;
  late List<int> indDes;
  bool loading = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    query = "";
    loading = true;
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
        .post(myUri, body: {"WHERE": ''})
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
          } else {
            setState(() {
              allgroupes.clear();
              error = true;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 15!!!')
                .show();
          }
          setState(() {
            loading = false;
          });
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
                  desc: 'Probleme de Connexion avec le serveur 16!!!')
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
                                                      setState(() {
                                                        groupes.removeAt(groupes
                                                            .indexOf(item));
                                                      });
                                                    },
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red)),
                                                Container(
                                                    color: Colors.blue,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            item.designation,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))))
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
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    query = "";
    loading = true;
    getAllParents();
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
          } else {
            setState(() {
              allparents.clear();
              error = true;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 17!!!')
                .show();
          }
          setState(() {
            loading = false;
          });
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
                  desc: 'Probleme de Connexion avec le serveur 18!!!')
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

  bool existParent(int id) {
    for (var i = 0; i < parents.length; i++) {
      if (parents[i].id == id) {
        return true;
      }
    }
    return false;
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
                          Visibility(
                              visible: parents.isEmpty,
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      color: Colors.amber,
                                      child: const Text(
                                          "Pas de parent sélectionné",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)))),
                              replacement: Wrap(
                                  children: parents
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        parents.removeAt(parents
                                                            .indexOf(item));
                                                      });
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
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          query = "";
                                        });
                                      },
                                      child: const Icon(Icons.clear)),
                                  prefixIcon: const Icon(Icons.search))),
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: suggestionList.length,
                                  itemBuilder: (context, i) => Visibility(
                                      visible:
                                          !existParent(suggestionList[i].id),
                                      child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                  onTap: () {
                                                    print(suggestionList[i]
                                                        .fullName);
                                                    if (!existParent(
                                                        suggestionList[i].id)) {
                                                      setState(() {
                                                        parents.add(
                                                            suggestionList[i]);
                                                      });
                                                    }
                                                  },
                                                  title: Text(
                                                      suggestionList[i]
                                                          .fullName,
                                                      style: TextStyle(
                                                          color: existParent(
                                                                  suggestionList[
                                                                          i]
                                                                      .id)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .black))))))))
                        ]))))));
  }
}

class SearchEnfant extends StatefulWidget {
  const SearchEnfant({Key? key}) : super(key: key);

  @override
  _SearchEnfantState createState() => _SearchEnfantState();
}

class _SearchEnfantState extends State<SearchEnfant> {
  late String query;
  late List<int> indName;
  bool loading = true, error = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    query = "";
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
          } else {
            setState(() {
              allenfants.clear();
              error = true;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur 19!!!')
                .show();
          }
          setState(() {
            loading = false;
          });
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
                  desc: 'Probleme de Connexion avec le serveur 20!!!')
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
                                          "Pas de parent sélectionné",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)))),
                              replacement: Wrap(
                                  children: enfants
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        enfants.removeAt(enfants
                                                            .indexOf(item));
                                                      });
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
                                  suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() {
                                          query = "";
                                        });
                                      },
                                      child: const Icon(Icons.clear)),
                                  prefixIcon: const Icon(Icons.search))),
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

class MyAnnonceImage {
  late String chemin;
  int num;
  MyAnnonceImage({required this.chemin, required this.num});
}
