// // ignore_for_file: avoid_print

// import 'dart:math';
// import 'package:atlas_school/classes/enfant.dart';
// import 'package:atlas_school/classes/parent.dart';
// import 'package:atlas_school/classes/data.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class FicheRelation extends StatefulWidget {
//   final int idParent, idEnfant;
//   const FicheRelation(
//       {Key? key, required this.idParent, required this.idEnfant})
//       : super(key: key);

//   @override
//   _FicheRelationState createState() => _FicheRelationState();
// }

// List<Enfant> allenfants = [];
// List<Parent> allparents = [];
// List<Parent> parents = [];
// List<Enfant> enfants = [];

// String pNomSel = "";
// int pIdSel = 0;

// class _FicheRelationState extends State<FicheRelation> {
//   late int idEnfant, idParent;
//   bool loading = true;
//   Enfant? enfant;
//   Parent? parent;

//   getListEnfant() async {
//     setState(() {
//       loading = true;
//     });
//     enfants.clear();
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_ENFANTS_PARENT.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_PARENT": idParent.toString(), "WHERE": ""})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Enfant e;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               e = Enfant(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_ENFANT']),
//                   etat: int.parse(m['ETAT']),
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   photo: m['PHOTO']);
//               enfants.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               enfants.clear();
//               loading = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur 1!!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             enfants.clear();
//             loading = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 2!!!')
//               .show();
//         });
//   }

//   getListParent() async {
//     setState(() {
//       loading = true;
//     });
//     parents.clear();
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_PARENT_ENFANT.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Parent e;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               e = Parent(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_PARENT']),
//                   idUser: int.parse(m['ID_USER']),
//                   etat: int.parse(m['ETAT']),
//                   userName: m['USERNAME'],
//                   password: m['PASSWORD'],
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   tel2: m['TEL2'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   tel1: m['TEL1']);
//               parents.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               parents.clear();
//               loading = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur 3!!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             parents.clear();
//             loading = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 4!!!')
//               .show();
//         });
//   }

//   getListParentOfEnfant() async {
//     setState(() {
//       loading = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_PARENTS.php";
//     String pWhere = "";
//     for (var item in parents) {
//       pWhere += " AND NOT E.ID_PARENT = ${item.id}";
//     }
//     allparents.clear();
//     print("parents.length=${parents.length}");
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"WHERE": pWhere})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Parent e;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               e = Parent(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_PARENT']),
//                   idUser: int.parse(m['ID_USER']),
//                   etat: int.parse(m['ETAT']),
//                   userName: m['USERNAME'],
//                   password: m['PASSWORD'],
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   tel2: m['TEL2'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   tel1: m['TEL1']);
//               allparents.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               allparents.clear();
//               loading = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur 5!!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             allparents.clear();
//             loading = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 6!!!')
//               .show();
//         });
//   }

//   getListEnfantOfParent() async {
//     setState(() {
//       loading = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_ENFANTS.php";
//     String pWhere = "";
//     allenfants.clear();
//     for (var item in enfants) {
//       pWhere += " AND NOT E.ID_ENFANT = ${item.id}";
//     }
//     print("enfants.length=${enfants.length}");
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"WHERE": pWhere})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Enfant e;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               e = Enfant(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_ENFANT']),
//                   etat: int.parse(m['ETAT']),
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   photo: m['PHOTO'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2));
//               allenfants.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               allenfants.clear();
//               loading = false;
//             });
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Probleme de Connexion avec le serveur 7!!!')
//                 .show();
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//           setState(() {
//             allenfants.clear();
//             loading = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 8!!!')
//               .show();
//         });
//   }

