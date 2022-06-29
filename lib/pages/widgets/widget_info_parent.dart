// // ignore_for_file: avoid_print

// import 'dart:math';

// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/classes/enfant.dart';
// import 'package:atlas_school/classes/parent.dart';
// import 'package:atlas_school/pages/fiches/fiche_parent.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:atlas_school/pages/fiches/fiche_relation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class InfoParent extends StatefulWidget {
//   final Parent parent;
//   const InfoParent({Key? key, required this.parent}) : super(key: key);

//   @override
//   _InfoEnfantState createState() => _InfoEnfantState();
// }

// class _InfoEnfantState extends State<InfoParent> {
//   late Parent parent;
//   List<Enfant> enfants = [];
//   bool loadingEnfant = true;

//   getListEnfant() async {
//     setState(() {
//       loadingEnfant = true;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_ENFANT_PARENT.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_PARENT": parent.id.toString(), "WHERE": ""})
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
//                   sexe: sexe,
//                   etat: int.parse(m['ETAT']),
//                   adresse: m['ADRESSE'],
//                   photo: m['PHOTO'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2));
//               enfants.add(e);
//             }
//             setState(() {
//               loadingEnfant = false;
//             });
//           } else {
//             setState(() {
//               enfants.clear();
//               loadingEnfant = false;
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
//             enfants.clear();
//             loadingEnfant = false;
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

