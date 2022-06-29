// // ignore_for_file: avoid_print, use_key_in_widget_constructors

// import 'dart:math';
// import 'package:atlas_school/classes/annonce.dart';
// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/classes/enfant.dart';
// import 'package:atlas_school/classes/gest_annonce_images.dart';
// import 'package:atlas_school/classes/groupe.dart';
// import 'package:atlas_school/classes/parent.dart';
// import 'package:atlas_school/classes/photo.dart';
// import 'package:atlas_school/pages/fiches/fiche_annonce.dart';
// import 'package:atlas_school/pages/fiches/fiche_show_annonce.dart';
// import 'package:atlas_school/pages/widgets/widget_gallery.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// List<Groupe> groupes = [];
// List<Parent> parents = [];
// List<Enfant> enfants = [];
// List<Annonce> annonces = [];
// int selectedItem = 0;

// class ListAnnonce extends StatefulWidget {
//   const ListAnnonce({Key? key}) : super(key: key);

//   @override
//   _ListAnnonceState createState() => _ListAnnonceState();
// }

// class _ListAnnonceState extends State<ListAnnonce> {
//   bool loading = true, error = false;

//   listenNewImages() async {
//     while (true) {
//       if (!GestAnnounceImages.isThereNewUploaded) {
//         await Future.delayed(const Duration(seconds: 2));
//       } else {
//         GestAnnounceImages.isThereNewUploaded = false;
//         getAnnonces();
//       }
//     }
//   }

//   getAnnonces() {
//     if (Data.currentUser!.isAdmin) {
//       getAllAnnonces();
//     } else {
//       getUserAnnonces();
//     }
//   }

//   getAllAnnonces() async {
//     setState(() {
//       loading = true;
//       error = false;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_ANNONCES.php";
//     print("url=$url");
//     annonces.clear();
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri,
//             body: {"ID_USER": Data.currentUser!.idUser.toString(), "WHERE": ""})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Annonce e;
//             String s = "";
//             late List<String> im, gr, en, pr;
//             for (var m in responsebody) {
//               s = m['IMAGES'];
//               (s.isEmpty) ? im = [] : im = s.split(",");
//               s = m['GROUPES'];
//               (s.isEmpty) ? gr = [] : gr = s.split(",");
//               s = m['ENFANTS'];
//               (s.isEmpty) ? en = [] : en = s.split(",");
//               s = m['PARENTS'];
//               (s.isEmpty) ? pr = [] : pr = s.split(",");
//               e = Annonce(
//                   strEnfants: en,
//                   strGroupes: gr,
//                   strParents: pr,
//                   date: m['DATE_ANNONCE'],
//                   heure: m['HEURE_ANNONCE'],
//                   images: im,
//                   detail: m['DETAILS'],
//                   dateTime: DateTime.parse(m['DATETIME']),
//                   pin: (int.parse(m['PIN']) == 1),
//                   id: int.parse(m['ID_ANNONCE']),
//                   visiblite: int.parse(m['VISIBILITE']),
//                   etat: int.parse(m['ETAT']),
//                   titre: m['TITRE']);
//               annonces.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               annonces.clear();
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
//             annonces.clear();
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

//   getUserAnnonces() async {
//     setState(() {
//       loading = true;
//       error = false;
//     });
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_USER_ANNONCES.php";
//     print("url=$url");
//     annonces.clear();
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "ID_USER": Data.currentUser!.idUser.toString(),
//           "ID_PARENT": Data.currentUser!.idParent.toString(),
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Annonce e;
//             String s = "";
//             late List<String> im, gr, en, pr;
//             for (var m in responsebody) {
//               s = m['IMAGES'];
//               (s.isEmpty) ? im = [] : im = s.split(",");
//               s = m['GROUPES'];
//               (s.isEmpty) ? gr = [] : gr = s.split(",");
//               s = m['ENFANTS'];
//               (s.isEmpty) ? en = [] : en = s.split(",");
//               s = m['PARENTS'];
//               (s.isEmpty) ? pr = [] : pr = s.split(",");
//               e = Annonce(
//                   strEnfants: en,
//                   strGroupes: gr,
//                   strParents: pr,
//                   date: m['DATE_ANNONCE'],
//                   heure: m['HEURE_ANNONCE'],
//                   images: im,
//                   detail: m['DETAILS'],
//                   dateTime: DateTime.parse(m['DATETIME']),
//                   pin: (int.parse(m['PIN']) == 1),
//                   id: int.parse(m['ID_ANNONCE']),
//                   visiblite: int.parse(m['VISIBILITE']),
//                   etat: int.parse(m['ETAT']),
//                   titre: m['TITRE']);
//               annonces.add(e);
//             }
//             setState(() {
//               loading = false;
//             });
//           } else {
//             setState(() {
//               annonces.clear();
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
//             annonces.clear();
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