//   getEnfantInfo() async {
//     setState(() {
//       loading = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_INFO_ENFANTS.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_ENFANT": idEnfant.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             late int sexe;
//             var responsebody = jsonDecode(response.body);
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               enfant = Enfant(
//                   adresse: m['ADRESSE'],
//                   dateNaiss: m['DATE_NAISS'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   id: idEnfant,
//                   etat: int.parse(m['ETAT']),
//                   isFemme: (sexe == 2),
//                   isHomme: (sexe == 1),
//                   nom: m['NOM'],
//                   photo: m['PHOTO'],
//                   prenom: m['PRENOM'],
//                   sexe: sexe);
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
//                     desc: 'Probleme de Connexion avec le serveur 9!!!')
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
//                   desc: 'Probleme de Connexion avec le serveur 10!!!')
//               .show();
//         });
//   }

//   getParentInfo() async {
//     setState(() {
//       loading = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_INFO_PARENTS.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_PARENT": idParent.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             late int sexe;
//             var responsebody = jsonDecode(response.body);
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               parent = Parent(
//                   adresse: m['ADRESSE'],
//                   dateNaiss: m['DATE_NAISS'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   id: idEnfant,
//                   isFemme: (sexe == 2),
//                   isHomme: (sexe == 1),
//                   nom: m['NOM'],
//                   tel1: m['TEL1'],
//                   tel2: m['TEL2'],
//                   prenom: m['PRENOM'],
//                   idUser: int.parse(m['ID_USER']),
//                   etat: int.parse(m['ETAT']),
//                   userName: m['USERNAME'],
//                   password: m['PASSWORD'],
//                   sexe: sexe);
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
//                     desc: 'Probleme de Connexion avec le serveur 16!!!')
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
//                   desc: 'Probleme de Connexion avec le serveur 11!!!')
//               .show();
//         });
//   }

//   chargerDonnees() {
//     if (idEnfant != 0) {
//       getEnfantInfo();
//       getListParent().then((value) {
//         getListParentOfEnfant();
//       });
//     } else {
//       getParentInfo();
//       getListEnfant().then((value) {
//         getListEnfantOfParent();
//       });
//     }
//   }

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized();
//     idEnfant = widget.idEnfant;
//     idParent = widget.idParent;
//     chargerDonnees();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Data.setSizeScreen(context);
//     return SafeArea(
//         child: Scaffold(
//             drawer: Data.myDrawer(context),
//             appBar: AppBar(
//                 centerTitle: true,
//                 title: const Text("Relation Parent - Enfant"),
//                 leading: IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.arrow_back, color: Colors.white))),
//             body: Padding(
//                 padding: const EdgeInsets.all(10), child: bodyContent())));
//   }

//   enfantContent() {
//     return Visibility(
//         visible: parents.isEmpty,
//         child: const Center(
//             child: Text("Aucun Parent !!!!",
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold))),
//         replacement: ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             primary: false,
//             shrinkWrap: true,
//             itemCount: parents.length,
//             itemBuilder: (context, i) {
//               return Card(
//                   elevation: 4,
//                   child: ListTile(
//                       title: Text(parents[i].fullName,
//                           style: GoogleFonts.laila(
//                               fontSize: 12, fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.clip),
//                       subtitle: Text(parents[i].adresse,
//                           style: GoogleFonts.laila(
//                               fontSize: 12, color: Colors.grey.shade800),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 10),
//                       trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                         Column(children: [
//                           (parents[i].tel1 != "")
//                               ? GestureDetector(
//                                   onTap: () {
//                                     Data.makeExternalRequest(
//                                         'tel:${parents[i].tel1}');
//                                   },
//                                   child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(parents[i].tel1,
//                                             textAlign: TextAlign.center,
//                                             style:
//                                                 const TextStyle(fontSize: 11)),
//                                         const SizedBox(width: 10),
//                                         const Icon(Icons.call,
//                                             color: Colors.green)
//                                       ]))
//                               : const SizedBox(width: 0, height: 0),
//                           (parents[i].tel2 != "")
//                               ? GestureDetector(
//                                   onTap: () {
//                                     Data.makeExternalRequest(
//                                         'tel:${parents[i].tel2}');
//                                   },
//                                   child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Text(parents[i].tel2,
//                                             textAlign: TextAlign.center,
//                                             style:
//                                                 const TextStyle(fontSize: 11)),
//                                         const SizedBox(width: 10),
//                                         const Icon(Icons.call,
//                                             color: Colors.green)
//                                       ]))
//                               : const SizedBox(width: 0, height: 0)
//                         ]),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                             onTap: () {
//                               AwesomeDialog(
//                                       context: context,
//                                       dialogType: DialogType.ERROR,
//                                       showCloseIcon: true,
//                                       title: 'Erreur',
//                                       btnOkText: "Oui",
//                                       btnCancelText: "Non",
//                                       btnOkOnPress: () {
//                                         print(
//                                             "suppression de la relation ${parents[i].id},$idEnfant");
//                                         deleteRelation(parents[i].id, idEnfant,
//                                                 context)
//                                             .then((value) {
//                                           chargerDonnees();
//                                         });
//                                       },
//                                       btnCancelOnPress: () {},
//                                       desc:
//                                           'Voulez vraiment supprimer cette relation ?')
//                                   .show();
//                             },
//                             child: const Icon(Icons.delete, color: Colors.red))
//                       ])));
//             }));
//   }

