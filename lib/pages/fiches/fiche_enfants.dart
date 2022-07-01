// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'dart:math';
// import 'package:image_picker/image_picker.dart';
// import 'package:atlas_school/classes/data.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:path/path.dart' as p;

// class FicheEnfant extends StatefulWidget {
//   final int id;
//   const FicheEnfant({Key? key, required this.id}) : super(key: key);

//   @override
//   _FicheEnfantState createState() => _FicheEnfantState();
// }

// class _FicheEnfantState extends State<FicheEnfant> {
//   String myPhoto = "", nom = "", prenom = "", dateNaiss = "";
//   late int idEnfant;
//   DateTime? date;
//   int? sexe = 1;
//   TextEditingController txtNom = TextEditingController(text: "");
//   TextEditingController txtPrenom = TextEditingController(text: "");
//   TextEditingController txtDateNaiss = TextEditingController(text: "");
//   TextEditingController txtAdresse = TextEditingController(text: "");
//   bool loading = false,
//       valider = false,
//       selectPhoto = false,
//       isSwitched = true,
//       _valNom = false,
//       _valPrenom = false,
//       _valDateNaiss = false;

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
//             var responsebody = jsonDecode(response.body);
//             for (var m in responsebody) {
//               txtNom.text = m['NOM'];
//               txtPrenom.text = m['PRENOM'];
//               txtAdresse.text = m['ADRESSE'];
//               txtDateNaiss.text = m['DATE_NAISS'];
//               myPhoto = m['PHOTO'];
//               sexe = int.parse(m['SEXE']);
//               int petat = int.parse(m['ETAT']);
//               isSwitched = (petat == 1);
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
//           setState(() {
//             loading = false;
//           });
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

//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     idEnfant = widget.id;
//     myPhoto = "";
//     selectPhoto = false;
//     getEnfantInfo();
//     if (idEnfant == 0) {
//       setState(() {
//         loading = false;
//       });
//     }
//     super.initState();
//   }

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
//                           Colors.black.withOpacity(0.15), BlendMode.dstATop),
//                       image: const AssetImage('images/kid.jpg'))))),
//       GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: Scaffold(
//               backgroundColor: isSwitched
//                   ? Colors.transparent
//                   : Colors.grey.withOpacity(0.5),
//               resizeToAvoidBottomInset: true,
//               drawer: Data.myDrawer(context),
//               appBar: AppBar(
//                   backgroundColor: Colors.blueGrey,
//                   centerTitle: true,
//                   title: const Text("Fiche Enfant"),
//                   leading: IconButton(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                       icon: const Icon(Icons.arrow_back, color: Colors.white))),
//               body: bodyContent()))
//     ]));
//   }

//   pickPhoto(source) async {
//     final ImagePicker _picker = ImagePicker();
//     final image = await _picker.pickImage(source: source);
//     if (image == null) return;
//     setState(() {
//       myPhoto = image.path;
//       selectPhoto = true;
//     });
//   }

//   getPhoto(source) async {
//     print("i'm picking image");
//     pickPhoto(source);
//   }