//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized();
//     loading = true;
//     listenNewImages();
//     getAnnonces();
//     super.initState();
//   }

//   Widget build(BuildContext context) {
//     if (!Data.currentUser!.isAdmin) {
//       Data.myContext = context;
//     }
//     Data.setSizeScreen(context);
//     return SafeArea(
//         child: Scaffold(
//             backgroundColor: loading ? Colors.white : Colors.grey.shade400,
//             drawer: Data.myDrawer(context),
//             appBar: AppBar(
//                 backgroundColor: Colors.indigo,
//                 centerTitle: true,
//                 titleSpacing: 0,
//                 title: const Center(child: Text("Liste des Annonces")),
//                 actions: [
//                   IconButton(
//                       onPressed: () {
//                         getAllAnnonces();
//                       },
//                       icon: const FaIcon(FontAwesomeIcons.sync,
//                           color: Colors.white))
//                 ],
//                 leading: (Data.canPop)
//                     ? IconButton(
//                         onPressed: () {
//                           Data.canPop = false;
//                           Navigator.of(context).pop();
//                         },
//                         icon: const Icon(Icons.arrow_back, color: Colors.white))
//                     : null),
//             floatingActionButton: Data.currentUser!.isAdmin
//                 ? FloatingActionButton(
//                     heroTag: "btn2",
//                     backgroundColor: Colors.indigo,
//                     onPressed: btnInsert,
//                     child: const Icon(Icons.add))
//                 : null,
//             body: Padding(
//                 padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
//                 child: bodyContent())));
//   }

//   btnInsert() {
//     var route =
//         MaterialPageRoute(builder: (context) => const FicheAnnonce(id: 0));
//     Navigator.of(context).push(route).then((value) {
//       getAnnonces();
//     });
//   }