//   parentContent() {
//     return Visibility(
//         visible: enfants.isEmpty,
//         child: const Center(
//             child: Text("Aucun Enfants !!!!",
//                 style: TextStyle(
//                     fontSize: 22,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold))),
//         replacement: ListView.builder(
//             physics: const BouncingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             primary: false,
//             shrinkWrap: true,
//             itemCount: enfants.length,
//             itemBuilder: (context, i) {
//               return Container(
//                   color: enfants[i].isHomme
//                       ? Colors.blue.shade100
//                       : Colors.pink.shade100,
//                   child: ListTile(
//                       horizontalTitleGap: 4,
//                       leading: Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: SizedBox(
//                               width: 60,
//                               child: (enfants[i].photo == "")
//                                   ? Image.asset("images/noPhoto.png")
//                                   : CachedNetworkImage(
//                                       //  fit: BoxFit.contain,
//                                       placeholder: (context, url) =>
//                                           CircularProgressIndicator(
//                                               color: Data.darkColor[
//                                                   Random().nextInt(Data.darkColor.length - 1) +
//                                                       1]),
//                                       imageUrl: Data.getImage(
//                                           enfants[i].photo, "PHOTO/ENFANT")))),
//                       title: Text(enfants[i].fullName,
//                           style: GoogleFonts.laila(
//                               fontSize: 12, fontWeight: FontWeight.bold),
//                           overflow: TextOverflow.clip),
//                       subtitle: Text(enfants[i].adresse,
//                           style: GoogleFonts.laila(fontSize: 12, color: Colors.grey.shade800),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 10),
//                       trailing: Row(mainAxisSize: MainAxisSize.min, children: [
//                         Text(enfants[i].dateNaiss,
//                             textAlign: TextAlign.center,
//                             style: const TextStyle(fontSize: 11)),
//                         const SizedBox(width: 5),
//                         GestureDetector(
//                             onTap: () {
//                               AwesomeDialog(
//                                       context: context,
//                                       dialogType: DialogType.ERROR,
//                                       showCloseIcon: true,
//                                       title: 'Erreur',
//                                       btnOkText: "Oui",
//                                       btnCancelText: "Non",
//                                       btnOkOnPress: () {
//                                         print(
//                                             "suppression de la relation $idParent,${enfants[i].id}");
//                                         deleteRelation(idParent, enfants[i].id,
//                                                 context)
//                                             .then((value) {
//                                           chargerDonnees();
//                                         });
//                                       },
//                                       btnCancelOnPress: () {},
//                                       desc:
//                                           'Voulez vraiment supprimer cette relation ?')
//                                   .show();
//                             },
//                             child: const Icon(Icons.delete, color: Colors.red))
//                       ])));
//             }));
//   }

//   Widget circularPhoto() {
//     return Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(image: showPhoto(), fit: BoxFit.contain)));
//   }