//   deleteParent() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/DELETE_PARENT.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "ID_PARENT": parent.id.toString(),
//           "ID_USER": parent.idUser.toString(),
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result != "0") {
//               Data.showSnack(msg: 'Parent supprimé ...', color: Colors.green);
//               Navigator.of(context).pop();
//             } else {
//               AwesomeDialog(
//                       context: context,
//                       dialogType: DialogType.ERROR,
//                       showCloseIcon: true,
//                       title: 'Erreur',
//                       desc: "Probleme lors de la suppression !!!")
//                   .show();
//             }
//           } else {
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
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme de Connexion avec le serveur !!!')
//               .show();
//         });
//   }

//   listParentEnfant() {
//     if (enfants.isEmpty) {
//       return Column(children: [
//         const Divider(),
//         Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           const Icon(Icons.warning, color: Colors.amber),
//           const SizedBox(width: 10),
//           Text("Aucun Enfant !!!",
//               textAlign: TextAlign.center,
//               style: GoogleFonts.laila(
//                   decoration: TextDecoration.underline,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold),
//               overflow: TextOverflow.clip)
//         ])
//       ]);
//     } else {
//       return Column(children: [
//         const Divider(),
//         Text("Liste des Enfants ",
//             textAlign: TextAlign.center,
//             style: GoogleFonts.laila(
//                 decoration: TextDecoration.underline,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold),
//             overflow: TextOverflow.clip),
//         ListView.builder(
//             shrinkWrap: true,
//             primary: false,
//             itemCount: enfants.length,
//             physics: const NeverScrollableScrollPhysics(),
//             itemBuilder: (context, i) => ListTile(
//                 horizontalTitleGap: 4,
//                 title: Text(enfants[i].fullName,
//                     style: GoogleFonts.laila(
//                         fontSize: 12, fontWeight: FontWeight.bold),
//                     overflow: TextOverflow.clip),
//                 leading: Padding(
//                     padding: const EdgeInsets.all(2.0),
//                     child: SizedBox(
//                         width: 60,
//                         child: (enfants[i].photo == "")
//                             ? Image.asset("images/noPhoto.png")
//                             : CachedNetworkImage(
//                                 //   fit: BoxFit.contain,
//                                 placeholder: (context, url) => Center(
//                                     child: CircularProgressIndicator(
//                                         color: Data.darkColor[Random().nextInt(
//                                                 Data.darkColor.length - 1) +
//                                             1])),
//                                 imageUrl: Data.getImage(
//                                     enfants[i].photo, "PHOTO/ENFANT"))))))
//       ]);
//     }
//   }

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized();
//     parent = widget.parent;
//     loadingEnfant = true;
//     getListEnfant();
//     super.initState();
//   }

//   Widget makeDismissible({required Widget child}) => GestureDetector(
//       behavior: HitTestBehavior.opaque,
//       onTap: () => Navigator.of(context).pop(),
//       child: GestureDetector(onTap: () {}, child: child));

//   @override
//   Widget build(BuildContext context) {
//     return makeDismissible(
//         child: DraggableScrollableSheet(
//             initialChildSize: 0.4,
//             minChildSize: 0.4,
//             maxChildSize: 0.9,
//             builder: (_, controller) => Container(
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(25))),
//                 padding: const EdgeInsets.all(10),
//                 child: loadingEnfant
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                             const Text("Chargement en cours ..."),
//                             const SizedBox(width: 10),
//                             CircularProgressIndicator(
//                                 color: Data.darkColor[Random()
//                                         .nextInt(Data.darkColor.length - 1) +
//                                     1])
//                           ])
//                     : ListView(controller: controller, children: [
//                         Text(parent.fullName.toUpperCase(),
//                             textAlign: TextAlign.center,
//                             style: GoogleFonts.laila(
//                                 fontSize: 20, fontWeight: FontWeight.bold),
//                             overflow: TextOverflow.clip),
//                         Visibility(
//                             visible: parent.dateNaiss.isNotEmpty,
//                             child: Row(children: [
//                               const Icon(Icons.date_range_rounded),
//                               const SizedBox(width: 20),
//                               Text(parent.dateNaiss + " ("),
//                               Text(
//                                   parent.dateNaiss.isEmpty
//                                       ? ""
//                                       : Data.calculateAge(
//                                           DateTime.parse(parent.dateNaiss)),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold)),
//                               const Text(" )")
//                             ])),
//                         Visibility(
//                             visible: (parent.adresse != ""),
//                             child: Row(children: [
//                               const Icon(Icons.gps_fixed),
//                               const SizedBox(width: 20),
//                               Text(parent.adresse)
//                             ])),
//                         const Divider(),
//                         Visibility(
//                             visible: (parent.userName != ""),
//                             child: Row(children: [
//                               const Icon(Icons.verified_user),
//                               const SizedBox(width: 20),
//                               Text(parent.userName)
//                             ])),
//                         Visibility(
//                             visible: (parent.password != ""),
//                             child: Row(children: [
//                               const Icon(Icons.password),
//                               const SizedBox(width: 20),
//                               Text(parent.password)
//                             ])),
//                         listParentEnfant(),
//                         const Divider(),
//                         Wrap(alignment: WrapAlignment.spaceEvenly, children: [
//                           ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.green,
//                                   onPrimary: Colors.white),
//                               onPressed: () {
//                                 Data.updList = true;
//                                 var route = MaterialPageRoute(
//                                     builder: (context) =>
//                                         FicheParent(id: parent.id));
//                                 Navigator.of(context).push(route).then((value) {
//                                   Navigator.of(context).pop();
//                                 });
//                               },
//                               icon: const Icon(Icons.edit),
//                               label: const Text("Infos")),
//                           ElevatedButton.icon(
//                               style: ElevatedButton.styleFrom(
//                                   primary: Colors.blueGrey,
//                                   onPrimary: Colors.white),
//                               onPressed: () {
//                                 Data.updList = true;
//                                 var route = MaterialPageRoute(
//                                     builder: (context) => FicheRelation(
//                                         idEnfant: 0, idParent: parent.id));
//                                 Navigator.of(context).push(route).then((value) {
//                                   Navigator.of(context).pop();
//                                 });
//                               },
//                               icon: const FaIcon(FontAwesomeIcons.user),
//                               label: const Text("Enfants")),
//                           Visibility(
//                               visible: enfants.isEmpty,
//                               child: ElevatedButton.icon(
//                                   style: ElevatedButton.styleFrom(
//                                       primary: Colors.red,
//                                       onPrimary: Colors.white),
//                                   onPressed: () {
//                                     Data.updList = true;
//                                     AwesomeDialog(
//                                             context: context,
//                                             dialogType: DialogType.QUESTION,
//                                             showCloseIcon: true,
//                                             title: 'Confirmation',
//                                             btnOkText: "Oui",
//                                             btnCancelText: "Non",
//                                             btnOkOnPress: deleteParent,
//                                             btnCancelOnPress: () {
//                                               Navigator.of(context).pop();
//                                             },
//                                             desc:
//                                                 'Voulez vraiment supprimer cet parent ? \n Attention tous les messages de ce parent seront supprimés !!!!')
//                                         .show();
//                                   },
//                                   icon: const Icon(Icons.delete),
//                                   label: const Text("Supprimer")))
//                         ])
//                       ]))));
//   }
// }
