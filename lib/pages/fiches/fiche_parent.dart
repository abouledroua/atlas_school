// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class FicheParent extends StatefulWidget {
  final int id;
  const FicheParent({Key? key, required this.id}) : super(key: key);

  @override
  _FicheParentState createState() => _FicheParentState();
}

class _FicheParentState extends State<FicheParent> {
  String nom = "", prenom = "", dateNaiss = "";
  late int idParent, idUser;
  DateTime? date;
  int? sexe = 1;
  TextEditingController txtNom = TextEditingController(text: "");
  TextEditingController txtPrenom = TextEditingController(text: "");
  TextEditingController txtDateNaiss = TextEditingController(text: "");
  TextEditingController txtAdresse = TextEditingController(text: "");
  TextEditingController txtTel1 = TextEditingController(text: "");
  TextEditingController txtTel2 = TextEditingController(text: "");
  bool loading = false,
      valider = false,
      upd = false,
      _valNom = false,
      _valPrenom = false;

  getParentInfo() async {
    setState(() {
      loading = true;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_INFO_PARENTS.php";
    print("url=$url");
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PARENT": idParent.toString()})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            for (var m in responsebody) {
              txtNom.text = m['NOM'];
              txtPrenom.text = m['PRENOM'];
              txtAdresse.text = m['ADRESSE'];
              txtDateNaiss.text = m['DATE_NAISS'];
              txtTel1.text = m['TEL1'];
              txtTel2.text = m['TEL2'];
              idUser = int.parse(m['ID_USER']);
              sexe = int.parse(m['SEXE']);
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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    idParent = widget.id;
    idUser = 0;
    getParentInfo();
    if (idParent == 0) {
      setState(() {
        loading = false;
      });
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: Data.heightScreen,
              width: Data.widthScreen,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15), BlendMode.dstATop),
                      image: const AssetImage('images/famille.jpg'))))),
      GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: true,
              drawer: Data.currentUser != null ? Data.myDrawer(context) : null,
              appBar: AppBar(
                  backgroundColor: Colors.amber,
                  centerTitle: true,
                  title: FittedBox(
                      child: Text(Data.currentUser != null
                          ? "Fiche Parent"
                          : "Inscription Parent")),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white))),
              body: bodyContent()))
    ]));
  }

  updateParent() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/UPDATE_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "ID_PARENT": idParent.toString(),
          "SEXE": sexe.toString(),
          "ID_USER": idUser.toString(),
          "NOM": txtNom.text.toUpperCase(),
          "PRENOM": txtPrenom.text.toUpperCase(),
          "DATE_NAISS": txtDateNaiss.text,
          "ADRESSE": txtAdresse.text,
          "TEL1": txtTel1.text,
          "TEL2": txtTel2.text
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              Data.showSnack('Information mis à jours ...', Colors.green);
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
                      desc:
                          'Probleme lors de la mise a jour des informations !!!')
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
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            valider = false;
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

  existParent() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/EXIST_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text,
          "PRENOM": txtPrenom.text,
          "DATE_NAISS": txtDateNaiss.text,
          "ID_PARENT": idParent.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            switch (responsebody) {
              case 0:
                if (idParent == 0) {
                  insertParent();
                } else {
                  updateParent();
                }
                break;
              case 1:
                setState(() {
                  valider = false;
                });
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: "Cet Parent existe déjà !!!");
                break;
              default:
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
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            valider = false;
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

  insertParent() async {
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/INSERT_PARENT.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {
          "NOM": txtNom.text.toUpperCase(),
          "PRENOM": txtPrenom.text.toUpperCase(),
          "DATE_NAISS": txtDateNaiss.text,
          "ADRESSE": txtAdresse.text,
          "TEL1": txtTel1.text,
          "TEL2": txtTel2.text,
          "SEXE": sexe.toString()
        })
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              if (Data.currentUser != null) {
                Data.showSnack('Parent inscris ...', Colors.green);
              } else {
                Data.showSnack(
                    "Vous êtes inscris ...\nVeuillez Contacter l'administration",
                    Colors.green);
              }

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
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            valider = false;
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

  verifierChamps() {
    setState(() {
      _valNom = txtNom.text.isEmpty;
      _valPrenom = txtPrenom.text.isEmpty;
    });
  }

  saveParent() {
    setState(() {
      valider = true;
    });
    verifierChamps();

    if (_valNom || _valPrenom) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              showCloseIcon: true,
              title: 'Erreur',
              desc: 'Veuillez remplir tous les champs obligatoire !!!')
          .show();
      setState(() {
        valider = false;
      });
    } else {
      existParent();
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
        replacement: Padding(
            padding: EdgeInsets.all(Data.widthScreen / 30),
            child: ListView(primary: false, shrinkWrap: true, children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: TextField(
                      enabled: !valider,
                      controller: txtNom,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          errorText: _valNom ? 'Champs Obligatoire' : null,
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.supervised_user_circle_outlined,
                                  color: Colors.black)),
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: "Nom",
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Nom",
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: TextField(
                      enabled: !valider,
                      controller: txtPrenom,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          errorText: _valPrenom ? 'Champs Obligatoire' : null,
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.supervised_user_circle_outlined,
                                  color: Colors.black)),
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: "Prénom",
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Prénom",
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: TextField(
                      enabled: !valider,
                      onTap: () {
                        datePicker();
                      },
                      readOnly: true,
                      controller: txtDateNaiss,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                          prefixIcon: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.date_range_rounded,
                                  color: Colors.black)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                datePicker();
                              },
                              icon: const Icon(Icons.date_range_outlined)),
                          contentPadding: const EdgeInsets.only(bottom: 3),
                          labelText: "Date de Naissance",
                          labelStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Date de Naissance",
                          hintStyle:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Sexe",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        const SizedBox(width: 25),
                        Radio(
                            groupValue: sexe,
                            value: 1,
                            onChanged: valider
                                ? null
                                : (value) {
                                    setState(() {
                                      sexe = value as int?;
                                    });
                                  }),
                        GestureDetector(
                            child: const Text("Homme"),
                            onTap: valider
                                ? null
                                : () {
                                    setState(() {
                                      sexe = 1;
                                    });
                                  }),
                        Radio(
                            groupValue: sexe,
                            value: 2,
                            onChanged: valider
                                ? null
                                : (value) {
                                    setState(() {
                                      sexe = value as int?;
                                    });
                                  }),
                        GestureDetector(
                            child: const Text("Femme"),
                            onTap: valider
                                ? null
                                : () {
                                    setState(() {
                                      sexe = 2;
                                    });
                                  })
                      ])),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: TextField(
                      enabled: !valider,
                      maxLines: null,
                      controller: txtAdresse,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.gps_fixed, color: Colors.blue)),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Adresse",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Adresse",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: TextField(
                      enabled: !valider,
                      maxLines: null,
                      controller: txtTel1,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.gps_fixed, color: Colors.blue)),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Telephone 1",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Numero de Telephone 1",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                  child: TextField(
                      enabled: !valider,
                      maxLines: null,
                      controller: txtTel2,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.gps_fixed, color: Colors.blue)),
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "Telephone 2",
                          labelStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          hintText: "Numero de Telephone 2",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          floatingLabelBehavior:
                              FloatingLabelBehavior.always))),
              Container(
                  margin: EdgeInsets.symmetric(vertical: Data.widthScreen / 40),
                  child: valider
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              CircularProgressIndicator(
                                  color: Data.darkColor[Random()
                                          .nextInt(Data.darkColor.length - 1) +
                                      1]),
                              const SizedBox(width: 20),
                              const Text("validation en cours ...")
                            ])
                      : Row(
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
                                                dialogType: DialogType.QUESTION,
                                                showCloseIcon: true,
                                                btnCancelText: "Non",
                                                btnOkText: "Oui",
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  setState(() {
                                                    Navigator.of(context).pop();
                                                  });
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
                                      onPressed: saveParent,
                                      child: const Text("Valider",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white))))
                            ]))
            ])));
  }

  datePicker() {
    showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime(1800),
            lastDate: DateTime.now())
        .then((value) {
      date = value;
      setState(() {
        txtDateNaiss.text = DateFormat('yyyy-MM-dd').format(date!);
      });
    });
  }
}