//   showPhoto() {
//     if (enfant!.photo == "") {
//       return const AssetImage("images/noPhoto.png");
//     } else {
//       return NetworkImage(Data.getImage(enfant!.photo, "PHOTO/ENFANT"));
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
//         : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             idEnfant != 0
//                 ? enfant != null
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                             circularPhoto(),
//                             const SizedBox(width: 10),
//                             Text(enfant!.fullName,
//                                 style: GoogleFonts.laila(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                                 overflow: TextOverflow.clip)
//                           ])
//                     : Container()
//                 : parent != null
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                             Text("Parent : " + parent!.fullName,
//                                 style: GoogleFonts.laila(
//                                     fontSize: 16, fontWeight: FontWeight.bold),
//                                 overflow: TextOverflow.clip)
//                           ])
//                     : Container(),
//             const Divider(),
//             Row(children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 20),
//                 child: Text(
//                     (idEnfant != 0) ? "Liste des Parents" : "Liste des Enfants",
//                     style: GoogleFonts.adamina(
//                         color: Colors.blue.shade700,
//                         decoration: TextDecoration.underline,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.clip),
//               ),
//               const Spacer(),
//               Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                           primary: Colors.blue, onPrimary: Colors.white),
//                       onPressed: () {
//                         if (idEnfant != 0) {
//                           showModalAjoutParent();
//                         } else {
//                           showModalAjoutEnfant();
//                         }
//                       },
//                       icon: const Icon(Icons.add),
//                       label: const Text("Ajouter")))
//             ]),
//             const Divider(),
//             Visibility(
//                 visible: ((idEnfant != 0 && parents.isEmpty) ||
//                     (idParent != 0 && enfants.isEmpty)),
//                 child: const Spacer()),
//             Visibility(
//                 visible: ((idEnfant != 0 && parents.isEmpty) ||
//                     (idParent != 0 && enfants.isEmpty)),
//                 child: Center(
//                     child: Text(
//                         "Aucun " +
//                             (idEnfant != 0 ? "Parents" : "Enfant") +
//                             " !!!!",
//                         style: const TextStyle(
//                             fontSize: 22,
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold)))),
//             Visibility(
//                 visible: ((idEnfant != 0 && parents.isEmpty) ||
//                     (idParent != 0 && enfants.isEmpty)),
//                 child: const Spacer()),
//             Visibility(
//                 visible: ((idEnfant != 0 && parents.isNotEmpty) ||
//                     (idParent != 0 && enfants.isNotEmpty)),
//                 child: Visibility(
//                     visible: (idEnfant != 0),
//                     child: enfantContent(),
//                     replacement: parentContent()))
//           ]);
//   }

//   showModalAjoutEnfant() async {
//     await showDialog(
//         context: context,
//         builder: (_) => SearchEnfant(idParent: idParent)).then((value) {
//       setState(() {});
//     });
//   }

//   showModalAjoutParent() async {
//     await showDialog(
//         context: context,
//         builder: (_) => SearchParent(idEnfant: idEnfant)).then((value) {
//       setState(() {});
//     });
//   }

//   nomSelect() {
//     return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Text(((idEnfant != 0) ? "Parent" : "Enfant") + " Sélectionné : ",
//           style: const TextStyle(color: Colors.black)),
//       Text(pNomSel,
//           style:
//               const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
//     ]);
//   }
// }

// insertRelation(int idParent, int idEnfant, BuildContext context) async {
//   String serverDir = Data.getServerDirectory();
//   var url = "$serverDir/INSERT_RELATION.php";
//   print(url);
//   Uri myUri = Uri.parse(url);
//   http
//       .post(myUri, body: {
//         "ID_ENFANT": idEnfant.toString(),
//         "ID_PARENT": idParent.toString()
//       })
//       .timeout(Duration(seconds: Data.timeOut))
//       .then((response) async {
//         if (response.statusCode == 200) {
//           var responsebody = jsonDecode(response.body);
//           int result = int.parse(responsebody);
//           if (result == 0) {
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: "Probleme lors de l'ajout !!!")
//                 .show();
//           }
//         } else {
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 12!!!')
//               .show();
//         }
//       })
//       .catchError((error) {
//         print("erreur : $error");
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 showCloseIcon: true,
//                 title: 'Erreur',
//                 desc: 'Probleme de Connexion avec le serveur 13!!!')
//             .show();
//       });
// }