//   Widget circularPhoto() {
//     return Center(
//         child: Stack(children: [
//       Container(
//           width: 130,
//           height: 130,
//           decoration: BoxDecoration(
//               border: Border.all(
//                   width: 4, color: Theme.of(context).scaffoldBackgroundColor),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     color: Colors.black.withOpacity(0.1),
//                     offset: const Offset(0, 10))
//               ],
//               image: myPhoto.isEmpty
//                   ? null
//                   : selectPhoto
//                       ? DecorationImage(
//                           image: FileImage(File(myPhoto)), fit: BoxFit.cover)
//                       : DecorationImage(
//                           image: NetworkImage(
//                               Data.getImage(myPhoto, "PHOTO/ENFANT")),
//                           fit: BoxFit.cover))),
//       Positioned(
//           bottom: 0,
//           right: 0,
//           child: Container(
//               height: 40,
//               width: 40,
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                       width: 4,
//                       color: Theme.of(context).scaffoldBackgroundColor),
//                   color: Colors.green),
//               child: InkWell(
//                   onTap: valider
//                       ? null
//                       : () {
//                           showModalBottomSheet(
//                               backgroundColor:
//                                   Theme.of(context).scaffoldBackgroundColor,
//                               context: context,
//                               builder: (context) {
//                                 return Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Padding(
//                                           padding: const EdgeInsets.all(20),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 InkWell(
//                                                     onTap: () {
//                                                       getPhoto(
//                                                           ImageSource.gallery);
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                     child: Ink(
//                                                         width:
//                                                             Data.widthScreen /
//                                                                 3,
//                                                         child: Column(
//                                                             children: const [
//                                                               Padding(
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .all(
//                                                                               8.0),
//                                                                   child: Icon(
//                                                                       Icons
//                                                                           .photo_album,
//                                                                       size:
//                                                                           30)),
//                                                               Text("Gallery",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           20))
//                                                             ]))),
//                                                 InkWell(
//                                                     onTap: () {
//                                                       getPhoto(
//                                                           ImageSource.camera);
//                                                       Navigator.of(context)
//                                                           .pop();
//                                                     },
//                                                     child: Ink(
//                                                         width:
//                                                             Data.widthScreen /
//                                                                 3,
//                                                         child: Column(
//                                                             children: const [
//                                                               Padding(
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .all(
//                                                                               8.0),
//                                                                   child: Icon(
//                                                                       Icons
//                                                                           .camera,
//                                                                       size:
//                                                                           30)),
//                                                               Text("Camera",
//                                                                   style: TextStyle(
//                                                                       fontSize:
//                                                                           20))
//                                                             ])))
//                                               ]))
//                                     ]);
//                               });
//                         },
//                   child:
//                       Ink(child: const Icon(Icons.edit, color: Colors.white)))))
//     ]));
//   }

//   updateEnfant() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/UPDATE_ENFANT.php";
//     print(url);
//     int petat = isSwitched ? 1 : 2;
//     Uri myUri = Uri.parse(url);
//     http.post(myUri, body: {
//       "ID_ENFANT": idEnfant.toString(),
//       "SEXE": sexe.toString(),
//       "NOM": txtNom.text.toUpperCase(),
//       "PRENOM": txtPrenom.text.toUpperCase(),
//       "DATE_NAISS": txtDateNaiss.text,
//       "ADRESSE": txtAdresse.text,
//       "ETAT": petat.toString(),
//       "EXT": selectPhoto ? p.extension(myPhoto) : "",
//       "DATA": selectPhoto ? base64Encode(File(myPhoto).readAsBytesSync()) : ""
//     }).then((response) async {
//       if (response.statusCode == 200) {
//         var responsebody = response.body;
//         print("EnfantResponse=$responsebody");
//         if (responsebody != "0") {
//           Data.showSnack(
//               msg: 'Information mis à jours ...', color: Colors.green);
//           Navigator.of(context).pop();
//         } else {
//           setState(() {
//             valider = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme lors de la mise a jour des informations !!!')
//               .show();
//         }
//       } else {
//         setState(() {
//           valider = false;
//         });
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 showCloseIcon: true,
//                 title: 'Erreur',
//                 desc: 'Probleme de Connexion avec le serveur !!!')
//             .show();
//       }
//     }).catchError((error) {
//       print("erreur : $error");
//       setState(() {
//         valider = false;
//       });
//       AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               showCloseIcon: true,
//               title: 'Erreur',
//               desc: 'Probleme de Connexion avec le serveur !!!')
//           .show();
//     });
//   }

//   existEnfant() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/EXIST_ENFANT.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {
//           "NOM": txtNom.text,
//           "PRENOM": txtPrenom.text,
//           "DATE_NAISS": txtDateNaiss.text,
//           "ID_ENFANT": idEnfant.toString(),
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
//               if (idEnfant == 0) {
//                 insertEnfant();
//               } else {
//                 updateEnfant();
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
//                   desc: "Cet Enfant existe déjà !!!");
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

//   insertEnfant() async {
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/INSERT_ENFANT.php";
//     print(url);
//     int petat = isSwitched ? 1 : 2;
//     Uri myUri = Uri.parse(url);
//     http.post(myUri, body: {
//       "NOM": txtNom.text.toUpperCase(),
//       "PRENOM": txtPrenom.text.toUpperCase(),
//       "DATE_NAISS": txtDateNaiss.text,
//       "ADRESSE": txtAdresse.text,
//       "SEXE": sexe.toString(),
//       "ETAT": petat.toString(),
//       "EXT": selectPhoto ? p.extension(myPhoto) : "",
//       "DATA": selectPhoto ? base64Encode(File(myPhoto).readAsBytesSync()) : ""
//     }).then((response) async {
//       if (response.statusCode == 200) {
//         var responsebody = response.body;
//         print("EnfantResponse=$responsebody");
//         if (responsebody != "0") {
//           Data.showSnack(msg: 'Enfant inscris ...', color: Colors.green);
//           Navigator.of(context).pop();
//         } else {
//           setState(() {
//             valider = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: "Probleme lors de l'ajout !!!")
//               .show();
//         }
//       } else {
//         setState(() {
//           valider = false;
//         });
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 showCloseIcon: true,
//                 title: 'Erreur',
//                 desc: 'Probleme de Connexion avec le serveur !!!')
//             .show();
//       }
//     }).catchError((error) {
//       print("erreur : $error");
//       setState(() {
//         valider = false;
//       });
//       AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               showCloseIcon: true,
//               title: 'Erreur',
//               desc: 'Probleme de Connexion avec le serveur !!!')
//           .show();
//     });
//   }

//   saveEnfant() {
//     setState(() {
//       _valNom = txtNom.text.isEmpty;
//       _valPrenom = txtPrenom.text.isEmpty;
//       _valDateNaiss = txtDateNaiss.text.isEmpty;
//       valider = true;
//     });

//     if (_valNom || _valPrenom || _valDateNaiss) {
//       AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               showCloseIcon: true,
//               title: 'Erreur',
//               desc: 'Veuillez remplir tous les champs obligatoire !!!')
//           .show();
//       setState(() {
//         valider = false;
//       });
//     } else {
//       existEnfant();
//     }
//   }

//   bodyContent() {
//     return Visibility(
//         visible: loading,
//         child: Center(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//               Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   child: CircularProgressIndicator(
//                       color: Data.darkColor[
//                           Random().nextInt(Data.darkColor.length - 1) + 1])),
//               const Text("Chargement en cours ...")
//             ])),
//         replacement: Padding(
//             padding: EdgeInsets.all(Data.widthScreen / 30),
//             child: ListView(primary: false, shrinkWrap: true, children: [
//               circularPhoto(),
//               Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
//                   child: TextField(
//                       enabled: !valider,
//                       controller: txtNom,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.text,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: InputDecoration(
//                           errorText: _valNom ? 'Champs Obligatoire' : null,
//                           prefixIcon: const Padding(
//                               padding: EdgeInsets.only(right: 4),
//                               child: Icon(Icons.supervised_user_circle_outlined,
//                                   color: Colors.black)),
//                           contentPadding: const EdgeInsets.only(bottom: 3),
//                           labelText: "Nom",
//                           labelStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           hintText: "Nom",
//                           hintStyle:
//                               const TextStyle(fontSize: 14, color: Colors.grey),
//                           floatingLabelBehavior:
//                               FloatingLabelBehavior.always))),
//               Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10, right: 10, bottom: 30),
//                   child: TextField(
//                       enabled: !valider,
//                       controller: txtPrenom,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.text,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: InputDecoration(
//                           errorText: _valPrenom ? 'Champs Obligatoire' : null,
//                           prefixIcon: const Padding(
//                               padding: EdgeInsets.only(right: 4),
//                               child: Icon(Icons.supervised_user_circle_outlined,
//                                   color: Colors.black)),
//                           contentPadding: const EdgeInsets.only(bottom: 3),
//                           labelText: "Prénom",
//                           labelStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           hintText: "Prénom",
//                           hintStyle:
//                               const TextStyle(fontSize: 14, color: Colors.grey),
//                           floatingLabelBehavior:
//                               FloatingLabelBehavior.always))),
//               Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10, right: 10, bottom: 30),
//                   child: TextField(
//                       enabled: !valider,
//                       onTap: () {
//                         datePicker();
//                       },
//                       readOnly: true,
//                       controller: txtDateNaiss,
//                       textInputAction: TextInputAction.next,
//                       keyboardType: TextInputType.datetime,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: InputDecoration(
//                           errorText:
//                               _valDateNaiss ? 'Champs Obligatoire' : null,
//                           prefixIcon: const Padding(
//                               padding: EdgeInsets.only(right: 4),
//                               child: Icon(Icons.date_range_rounded,
//                                   color: Colors.black)),
//                           suffixIcon: IconButton(
//                               onPressed: () {
//                                 datePicker();
//                               },
//                               icon: const Icon(Icons.date_range_outlined)),
//                           contentPadding: const EdgeInsets.only(bottom: 3),
//                           labelText: "Date de Naissance",
//                           labelStyle: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           hintText: "Date de Naissance",
//                           hintStyle:
//                               const TextStyle(fontSize: 14, color: Colors.grey),
//                           floatingLabelBehavior:
//                               FloatingLabelBehavior.always))),
//               Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10, right: 10, bottom: 30),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         const Text("Sexe",
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black)),
//                         const SizedBox(width: 25),
//                         Radio(
//                             groupValue: sexe,
//                             value: 1,
//                             onChanged: (value) {
//                               if (!valider) {
//                                 setState(() {
//                                   sexe = value as int?;
//                                 });
//                               }
//                             }),
//                         InkWell(
//                             child: const Text("Homme"),
//                             onTap: () {
//                               if (!valider) {
//                                 setState(() {
//                                   sexe = 1;
//                                 });
//                               }
//                             }),
//                         Radio(
//                             groupValue: sexe,
//                             value: 2,
//                             onChanged: (value) {
//                               if (!valider) {
//                                 setState(() {
//                                   sexe = value as int?;
//                                 });
//                               }
//                             }),
//                         InkWell(
//                             child: const Text("Femme"),
//                             onTap: () {
//                               if (!valider) {
//                                 setState(() {
//                                   sexe = 2;
//                                 });
//                               }
//                             })
//                       ])),
//               Padding(
//                   padding:
//                       const EdgeInsets.only(left: 10, right: 10, bottom: 30),
//                   child: TextField(
//                       enabled: !valider,
//                       maxLines: null,
//                       controller: txtAdresse,
//                       textInputAction: TextInputAction.newline,
//                       keyboardType: TextInputType.multiline,
//                       style: const TextStyle(fontSize: 16, color: Colors.black),
//                       decoration: const InputDecoration(
//                           prefixIcon: Padding(
//                               padding: EdgeInsets.only(right: 4),
//                               child: Icon(Icons.gps_fixed, color: Colors.blue)),
//                           contentPadding: EdgeInsets.only(bottom: 3),
//                           labelText: "Adresse",
//                           labelStyle: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                           hintText: "Adresse",
//                           hintStyle:
//                               TextStyle(fontSize: 14, color: Colors.grey),
//                           floatingLabelBehavior:
//                               FloatingLabelBehavior.always))),
//               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                 Switch(
//                     value: isSwitched,
//                     onChanged: (value) {
//                       if (!valider) {
//                         setState(() {
//                           isSwitched = !isSwitched;
//                         });
//                       }
//                     }),
//                 const SizedBox(width: 5),
//                 Text(isSwitched ? "Actif" : "Inactif",
//                     style: const TextStyle(color: Colors.black))
//               ]),
//               Visibility(
//                   visible: valider,
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                             color: Data.darkColor[
//                                 Random().nextInt(Data.darkColor.length - 1) +
//                                     1]),
//                         const SizedBox(width: 20),
//                         const Text("validation en cours ...")
//                       ]),
//                   replacement: Container(
//                       margin: EdgeInsets.only(top: Data.widthScreen / 40),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 30),
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                         color: Colors.black, width: 1),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(20))),
//                                 child: TextButton(
//                                     onPressed: () {
//                                       AwesomeDialog(
//                                               context: context,
//                                               dialogType: DialogType.QUESTION,
//                                               showCloseIcon: true,
//                                               btnCancelText: "Non",
//                                               btnOkText: "Oui",
//                                               btnCancelOnPress: () {},
//                                               btnOkOnPress: () {
//                                                 setState(() {
//                                                   Navigator.of(context).pop();
//                                                 });
//                                               },
//                                               desc:
//                                                   'Voulez-vous vraiment annuler tous les changements !!!')
//                                           .show();
//                                     },
//                                     child: const Text("Annuler",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.black)))),
//                             Container(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 30),
//                                 decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     border: Border.all(
//                                         color: Colors.black, width: 1),
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(20))),
//                                 child: TextButton(
//                                     onPressed: saveEnfant,
//                                     child: const Text("Valider",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.white))))
//                           ])))
//             ])));
//   }

//   datePicker() {
//     showDatePicker(
//             context: context,
//             initialDate: date ?? DateTime.now(),
//             firstDate: DateTime(1800),
//             lastDate: DateTime.now())
//         .then((value) {
//       if (value != null) {
//         date = value;
//         setState(() {
//           txtDateNaiss.text = DateFormat('yyyy-MM-dd').format(date!);
//         });
//       }
//     });
//   }
// }