//   bodyContent() => Visibility(
//       visible: loading,
//       child: loadingWidget(),
//       replacement: Visibility(
//           visible: annonces.isEmpty,
//           child: Container(
//               color: Colors.white,
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Center(
//                         child: Text(
//                             error
//                                 ? "Erreur de connexion !!!"
//                                 : "Aucune Annonce !!!!",
//                             style: TextStyle(
//                                 fontSize: 22,
//                                 color: error ? Colors.red : Colors.green,
//                                 fontWeight: FontWeight.bold))),
//                     const SizedBox(height: 10),
//                     ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.blue, onPrimary: Colors.white),
//                         onPressed: getAnnonces,
//                         icon: const FaIcon(FontAwesomeIcons.sync,
//                             color: Colors.white),
//                         label: const Text("Actualiser"))
//                   ])),
//           replacement: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               scrollDirection: Axis.vertical,
//               primary: false,
//               shrinkWrap: true,
//               itemCount: annonces.length,
//               itemBuilder: (context, i) => GestureDetector(
//                   onTap: () {
//                     selectedItem = i;
//                     showModalBottomSheet(
//                             context: context,
//                             elevation: 5,
//                             builder: (context) => BottomWidget(ind: i))
//                         .then((value) {
//                       if (value != null) {
//                         print(value.toString());
//                         getAnnonces();
//                       }
//                     });
//                   },
//                   child: Container(
//                       decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(20))),
//                       child: Card(child: tile(annonces[i], i)))))));

//   loadingWidget() => Center(
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   child: CircularProgressIndicator(
//                       color: Data.darkColor[
//                           Random().nextInt(Data.darkColor.length - 1) + 1])),
//               const Text("Chargement en cours ...")
//             ]),
//       );

//   tile(Annonce annonce, int i) {
//     int nbImages = annonce.images.length;
//     return Padding(
//         padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Row(children: [
//                 Expanded(
//                     child: Text(annonce.titre,
//                         maxLines: 2,
//                         style: GoogleFonts.laila(
//                             fontSize: 16, fontWeight: FontWeight.bold),
//                         overflow: TextOverflow.clip)),
//                 Visibility(
//                     visible: annonce.pin,
//                     child: const Icon(Icons.flag, color: Colors.amber))
//               ]),
//               Row(children: [
//                 Icon(annonce.visiblite == 1
//                     ? Icons.all_inclusive
//                     : annonce.visiblite == 2
//                         ? Icons.people_alt_outlined
//                         : annonce.visiblite == 3
//                             ? Icons.group_rounded
//                             : Icons.person_outline_outlined),
//                 const SizedBox(width: 5),
//                 Text(Data.printDate(annonce.dateTime),
//                     style: GoogleFonts.laila(fontSize: 11),
//                     overflow: TextOverflow.clip)
//               ]),
//               Visibility(
//                   visible: annonce.detail.isNotEmpty,
//                   child: const SizedBox(height: 10)),
//               Visibility(
//                   visible: annonce.detail.isNotEmpty,
//                   child: Text(annonce.detail,
//                       maxLines: 3,
//                       style: GoogleFonts.laila(fontSize: 11),
//                       overflow: TextOverflow.clip)),
//               const SizedBox(height: 10),
//               // yarham babak khaliha haka ay dega koun traja3ha visibility
//               SizedBox(
//                   height: Data.heightScreen * 0.4,
//                   child: annonce.images.isNotEmpty
//                       ? nbImages == 1
//                           ? imageTile1(annonce, i)
//                           : nbImages == 2
//                               ? imageTile2(annonce, i)
//                               : nbImages == 3
//                                   ? imageTile3(annonce, i)
//                                   : imageTile4(annonce, i)
//                       : Container())
//             ]));
//   }

//   showImage(Annonce annonce, int i) {
//     return Hero(
//         tag: 'myHero$i',
//         child: GestureDetector(
//             onTap: () async {
//               List<Photo> gallery = [];
//               for (var item in annonce.images) {
//                 gallery.add(Photo(chemin: item, date: '', heure: '', id: 0));
//               }
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => GalleryWidget(
//                       index: i,
//                       myImages: gallery,
//                       delete: false,
//                       folder: "ANNONCE")));
//             },
//             child: Center(
//                 child: Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: CachedNetworkImage(
//                         fit: BoxFit.contain,
//                         imageUrl: Data.getImage(annonce.images[i], "ANNONCE"),
//                         placeholder: (context, url) =>
//                             CircularProgressIndicator(
//                                 color: Data.darkColor[Random()
//                                         .nextInt(Data.darkColor.length - 1) +
//                                     1]))))));
//   }

//   imageTile1(Annonce annonce, int ia) => showImage(annonce, 0);

//   imageTile2(Annonce annonce, int ia) => Row(children: [
//         Expanded(child: showImage(annonce, 0)),
//         Expanded(child: showImage(annonce, 1))
//       ]);

//   imageTile3(Annonce annonce, int ia) => Row(children: [
//         Expanded(child: showImage(annonce, 0)),
//         Expanded(
//             child: Column(children: [
//           Expanded(child: showImage(annonce, 1)),
//           const SizedBox(height: 10),
//           Expanded(child: showImage(annonce, 2))
//         ]))
//       ]);

//   imageTile4(Annonce annonce, int ia) {
//     int nb = annonce.images.length - 3;
//     return GestureDetector(
//         onTap: () {
//           var route = MaterialPageRoute(
//               builder: (context) => ShowAnnonce(
//                   annonce: annonce,
//                   enfants: enfants,
//                   groupes: groupes,
//                   parents: parents));
//           Navigator.of(context).push(route);
//         },
//         child: Stack(children: [
//           Row(children: [
//             Expanded(child: showImage(annonce, 0)),
//             Expanded(
//                 child: Column(children: [
//               Expanded(child: showImage(annonce, 1)),
//               const SizedBox(height: 10),
//               Expanded(child: showImage(annonce, 2))
//             ]))
//           ]),
//           Positioned(
//               top: Data.heightScreen / 4 - 10,
//               left: Data.widthScreen / 2 - 10,
//               child: Container(
//                   color: Colors.grey.withOpacity(0.5),
//                   height: Data.heightScreen / 4,
//                   width: Data.widthScreen / 2,
//                   child: Center(
//                       child: Text("+$nb",
//                           style: const TextStyle(
//                               color: Colors.white, fontSize: 40)))))
//         ]));
//   }
// }

// class BottomWidget extends StatefulWidget {
//   final int ind;
//   const BottomWidget({Key? key, required this.ind}) : super(key: key);

//   @override
//   State<BottomWidget> createState() => _BottomWidgetState();
// }

// class _BottomWidgetState extends State<BottomWidget> {
//   late int ind;

//   deleteAnnonce(int ind) async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/DELETE_ANNONCE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_ANNONCE": annonces[ind].id.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result != "0") {
//               Data.showSnack(msg: 'Annonce supprimé ...', color: Colors.green);
//               Navigator.of(context).pop('yes');
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

//   unpinAnnonce(int idAnnonce) async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/UNPIN_ANNONCE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     await http
//         .post(myUri, body: {
//           "ID_ANNONCE": idAnnonce.toString(),
//           "ID_USER": Data.currentUser!.idUser.toString()
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result == "0") {
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

//   pinAnnonce(int idAnnonce) async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/PIN_ANNONCE.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "ID_ANNONCE": idAnnonce.toString(),
//           "ID_USER": Data.currentUser!.idUser.toString()
//         })
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var result = response.body;
//             if (result == "0") {
//               AwesomeDialog(
//                       context: context,
//                       dialogType: DialogType.ERROR,
//                       showCloseIcon: true,
//                       title: 'Erreur',
//                       desc: "Probleme lors de l'ajout !!!")
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

//   @override
//   void initState() {
//     ind = widget.ind;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SafeArea(
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//               Row(children: [
//                 Expanded(
//                     child: Center(
//                         child: Text(annonces[ind].titre,
//                             maxLines: 2,
//                             style: GoogleFonts.laila(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             overflow: TextOverflow.clip))),
//                 IconButton(
//                     onPressed: () {
//                       var route = MaterialPageRoute(
//                           builder: (context) => ShowAnnonce(
//                               annonce: annonces[ind],
//                               enfants: enfants,
//                               groupes: groupes,
//                               parents: parents));
//                       Navigator.of(context)
//                           .push(route)
//                           .then((value) => Navigator.of(context).pop("update"));
//                     },
//                     icon: const Icon(Icons.zoom_out_map_rounded))
//               ]),
//               const Divider(),
//               Center(
//                   child: Text(annonces[ind].detail,
//                       maxLines: 6,
//                       style: GoogleFonts.laila(fontSize: 13),
//                       overflow: TextOverflow.clip)),
//               const Divider(),
//               Visibility(
//                   visible: Data.currentUser!.isAdmin,
//                   child: Row(children: [
//                     Icon(annonces[ind].visiblite == 1
//                         ? Icons.all_inclusive
//                         : annonces[ind].visiblite == 2
//                             ? Icons.people_alt_outlined
//                             : annonces[ind].visiblite == 3
//                                 ? Icons.group_rounded
//                                 : Icons.person_outline_outlined),
//                     const SizedBox(width: 5),
//                     Text(
//                         (annonces[ind].visiblite == 1)
//                             ? "Visible par tous le monde"
//                             : (annonces[ind].visiblite == 2)
//                                 ? "Visible aux groupes suivant : "
//                                 : (annonces[ind].visiblite == 3)
//                                     ? "Visible aux parents suivant : "
//                                     : "Visible aux enfants suivant : ",
//                         style: GoogleFonts.laila(
//                             fontSize: 12, fontWeight: FontWeight.bold))
//                   ])),
//               Visibility(
//                   visible: Data.currentUser!.isAdmin,
//                   child: Visibility(
//                       visible: (annonces[ind].visiblite != 1),
//                       child: Visibility(
//                           visible: (annonces[ind].visiblite == 2),
//                           child: const DetailsGroupes(),
//                           replacement: Visibility(
//                               visible: (annonces[ind].visiblite == 3),
//                               child: const DetailsPArents(),
//                               replacement: const DetailsEnfants())))),
//               Visibility(
//                   visible: Data.currentUser!.isAdmin, child: const Divider()),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//                 Visibility(
//                     visible: Data.currentUser!.isAdmin,
//                     child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.blue, onPrimary: Colors.white),
//                         onPressed: () {
//                           var route = MaterialPageRoute(
//                               builder: (context) =>
//                                   FicheAnnonce(id: annonces[ind].id));
//                           Navigator.of(context).push(route).then(
//                               (value) => Navigator.of(context).pop("update"));
//                         },
//                         icon: const Icon(Icons.edit),
//                         label: const Text("Modifier"))),
//                 ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                         primary: annonces[ind].pin ? Colors.grey : Colors.amber,
//                         onPrimary: Colors.white),
//                     onPressed: () {
//                       if (annonces[ind].pin) {
//                         unpinAnnonce(annonces[ind].id)
//                             .then((value) => Navigator.of(context).pop('yes'));
//                       } else {
//                         pinAnnonce(annonces[ind].id)
//                             .then((value) => Navigator.of(context).pop('yes'));
//                       }
//                     },
//                     icon: Icon(
//                         annonces[ind].pin ? Icons.flag_outlined : Icons.flag),
//                     label: Text(annonces[ind].pin ? "Lacher" : "Epingler")),
//                 Visibility(
//                     visible: Data.currentUser!.isAdmin,
//                     child: ElevatedButton.icon(
//                         style: ElevatedButton.styleFrom(
//                             primary: Colors.red, onPrimary: Colors.white),
//                         onPressed: () {
//                           AwesomeDialog(
//                                   context: context,
//                                   dialogType: DialogType.QUESTION,
//                                   showCloseIcon: true,
//                                   title: 'Confirmation',
//                                   btnOkText: "Oui",
//                                   btnCancelText: "Non",
//                                   btnOkOnPress: () {
//                                     deleteAnnonce(ind);
//                                   },
//                                   btnCancelOnPress: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   desc:
//                                       'Voulez vraiment supprimer cette annonce ?')
//                               .show();
//                         },
//                         icon: const Icon(Icons.delete),
//                         label: const Text("Supprimer")))
//               ])
//             ])));
//   }
// }

// class DetailsEnfants extends StatefulWidget {
//   const DetailsEnfants({Key? key}) : super(key: key);

//   @override
//   State<DetailsEnfants> createState() => _DetailsEnfantsState();
// }

// class _DetailsEnfantsState extends State<DetailsEnfants> {
//   bool loadingsub = false;

//   getMyEnfants() async {
//     setState(() {
//       loadingsub = true;
//     });
//     List s = annonces[selectedItem].strEnfants;
//     String serverDir = Data.getServerDirectory();
//     String pWhere = "";
//     enfants.clear();

//     for (var item in s) {
//       if (pWhere != "") {
//         pWhere += " OR ";
//       }
//       pWhere += " E.ID_ENFANT = " + item;
//     }
//     if (pWhere.isNotEmpty) {
//       pWhere = " AND (" + pWhere + " )";
//     }
//     var url = "$serverDir/GET_ENFANTS.php";
//     print("url=$url \n pWhere=$pWhere");
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
//                   sexe: sexe,
//                   etat: int.parse(m['ETAT']),
//                   adresse: m['ADRESSE'],
//                   isHomme: (sexe == 1),
//                   isFemme: (sexe == 2),
//                   photo: m['PHOTO']);
//               enfants.add(e);
//             }
//             setState(() {
//               loadingsub = false;
//             });
//           } else {
//             enfants.clear();
//             setState(() {
//               loadingsub = true;
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
//           enfants.clear();
//           setState(() {
//             loadingsub = true;
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
//     getMyEnfants();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("im in DetailsEnfants -----------------");
//     return loadingsub
//         ? const CircularProgressIndicator.adaptive()
//         : ListView.builder(
//             itemCount: enfants.length,
//             primary: false,
//             shrinkWrap: true,
//             itemBuilder: (context, i) => Card(
//                 elevation: 3,
//                 child: Padding(
//                     padding: const EdgeInsets.only(left: 10, bottom: 10),
//                     child: Row(children: [
//                       Text((i + 1).toString() + " -  ",
//                           style: GoogleFonts.laila(fontSize: 16)),
//                       SizedBox(
//                           width: 40,
//                           child: (enfants[i].photo == "")
//                               ? Image.asset("images/noPhoto.png")
//                               : CachedNetworkImage(
//                                   placeholder: (context, url) =>
//                                       CircularProgressIndicator(
//                                           color: Data
//                                               .darkColor[Random().nextInt(
//                                                   Data.darkColor.length - 1) +
//                                               1]),
//                                   imageUrl: Data.getImage(
//                                       enfants[i].photo, "PHOTO/ENFANT"))),
//                       const SizedBox(width: 5),
//                       Text(enfants[i].fullName,
//                           style: GoogleFonts.laila(fontSize: 16))
//                     ]))));
//   }
// }

// class DetailsGroupes extends StatefulWidget {
//   const DetailsGroupes({Key? key}) : super(key: key);

//   @override
//   State<DetailsGroupes> createState() => _DetailsGroupesState();
// }

// class _DetailsGroupesState extends State<DetailsGroupes> {
//   bool loadingsub = false;

//   getMyGroupes() async {
//     setState(() {
//       loadingsub = true;
//     });
//     List s = annonces[selectedItem].strGroupes;
//     String serverDir = Data.getServerDirectory();
//     String pWhere = "";
//     for (var item in s) {
//       if (pWhere != "") {
//         pWhere += " OR ";
//       }
//       pWhere += " E.ID_GROUPE = " + item;
//     }
//     if (pWhere.isNotEmpty) {
//       pWhere = " AND (" + pWhere + " )";
//     }
//     var url = "$serverDir/GET_GROUPES.php";
//     print("url=$url");
//     groupes.clear();
//     Uri myUri = Uri.parse(url);
//     await http
//         .post(myUri, body: {"WHERE": pWhere})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             Groupe e;
//             for (var m in responsebody) {
//               e = Groupe(
//                   designation: m['DESIGNATION'],
//                   etat: int.parse(m['ETAT']),
//                   id: int.parse(m['ID_GROUPE']));
//               groupes.add(e);
//             }
//             setState(() {
//               loadingsub = false;
//             });
//           } else {
//             groupes.clear();
//             setState(() {
//               loadingsub = false;
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
//           groupes.clear();
//           setState(() {
//             loadingsub = false;
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
//     getMyGroupes();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("im in DetailsGroupes -----------------");
//     return loadingsub
//         ? const CircularProgressIndicator.adaptive()
//         : ListView.builder(
//             itemBuilder: (context, i) => Card(
//                 elevation: 3,
//                 child: Padding(
//                     padding: const EdgeInsets.only(left: 10, bottom: 10),
//                     child: Text(
//                         (i + 1).toString() + " -  " + groupes[i].designation,
//                         style: GoogleFonts.laila(fontSize: 16)))),
//             itemCount: groupes.length,
//             primary: false,
//             shrinkWrap: true);
//   }
// }

// class DetailsPArents extends StatefulWidget {
//   const DetailsPArents({Key? key}) : super(key: key);

//   @override
//   State<DetailsPArents> createState() => _DetailsPArentsState();
// }

// class _DetailsPArentsState extends State<DetailsPArents> {
//   bool loadingsub = false;

//   getMyParents() async {
//     setState(() {
//       loadingsub = true;
//     });
//     List s = annonces[selectedItem].strParents;
//     String serverDir = Data.getServerDirectory();
//     String pWhere = "";
//     parents.clear();
//     for (var item in s) {
//       if (pWhere != "") {
//         pWhere += " OR ";
//       }
//       pWhere += " E.ID_PARENT = " + item;
//     }
//     if (pWhere.isNotEmpty) {
//       pWhere = " AND (" + pWhere + " )";
//     }
//     var url = "$serverDir/GET_PARENTS.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     await http
//         .post(myUri, body: {"WHERE": pWhere})
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
//               parents.add(p);
//             }
//             setState(() {
//               loadingsub = false;
//             });
//           } else {
//             parents.clear();
//             setState(() {
//               loadingsub = false;
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
//           parents.clear();
//           setState(() {
//             loadingsub = false;
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
//     getMyParents();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("im in DetailsPArents -----------------");
//     return loadingsub
//         ? const CircularProgressIndicator.adaptive()
//         : ListView.builder(
//             itemCount: parents.length,
//             primary: false,
//             shrinkWrap: true,
//             itemBuilder: (context, i) => Card(
//                 elevation: 3,
//                 child: Padding(
//                     padding: const EdgeInsets.only(left: 10, bottom: 10),
//                     child: Text(
//                         (i + 1).toString() + " -  " + parents[i].fullName,
//                         style: GoogleFonts.laila(fontSize: 16)))));
//   }
// }