// deleteRelation(int idParent, int idEnfant, BuildContext context) async {
//   String serverDir = Data.getServerDirectory();
//   var url = "$serverDir/DELETE_RELATION.php";
//   print(url);
//   Uri myUri = Uri.parse(url);
//   http
//       .post(myUri, body: {
//         "ID_ENFANT": idEnfant.toString(),
//         "ID_PARENT": idParent.toString()
//       })
//       .timeout(Duration(seconds: Data.timeOut))
//       .then((response) async {
//         if (response.statusCode == 200) {
//           var responsebody = jsonDecode(response.body);
//           int result = int.parse(responsebody);
//           if (result == 0) {
//             AwesomeDialog(
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: "Probleme lors de l'ajout !!!")
//                 .show();
//           }
//         } else {
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur 14!!!')
//               .show();
//         }
//       })
//       .catchError((error) {
//         print("erreur : $error");
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 showCloseIcon: true,
//                 title: 'Erreur',
//                 desc: 'Probleme de Connexion avec le serveur 15!!!')
//             .show();
//       });
// }

// class SearchParent extends StatefulWidget {
//   final int idEnfant;
//   const SearchParent({Key? key, required this.idEnfant}) : super(key: key);

//   @override
//   _SearchParentState createState() => _SearchParentState();
// }

// class _SearchParentState extends State<SearchParent> {
//   late String query;
//   late int idEnfant;
//   late List<int> indName;
//   bool loading = true, error = false;

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     query = "";
//     idEnfant = widget.idEnfant;
//     loading = true;
//     getAllParents();
//     super.initState();
//   }

