// // ignore_for_file: avoid_print

// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/classes/user.dart';
// import 'package:atlas_school/pages/fiches/fiche_new_enseignant.dart';
// import 'package:atlas_school/pages/fiches/fiche_new_parent.dart';
// import 'package:atlas_school/pages/widgets/privacy_policy.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class LoginPageOld extends StatefulWidget {
//   const LoginPageOld({Key? key}) : super(key: key);

//   @override
//   _LoginPageStateOld createState() => _LoginPageStateOld();
// }

// class _LoginPageStateOld extends State<LoginPageOld> {
//   String userName = "", password = "", oldPass = "";
//   String? serverIP = "", userPref = "", passPref = "";
//   bool showPassword = false,
//       isSwitched = true,
//       reconnect = false,
//       err = true,
//       oldInfoLoaded = false,
//       infoLoaded = false;
//   late SharedPreferences prefs;
//   TextEditingController txtUserName = TextEditingController(text: "");
//   TextEditingController txtPassword = TextEditingController(text: "");

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                     title: Row(children: const [
//                       Icon(Icons.exit_to_app_sharp, color: Colors.red),
//                       Padding(
//                           padding: EdgeInsets.only(left: 8.0),
//                           child: Text('Etes-vous sur ?'))
//                     ]),
//                     content: const Text(
//                         "Voulez-vous vraiment quitter l'application ?"),
//                     actions: <Widget>[
//                       TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text('Non',
//                               style: TextStyle(color: Colors.red))),
//                       TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: const Text('Oui',
//                               style: TextStyle(color: Colors.green)))
//                     ]))) ??
//         false;
//   }

//   @override
//   void initState() {
//     print("init login");
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     if (Data.production) {
//       userName = "";
//       txtUserName.text = "";
//       txtPassword.text = "";
//       password = "";
//     }
//     getSharedPrefs();
//     if (!kIsWeb) {
//       AwesomeNotifications().isNotificationAllowed().then((isAllowed) => {
//             if (!isAllowed)
//               {
//                 showDialog(
//                     context: Data.myContext,
//                     builder: (context) => AlertDialog(
//                             actions: [
//                               TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: const Text("Ne pas Autoriser",
//                                       style: TextStyle(
//                                           color: Colors.grey, fontSize: 18))),
//                               TextButton(
//                                   onPressed: () => AwesomeNotifications()
//                                       .requestPermissionToSendNotifications()
//                                       .then((_) => Navigator.of(context).pop()),
//                                   child: const Text("Autoriser",
//                                       style: TextStyle(
//                                           color: Colors.teal,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold)))
//                             ],
//                             title: const Text("Autoriser les notifications"),
//                             content: const Text(
//                                 "Notre application souhaite vous envoyer des notifications")))
//               }
//           });
//     } //initPlatformState();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
//   // Platform messages are asynchronous, so we initialize in an async method.
//   // initPlatformState() async {
//   //   Data.myKey = await Data.cryptor.generateRandomKey();
//   //  print("randomKey: ${Data.myKey}");
// //  }

//   getSharedPrefs() async {
//     prefs = await SharedPreferences.getInstance();
//     serverIP = prefs.getString('ServerIp');
//     var local = prefs.getString('LocalIP');
//     var intenet = prefs.getString('InternetIP');
//     var mode = prefs.getInt('NetworkMode');
//     mode ??= 2;
//     Data.setNetworkMode(mode);
//     local ??= "192.168.1.152";
//     intenet ??= "atlasschool.dz";
//     serverIP ??= mode == 1 ? local : intenet;
//     if (serverIP != "") Data.setServerIP(serverIP);
//     if (local != "") Data.setLocalIP(local);
//     if (intenet != "") Data.setInternetIP(intenet);
//     print("serverIP=$serverIP");
//     if (serverIP == "" && !Data.production) {
//       Navigator.of(context).pushNamed("setting");
//     }
//     userPref = prefs.getString('LastUser');
//     passPref = prefs.getString('LastPass');
//     bool connect = prefs.getBool('LastConnected') ?? false;
//     if (userPref != null && userPref!.isNotEmpty) {
//       setState(() {
//         userName = userPref!;
//         password = passPref!;
//         reconnect = connect;
//         txtUserName.text = userName;
//         txtPassword.text = password;
//         infoLoaded = password.isNotEmpty;
//       });
//       if (connect) {
//         existUser();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Data.myContext = context;
//     Data.setSizeScreen(context);
//     return SafeArea(
//         child: WillPopScope(
//             onWillPop: _onWillPop,
//             child: GestureDetector(
//                 onTap: () {
//                   FocusScope.of(context).unfocus();
//                 },
//                 child: Scaffold(
//                     resizeToAvoidBottomInset: true,
//                     appBar: AppBar(
//                         leading: const Icon(Icons.vpn_key, color: Colors.white),
//                         title: const Text("Athentification",
//                             style: TextStyle(color: Colors.white)),
//                         centerTitle: true,
//                         actions: Data.production
//                             ? null
//                             : [
//                                 IconButton(
//                                     icon: const FaIcon(FontAwesomeIcons.cogs,
//                                         color: Colors.white),
//                                     onPressed: () {
//                                       Navigator.of(context)
//                                           .pushNamed("setting");
//                                     })
//                               ]),
//                     body: bodyContent()))));
//   }

//   bodyContent() {
//     final double logoHeight = Data.heightScreen / 20;
//     return ListView(children: [
//       Center(
//           child: Container(
//               child: Image.asset('images/atlas_school.jpg', fit: BoxFit.cover),
//               margin: EdgeInsets.only(top: logoHeight),
//               height: Data.heightScreen / 4)),
//       Visibility(
//           visible: reconnect,
//           child: Container(
//               margin: EdgeInsets.only(top: Data.heightScreen - logoHeight) / 4,
//               child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(
//                         color: Data.darkColor[
//                             Random().nextInt(Data.darkColor.length - 1) + 1]),
//                     const SizedBox(width: 24),
//                     const Text("Connexion en cours ...",
//                         style: TextStyle(fontSize: 18))
//                   ])),
//           replacement: Container(
//               margin: EdgeInsets.symmetric(
//                   horizontal: Data.widthScreen / 10,
//                   vertical: Data.heightScreen / 20),
//               child: Card(
//                   elevation: 10,
//                   child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(mainAxisSize: MainAxisSize.min, children: [
//                         TextField(
//                             onChanged: (value) => userName = value,
//                             enabled: !reconnect,
//                             controller: txtUserName,
//                             textInputAction: TextInputAction.next,
//                             keyboardType: TextInputType.text,
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.white),
//                             decoration: InputDecoration(
//                                 border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(40),
//                                     borderSide: const BorderSide(
//                                         width: 5, color: Colors.black)),
//                                 filled: true,
//                                 fillColor: Colors.blueAccent.shade100,
//                                 prefixIcon: const Padding(
//                                     padding: EdgeInsets.only(right: 4),
//                                     child:
//                                         Icon(Icons.code, color: Colors.white)),
//                                 contentPadding:
//                                     const EdgeInsets.only(bottom: 3),
//                                 hintText: "Nom d'Utilisateur",
//                                 hintStyle: const TextStyle(
//                                     fontSize: 14, color: Colors.white),
//                                 floatingLabelBehavior:
//                                     FloatingLabelBehavior.always)),
//                         const SizedBox(height: 10),
//                         Focus(
//                             onFocusChange: (value) {
//                               if (!value) {
//                                 if (password.isEmpty) {
//                                   password = oldPass;
//                                   txtPassword.text = password;
//                                   infoLoaded = true;
//                                 }
//                                 oldInfoLoaded = false;
//                               } else {
//                                 if (infoLoaded) {
//                                   setState(() {
//                                     oldPass = password;
//                                     password = "";
//                                     txtPassword.text = "";
//                                     oldInfoLoaded = true;
//                                     infoLoaded = false;
//                                   });
//                                 }
//                               }
//                             },
//                             child: TextField(
//                                 onChanged: (value) => password = value,
//                                 enabled: !reconnect,
//                                 controller: txtPassword,
//                                 obscureText: !showPassword,
//                                 textInputAction: TextInputAction.next,
//                                 keyboardType: TextInputType.visiblePassword,
//                                 style: const TextStyle(
//                                     fontSize: 16, color: Colors.white),
//                                 decoration: InputDecoration(
//                                     border: OutlineInputBorder(
//                                         borderRadius: BorderRadius.circular(40),
//                                         borderSide: const BorderSide(
//                                             width: 5, color: Colors.black)),
//                                     filled: true,
//                                     suffixIcon: infoLoaded
//                                         ? null
//                                         : IconButton(
//                                             onPressed: () {
//                                               setState(() {
//                                                 showPassword = !showPassword;
//                                               });
//                                             },
//                                             icon: const Icon(
//                                                 Icons.remove_red_eye,
//                                                 color: Colors.white)),
//                                     fillColor: Colors.blueAccent.shade100,
//                                     prefixIcon: const Padding(
//                                         padding: EdgeInsets.only(right: 4),
//                                         child: Icon(Icons.password,
//                                             color: Colors.white)),
//                                     contentPadding:
//                                         const EdgeInsets.only(bottom: 3),
//                                     hintText: "Mot de Passe",
//                                     hintStyle: const TextStyle(
//                                         fontSize: 14, color: Colors.white),
//                                     floatingLabelBehavior:
//                                         FloatingLabelBehavior.always))),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Switch(
//                                   value: isSwitched,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       isSwitched = !isSwitched;
//                                     });
//                                   }),
//                               const SizedBox(width: 5),
//                               const Text("Rester connecté",
//                                   style: TextStyle(color: Colors.black))
//                             ]),
//                         const SizedBox(height: 20),
//                         Container(
//                             padding: const EdgeInsets.symmetric(vertical: 4),
//                             child: Wrap(children: [
//                               const Text("Vous n'avez pas un Compte !!!  ",
//                                   style: TextStyle(color: Colors.black)),
//                               GestureDetector(
//                                   onTap: btnInscrire,
//                                   child: const Text("Inscrire",
//                                       style: TextStyle(
//                                           color: Colors.amber,
//                                           fontWeight: FontWeight.bold,
//                                           decoration:
//                                               TextDecoration.underline)))
//                             ]))
//                       ]))))),
//       Visibility(
//           visible: !reconnect,
//           child: Container(
//               padding: EdgeInsets.symmetric(horizontal: Data.widthScreen / 8),
//               alignment: Alignment.center,
//               child: ElevatedButton(
//                   style: ButtonStyle(backgroundColor:
//                       MaterialStateProperty.resolveWith<Color>(
//                           (Set<MaterialState> states) {
//                     if (states.contains(MaterialState.pressed)) {
//                       return Colors.indigo;
//                     } else if (states.contains(MaterialState.disabled)) {
//                       return Colors.grey;
//                     }
//                     return Colors.blue; // Use the component's default.
//                   }), minimumSize: MaterialStateProperty.resolveWith<Size>(
//                       (Set<MaterialState> states) {
//                     return const Size.fromHeight(72);
//                   }), shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
//                       (Set<MaterialState> states) {
//                     return const StadiumBorder();
//                   }), textStyle: MaterialStateProperty.resolveWith<TextStyle>(
//                       (Set<MaterialState> states) {
//                     return const TextStyle(fontSize: 24, color: Colors.white);
//                   })),
//                   onPressed: () {
//                     existUser();
//                   },
//                   child: const Text("Connecter")))),
//       const SizedBox(height: 10)
//     ]);
//   }

//   btnInscrire() async {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) => SafeArea(
//             child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   const Padding(
//                       padding: EdgeInsets.only(bottom: 15),
//                       child: Text("Je suis un : ",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold))),
//                   const SizedBox(height: 10),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                             onTap: () async {
//                               var route = MaterialPageRoute(
//                                   builder: (context) => const FicheNewParent());
//                               Navigator.of(context)
//                                   .push(route)
//                                   .then((value) => Navigator.pop(context));
//                             },
//                             child: Ink(
//                                 padding: const EdgeInsets.all(8),
//                                 color: Colors.amber,
//                                 child: Row(children: const [
//                                   Icon(Icons.group_outlined,
//                                       color: Colors.white),
//                                   SizedBox(width: 10),
//                                   FittedBox(
//                                       child: Text("Parent",
//                                           style: TextStyle(
//                                               fontSize: 20,
//                                               color: Colors.white)))
//                                 ]))),
//                         InkWell(
//                             onTap: () async {
//                               var route = MaterialPageRoute(
//                                   builder: (context) =>
//                                       const FicheNewEnseignant());
//                               Navigator.of(context)
//                                   .push(route)
//                                   .then((value) => Navigator.pop(context));
//                             },
//                             child: Ink(
//                                 padding: const EdgeInsets.all(8),
//                                 color: Colors.brown,
//                                 child: Row(children: const [
//                                   Icon(Icons.person_pin_outlined,
//                                       color: Colors.white),
//                                   SizedBox(width: 10),
//                                   FittedBox(
//                                       child: Text("Enseignant",
//                                           style: TextStyle(
//                                               fontSize: 20,
//                                               color: Colors.white)))
//                                 ])))
//                       ])
//                 ]))));
//   }

//   existUser() async {
//     setState(() {
//       reconnect = true;
//     });
//     Data.currentUser = null;
//     err = true;
//     serverIP = Data.getServerIP();
//     if (serverIP != "") {
//       String serverDir = Data.getServerDirectory();
//       final String url = "$serverDir/EXIST_USER.php";
//       print(url);
//       Uri myUri = Uri.parse(url);
//       http.post(myUri, body: {"USERNAME": userName, "PASSWORD": password}).then(
//           (response) async {
//         if (response.statusCode == 200) {
//           var responsebody = jsonDecode(response.body);
//           print("EXIST_USER=$responsebody");
//           String id = "", name = "", phone = "";
//           int etat = 0, type = 0, idParent = 0, msgBlock = 0, idEns = 0;
//           for (var m in responsebody) {
//             id = m['ID_USER'];
//             name = m['NAME'];
//             phone = m['PHONE'];
//             msgBlock = int.parse(m['BLOCK_MSG']);
//             etat = int.parse(m['ETAT']);
//             idEns = int.parse(m['ID_ENSEIGNANT']);
//             idParent = int.parse(m['ID_PARENT']);
//             type = int.parse(m['TYPE']);
//           }
//           if (id == "") {
//             setState(() {
//               reconnect = false;
//             });
//             AwesomeDialog(
//                     width: min(Data.widthScreen, 400),
//                     context: context,
//                     dialogType: DialogType.ERROR,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc: 'Nom d' 'utilisateur ou mot de passe invalide !!!')
//                 .show();
//           } else if (etat == 1) {
//             print("Its Ok ----- Connected ----------------");
//             String? privacy = prefs.getString('Privacy' + id) ?? "";
//             if (privacy.isEmpty) {
//               var route = PageRouteBuilder(
//                   pageBuilder: (context, animation, secondaryAnimation) {
//                 return PrivacyPolicy(id: id);
//               });
//               await Navigator.push(context, route);
//             }
//             conectedUser(idEns, msgBlock, idParent, id, type, name, phone);
//           } else {
//             setState(() {
//               reconnect = false;
//             });
//             print("etat = $etat");
//             AwesomeDialog(
//                     width: min(Data.widthScreen, 400),
//                     context: context,
//                     dialogType: DialogType.WARNING,
//                     showCloseIcon: true,
//                     title: 'Erreur',
//                     desc:
//                         "Utilisateur inactif !!! \nVeuillez contacter l'administration ...")
//                 .show();
//           }
//         } else {
//           setState(() {
//             reconnect = false;
//           });
//           AwesomeDialog(
//                   context: context,
//                   dialogType: DialogType.ERROR,
//                   showCloseIcon: true,
//                   title: 'Erreur',
//                   desc: 'Probleme lors de la connexion avec le serveur !!!')
//               .show();
//         }
//       }).catchError((error) {
//         print("erreur : $error");
//         setState(() {
//           reconnect = false;
//         });
//         print("error : ${e.toString()}");
//         AwesomeDialog(
//                 context: context,
//                 dialogType: DialogType.ERROR,
//                 showCloseIcon: true,
//                 title: 'Erreur',
//                 desc: 'Probleme de Connexion avec le serveur !!!')
//             .show();
//       });
//     } else {
//       setState(() {
//         reconnect = false;
//       });
//       AwesomeDialog(
//               context: context,
//               dialogType: DialogType.ERROR,
//               showCloseIcon: true,
//               title: 'Erreur',
//               desc:
//                   'Adresse de serveur introuvable \n Configuer les paramêtres !!!')
//           .show();
//     }
//     if (err) {
//       setState(() {});
//     }
//   }

//   void openHomePage() {
//     if (Data.currentUser!.isEns) {
//       Navigator.of(context).pushReplacementNamed("homeEns");
//     } else {
//       Navigator.of(context).pushReplacementNamed("homeAdmin");
//     }
//   }

//   void conectedUser(idEns, msgBlock, idParent, id, type, name, phone) async {
//     if (isSwitched) {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       userPref = userName;
//       passPref = password;
//       prefs.setString('LastUser', userPref!);
//       prefs.setString('LastPass', passPref!);
//       prefs.setBool('LastConnected', true);
//     }
//     User u = User(
//         idEns: idEns,
//         msgBlock: (msgBlock == 1),
//         etat: 1,
//         idParent: idParent,
//         idUser: int.parse(id),
//         isAdmin: (type == 2),
//         isEns: (type == 3),
//         isParent: (type == 1),
//         parentName: name,
//         parentPhone: phone,
//         password: password,
//         type: type,
//         username: userName);
//     Data.setCurrentUser(u);
//     //Data.setUserKey();
//     if (!Data.currentUser!.isAdmin) {
//       Data.getAdminUser();
//     }

//     if (Data.currentUser!.isParent) {
//       Data.getListEnfant();
//     }
//     err = false;
//     openHomePage();
//   }
// }
