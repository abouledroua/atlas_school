// // ignore_for_file: avoid_print

// import 'dart:math';
// import 'package:atlas_school/classes/data.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:awesome_dialog/awesome_dialog.dart';

// class FicheGroupe extends StatefulWidget {
//   final int id;
//   const FicheGroupe({Key? key, required this.id}) : super(key: key);

//   @override
//   _FicheGroupeState createState() => _FicheGroupeState();
// }

// class _FicheGroupeState extends State<FicheGroupe> {
//   String des = "";
//   late int idGroupe;
//   int? etat = 1;
//   TextEditingController txtDes = TextEditingController(text: "");
//   bool loading = false, _valDes = false, valider = false;

//   getGroupeInfo() async {
//     setState(() {
//       loading = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_INFO_GROUPE.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_GROUPE": idGroupe.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             for (var m in responsebody) {
//               txtDes.text = m['DESIGNATION'];
//               etat = int.parse(m['ETAT']);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               loading = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur !!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             loading = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur !!!')
//               .show();
//         });
//   }

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     idGroupe = widget.id;
//     getGroupeInfo();
//     if (idGroupe == 0) {
//       setState(() {
//         loading = false;
//       });
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Data.setSizeScreen(context);
//     return SafeArea(
//         child: Stack(children: [
//       Container(
//           color: Colors.white,
//           height: Data.heightScreen,
//           width: Data.widthScreen),
//       Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               height: Data.heightScreen,
//               width: Data.widthScreen,
//               decoration: BoxDecoration(
//                   image: DecorationImage(
//                       fit: BoxFit.contain,
//                       colorFilter: ColorFilter.mode(
//                           Colors.black.withOpacity(0.2), BlendMode.dstATop),
//                       image: const AssetImage('images/groupe.png'))))),
//       GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Scaffold(
//             backgroundColor: Colors.transparent,
//             resizeToAvoidBottomInset: true,
//             drawer: Data.myDrawer(context),
//             appBar: AppBar(
//                 backgroundColor: Colors.cyan,
//                 centerTitle: true,
//                 title: const Text("Fiche Groupe"),
//                 leading: IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.arrow_back, color: Colors.white))),
//             body: bodyContent()),
//       )
//     ]));
//   }

//   updateGroupe() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/UPDATE_GROUPE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "ID_GROUPE": idGroupe.toString(),
//           "DESIGNATION": txtDes.text.toUpperCase()
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result != "0") {
//               Data.showSnack(
//                   msg: 'Information mis à jours ...', color: Colors.green);
//               Navigator.of(context).pop();
//             } else {
//               setState(() {
//                 valider = false;
//               });
//               AwesomeDialog(
//                       context: context,
//                       dialogType: DialogType.ERROR,
//                       showCloseIcon: true,
//                       title: 'Erreur',
//                       desc:
//                           'Probleme lors de la mise a jour des informations !!!')
//                   .show();
//             }
//           } else {
//             setState(() {
//               valider = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur !!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             valider = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur !!!')
//               .show();
//         });
//   }

//   existGroupe() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/EXIST_GROUPE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "DESIGNATION": txtDes.text,
//           "ID_GROUPE": idGroupe.toString()
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             int result = 0;
//             for (var m in responsebody) {
//               result = int.parse(m['ID_ENFANT']);
//             }
//             if (result == 0) {
//               if (idGroupe == 0) {
//                 insertGroupe();
//               } else {
//                 updateGroupe();
//               }
//             } else {
//               setState(() {
//                 valider = false;
//               });
//               AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: "Ce Groupe existe déjà !!!");
//             }
//           } else {
//             setState(() {
//               valider = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur !!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             valider = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur !!!')
//               .show();
//         });
//   }

//   insertGroupe() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/INSERT_GROUPE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"DESIGNATION": txtDes.text.toUpperCase()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result != "0") {
//               Data.showSnack(msg: 'Groupe ajouté ...',color:  Colors.green);
//               Navigator.of(context).pop();
//             } else {
//               setState(() {
//                 valider = false;
//               });
//               AwesomeDialog(
//                       context: context,
//                       dialogType: DialogType.ERROR,
//                       showCloseIcon: true,
//                       title: 'Erreur',
//                       desc: "Probleme lors de l'ajout !!!")
//                   .show();
//             }
//           } else {
//             setState(() {
//               valider = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur !!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             valider = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur !!!')
//               .show();
//         });
//   }

//   saveGroupe() {
//     setState(() {
//       _valDes = txtDes.text.isEmpty;
//       valider = true;
//     });

//     if (_valDes) {
//       setState(() {
//         valider = false;
//       });
//       AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               showCloseIcon: true,
//               title: 'Erreur',
//               desc: 'Veuillez remplir tous les champs obligatoire !!!')
//           .show();
//     } else {
//       existGroupe();
//     }
//   }

//   bodyContent() {
//     return loading
//         ? Center(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                 Container(
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: CircularProgressIndicator(
//                         color: Data.darkColor[
//                             Random().nextInt(Data.darkColor.length - 1) + 1])),
//                 const Text("Chargement en cours ...")
//               ]))
//         : Padding(
//             padding: EdgeInsets.all(Data.widthScreen / 30),
//             child: ListView(primary: false, shrinkWrap: true, children: [
//               Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
//                   child: TextField(
//                       enabled: !valider,
//                       controller: txtDes,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.text,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: InputDecoration(
//                           errorText: _valDes ? 'Champs Obligatoire' : null,
//                           prefixIcon: const Padding(
//                               padding: EdgeInsets.only(right: 4),
//                               child: Icon(Icons.supervised_user_circle_outlined,
//                                   color: Colors.black)),
//                           contentPadding: const EdgeInsets.only(bottom: 3),
//                           labelText: "Désignation",
//                           labelStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           hintText: "Désignation du Groupe",
//                           hintStyle:
//                               const TextStyle(fontSize: 14, color: Colors.grey),
//                           floatingLabelBehavior:
//                               FloatingLabelBehavior.always))),
//               Container(
//                   margin: EdgeInsets.only(top: Data.widthScreen / 40),
//                   child: valider
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                               CircularProgressIndicator(
//                                   color: Data.darkColor[Random()
//                                           .nextInt(Data.darkColor.length - 1) +
//                                       1]),
//                               const SizedBox(width: 20),
//                               const Text("validation en cours ...")
//                             ])
//                       : Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                               Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 30),
//                                   decoration: BoxDecoration(
//                                       border: Border.all(
//                                           color: Colors.black, width: 1),
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: TextButton(
//                                       onPressed: () {
//                                         AwesomeDialog(
//                                                 context: context,
//                                                 dialogType: DialogType.QUESTION,
//                                                 showCloseIcon: true,
//                                                 btnCancelText: "Non",
//                                                 btnOkText: "Oui",
//                                                 btnCancelOnPress: () {},
//                                                 btnOkOnPress: () {
//                                                   setState(() {
//                                                     Navigator.of(context).pop();
//                                                   });
//                                                 },
//                                                 desc:
//                                                     'Voulez-vous vraiment annuler tous les changements !!!')
//                                             .show();
//                                       },
//                                       child: const Text("Annuler",
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.black)))),
//                               Container(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 30),
//                                   decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       border: Border.all(
//                                           color: Colors.black, width: 1),
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(20))),
//                                   child: TextButton(
//                                       onPressed: saveGroupe,
//                                       child: const Text("Valider",
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               color: Colors.white))))
//                             ]))
//             ]));
//   }
// }