//   getAllParents() async {
//     setState(() {
//       loading = true;
//       error = false;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_PARENTS.php";
//     print("url=$url");
//     allparents.clear();
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"WHERE": " AND E.ETAT = 1"})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Parent p;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               p = Parent(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_PARENT']),
//                   idUser: int.parse(m['ID_USER']),
//                   etat: int.parse(m['ETAT']),
//                   userName: m['USERNAME'],
//                   password: m['PASSWORD'],
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   tel2: m['TEL2'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   tel1: m['TEL1']);
//               allparents.add(p);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               allparents.clear();
//               loading = false;
//               error = true;
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
//             allparents.clear();
//             loading = false;
//             error = true;
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

//   List<Parent> filtrerCours() {
//     indName = [];
//     List<Parent> list = [];
//     for (var item in allparents) {
//       if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
//         list.add(item);
//         indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
//       }
//     }
//     return list;
//   }

//   bool existParent(int id) {
//     for (var i = 0; i < parents.length; i++) {
//       if (parents[i].id == id) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Parent> suggestionList =
//         query.isEmpty ? allparents : filtrerCours();
//     return SafeArea(
//         child: Scaffold(
//             appBar: AppBar(
//                 elevation: 1,
//                 backgroundColor: Colors.white,
//                 title: const Text("Selectionner Parent(s)",
//                     style: TextStyle(color: Colors.black)),
//                 leading: IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.arrow_back, color: Colors.black))),
//             body: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Visibility(
//                     visible: loading,
//                     child: Center(
//                         child: CircularProgressIndicator(
//                             color: Data.darkColor[
//                                 Random().nextInt(Data.darkColor.length - 1) +
//                                     1])),
//                     replacement: Visibility(
//                         visible: allparents.isEmpty,
//                         child: Container(
//                             color: Colors.white,
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                       child: Text(
//                                           error
//                                               ? "Erreur de connexion !!!"
//                                               : "Aucun Parent !!!!",
//                                           style: TextStyle(
//                                               fontSize: 22,
//                                               color: error
//                                                   ? Colors.red
//                                                   : Colors.green,
//                                               fontWeight: FontWeight.bold))),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton.icon(
//                                       style: ElevatedButton.styleFrom(
//                                           primary: Colors.blue,
//                                           onPrimary: Colors.white),
//                                       onPressed: getAllParents,
//                                       icon: const FaIcon(FontAwesomeIcons.sync,
//                                           color: Colors.white),
//                                       label: const Text("Actualiser"))
//                                 ])),
//                         replacement: Column(children: [
//                           Visibility(
//                               visible: parents.isEmpty,
//                               child: Center(
//                                   child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       width: double.infinity,
//                                       color: Colors.amber,
//                                       child: const Text(
//                                           "Pas de parent sélectionné",
//                                           textAlign: TextAlign.center,
//                                           style:
//                                               TextStyle(color: Colors.white)))),
//                               replacement: Wrap(
//                                   children: parents
//                                       .map((item) => Padding(
//                                           padding: const EdgeInsets.all(4),
//                                           child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 InkWell(
//                                                     onTap: () {
//                                                       AwesomeDialog(
//                                                               context: context,
//                                                               dialogType:
//                                                                   DialogType
//                                                                       .ERROR,
//                                                               showCloseIcon:
//                                                                   true,
//                                                               title: 'Erreur',
//                                                               btnOkText: "Oui",
//                                                               btnCancelText:
//                                                                   "Non",
//                                                               btnOkOnPress: () {
//                                                                 int i = parents
//                                                                     .indexOf(
//                                                                         item);
//                                                                 print(
//                                                                     "suppression de la relation ${parents[i].id},$idEnfant");

//                                                                 deleteRelation(
//                                                                     parents[i]
//                                                                         .id,
//                                                                     idEnfant,
//                                                                     context);
//                                                                 setState(() {
//                                                                   parents.removeAt(
//                                                                       parents.indexOf(
//                                                                           item));
//                                                                 });
//                                                               },
//                                                               btnCancelOnPress:
//                                                                   () {},
//                                                               desc:
//                                                                   'Voulez vraiment supprimer cette relation ?')
//                                                           .show();
//                                                     },
//                                                     child: Ink(
//                                                         child: const Icon(
//                                                             Icons.delete,
//                                                             color:
//                                                                 Colors.red))),
//                                                 Container(
//                                                     child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Text(
//                                                             item.fullName,
//                                                             style: const TextStyle(
//                                                                 color: Colors
//                                                                     .white))),
//                                                     color: Colors.blue)
//                                               ])))
//                                       .toList()
//                                       .cast<Widget>())),
//                           const Divider(),
//                           TextFormField(
//                               initialValue: query,
//                               onChanged: (value) {
//                                 setState(() {
//                                   query = value;
//                                 });
//                               },
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   hintText: "Recherche",
//                                   suffixIcon: const Icon(Icons.clear),
//                                   prefixIcon: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           query = "";
//                                         });
//                                       },
//                                       child: Ink(
//                                           child: const Icon(Icons.search))))),
//                           Expanded(
//                               child: ListView.builder(
//                                   shrinkWrap: true,
//                                   primary: false,
//                                   itemCount: suggestionList.length,
//                                   itemBuilder: (context, i) => Visibility(
//                                       visible:
//                                           !existParent(suggestionList[i].id),
//                                       child: Card(
//                                           child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: ListTile(
//                                                   onTap: () {
//                                                     print(suggestionList[i]
//                                                         .fullName);
//                                                     if (!existParent(
//                                                         suggestionList[i].id)) {
//                                                       insertRelation(
//                                                           suggestionList[i].id,
//                                                           idEnfant,
//                                                           context);
//                                                       setState(() {
//                                                         parents.add(
//                                                             suggestionList[i]);
//                                                       });
//                                                     }
//                                                   },
//                                                   title: Text(
//                                                       suggestionList[i]
//                                                           .fullName,
//                                                       style: TextStyle(
//                                                           color: existParent(
//                                                                   suggestionList[
//                                                                           i]
//                                                                       .id)
//                                                               ? Colors.grey
//                                                               : Colors
//                                                                   .black))))))))
//                         ]))))));
//   }
// }

// class SearchEnfant extends StatefulWidget {
//   final int idParent;
//   const SearchEnfant({Key? key, required this.idParent}) : super(key: key);

//   @override
//   _SearchEnfantState createState() => _SearchEnfantState();
// }

// class _SearchEnfantState extends State<SearchEnfant> {
//   late String query;
//   late int idParent;
//   late List<int> indName;
//   bool loading = true, error = false;

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     query = "";
//     idParent = widget.idParent;
//     loading = true;
//     getAllEnfants();
//     super.initState();
//   }

//   getAllEnfants() async {
//     setState(() {
//       loading = true;
//       error = false;
//     });
//     allenfants.clear();
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_ENFANTS.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"WHERE": " AND E.ETAT = 1"})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Enfant e;
//             late int sexe;
//             for (var m in responsebody) {
//               sexe = int.parse(m['SEXE']);
//               e = Enfant(
//                   nom: m['NOM'],
//                   prenom: m['PRENOM'],
//                   fullName: m['NOM'] + "  " + m['PRENOM'],
//                   dateNaiss: m['DATE_NAISS'],
//                   id: int.parse(m['ID_ENFANT']),
//                   etat: int.parse(m['ETAT']),
//                   sexe: sexe,
//                   adresse: m['ADRESSE'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   photo: m['PHOTO']);
//               allenfants.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               allenfants.clear();
//               loading = false;
//               error = true;
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
//             allenfants.clear();
//             loading = false;
//             error = true;
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

//   List<Enfant> filtrerCours() {
//     indName = [];
//     List<Enfant> list = [];
//     for (var item in allenfants) {
//       if (item.fullName.toUpperCase().contains(query.toUpperCase())) {
//         list.add(item);
//         indName.add(item.fullName.toUpperCase().indexOf(query.toUpperCase()));
//       }
//     }
//     return list;
//   }

//   bool existEnfant(int id) {
//     for (var i = 0; i < enfants.length; i++) {
//       if (enfants[i].id == id) {
//         return true;
//       }
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Enfant> suggestionList =
//         query.isEmpty ? allenfants : filtrerCours();
//     return SafeArea(
//         child: Scaffold(
//             resizeToAvoidBottomInset: true,
//             appBar: AppBar(
//                 elevation: 1,
//                 backgroundColor: Colors.white,
//                 title: const Text("Selectionner Enfant(s)",
//                     style: TextStyle(color: Colors.black)),
//                 leading: IconButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     icon: const Icon(Icons.arrow_back, color: Colors.black))),
//             body: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Visibility(
//                     visible: loading,
//                     child: Center(
//                         child: CircularProgressIndicator(
//                             color: Data.darkColor[
//                                 Random().nextInt(Data.darkColor.length - 1) +
//                                     1])),
//                     replacement: Visibility(
//                         visible: allenfants.isEmpty,
//                         child: Container(
//                             color: Colors.white,
//                             child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                       child: Text(
//                                           error
//                                               ? "Erreur de connexion !!!"
//                                               : "Aucun Enfant !!!!",
//                                           style: TextStyle(
//                                               fontSize: 22,
//                                               color: error
//                                                   ? Colors.red
//                                                   : Colors.green,
//                                               fontWeight: FontWeight.bold))),
//                                   const SizedBox(height: 10),
//                                   ElevatedButton.icon(
//                                       style: ElevatedButton.styleFrom(
//                                           primary: Colors.blue,
//                                           onPrimary: Colors.white),
//                                       onPressed: getAllEnfants,
//                                       icon: const FaIcon(FontAwesomeIcons.sync,
//                                           color: Colors.white),
//                                       label: const Text("Actualiser"))
//                                 ])),
//                         replacement: Column(children: [
//                           Visibility(
//                               visible: enfants.isEmpty,
//                               child: Center(
//                                   child: Container(
//                                       padding: const EdgeInsets.all(10),
//                                       width: double.infinity,
//                                       color: Colors.amber,
//                                       child: const Text(
//                                           "Pas d'enfant sélectionné",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               fontSize: 18,
//                                               color: Colors.white)))),
//                               replacement: Wrap(
//                                   children: enfants
//                                       .map((item) => Padding(
//                                           padding: const EdgeInsets.all(4),
//                                           child: Row(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 InkWell(
//                                                     onTap: () {
//                                                       AwesomeDialog(
//                                                               context: context,
//                                                               dialogType:
//                                                                   DialogType
//                                                                       .ERROR,
//                                                               showCloseIcon:
//                                                                   true,
//                                                               title: 'Erreur',
//                                                               btnOkText: "Oui",
//                                                               btnCancelText:
//                                                                   "Non",
//                                                               btnOkOnPress: () {
//                                                                 int i = enfants
//                                                                     .indexOf(
//                                                                         item);
//                                                                 print(
//                                                                     "suppression de la relation $idParent,${enfants[i].id}");
//                                                                 deleteRelation(
//                                                                     idParent,
//                                                                     enfants[i]
//                                                                         .id,
//                                                                     context);
//                                                                 setState(() {
//                                                                   enfants.removeAt(
//                                                                       enfants.indexOf(
//                                                                           item));
//                                                                 });
//                                                               },
//                                                               btnCancelOnPress:
//                                                                   () {},
//                                                               desc:
//                                                                   'Voulez vraiment supprimer cette relation ?')
//                                                           .show();
//                                                     },
//                                                     child: Ink(
//                                                         child: const Icon(
//                                                             Icons.delete,
//                                                             color:
//                                                                 Colors.red))),
//                                                 Container(
//                                                     child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Text(
//                                                             item.fullName,
//                                                             style: const TextStyle(
//                                                                 color: Colors
//                                                                     .white))),
//                                                     color: Colors.blue)
//                                               ])))
//                                       .toList()
//                                       .cast<Widget>())),
//                           const Divider(),
//                           TextFormField(
//                               initialValue: query,
//                               onChanged: (value) {
//                                 setState(() {
//                                   query = value;
//                                 });
//                               },
//                               keyboardType: TextInputType.text,
//                               decoration: InputDecoration(
//                                   hintText: "Recherche",
//                                   suffixIcon: const Icon(Icons.clear),
//                                   prefixIcon: InkWell(
//                                       onTap: () {
//                                         setState(() {
//                                           query = "";
//                                         });
//                                       },
//                                       child: Ink(
//                                           child: const Icon(Icons.search))))),
//                           Expanded(
//                               child: ListView.builder(
//                                   shrinkWrap: true,
//                                   primary: false,
//                                   itemCount: suggestionList.length,
//                                   itemBuilder: (context, i) => Visibility(
//                                       visible:
//                                           !existEnfant(suggestionList[i].id),
//                                       child: Card(
//                                           child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: ListTile(
//                                                   onTap: () {
//                                                     print(suggestionList[i]
//                                                         .fullName);
//                                                     if (!existEnfant(
//                                                         suggestionList[i].id)) {
//                                                       insertRelation(
//                                                           idParent,
//                                                           suggestionList[i].id,
//                                                           context);
//                                                       setState(() {
//                                                         enfants.add(
//                                                             suggestionList[i]);
//                                                       });
//                                                     }
//                                                   },
//                                                   title: Text(
//                                                       suggestionList[i]
//                                                           .fullName,
//                                                       style: TextStyle(
//                                                           color: existEnfant(
//                                                                   suggestionList[
//                                                                           i]
//                                                                       .id)
//                                                               ? Colors.grey
//                                                               : Colors
//                                                                   .black))))))))
//                         ]))))));
//   }
// }
