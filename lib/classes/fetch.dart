// // ignore_for_file: avoid_print

// import 'dart:async';
// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/classes/notifications.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class Fetch {
//   static late bool newMessage = false;
//   static late SharedPreferences _prefs;
//   static late List<String>? _msgs, _annces;
//   static bool _fetchSms = false, _fetchAnnonce = false;

//   static void fetchNewMessages() async {
//     while (true) {
//       if (Data.currentUser == null || _fetchSms) {
//         print(_fetchSms
//             ? "Someone else is fetching Messages ..."
//             : "you are not connected");
//       } else {
//         _getNewMessages();
//       }
//       await Future.delayed(const Duration(seconds: 11));
//     }
//   }

//   static _getNewMessages() async {
//     _fetchSms = true;
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_NEW_MESSAGES.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_USER": Data.currentUser!.idUser.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             String msgs = "";
//             for (var m in responsebody) {
//               msgs = m['MSG'];
//               if (msgs.isNotEmpty) {
//                 List<String> idMessages = msgs.split(",");
//                 _existMessages(idMessages);
//               }
//             }
//             print("responsebody=$responsebody");
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//         });
//     _fetchSms = false;
//   }

//   static _existMessages(List<String> idMessages) async {
//     _prefs = await SharedPreferences.getInstance();
//     String prefKey = 'messages_' + Data.currentUser!.idUser.toString();
//     _msgs = _prefs.getStringList(prefKey);
//     if (_msgs == null) {
//       _addMessages(idMessages);
//     } else {
//       List<String> list = [];
//       for (var item in idMessages) {
//         if (!_msgs!.contains(item)) {
//           list.add(item);
//         }
//       }
//       if (list.isNotEmpty) {
//         _addMessages(list);
//       }
//     }
//   }

//   static _addMessages(List<String> list) async {
//     _prefs = await SharedPreferences.getInstance();
//     String prefKey = 'messages_' + Data.currentUser!.idUser.toString();
//     _msgs = _prefs.getStringList(prefKey);
//     _msgs ??= [];
//     for (var item in list) {
//       _msgs!.add(item);
//     }
//     _prefs.setStringList(prefKey, _msgs!);
//     cancelMessageNotification();
//     createMessageNotification();
//     newMessage = true;
//   }

//   static void fetchNewAnnounce() async {
//     while (true) {
//       if (Data.currentUser == null ||
//           _fetchAnnonce ||
//           !Data.currentUser!.isParent) {
//         print(_fetchAnnonce
//             ? "Someone else is fetching Announces ..."
//             : Data.currentUser == null
//                 ? "Fetch New Annonce : you are not connected as PARENT"
//                 : "Fetch New Annonce : you are not connected");
//       } else {
//         _getNewAnnounces();
//       }
//       await Future.delayed(const Duration(seconds: 17));
//     }
//   }

//   static _getNewAnnounces() async {
//     _fetchAnnonce = true;
//     String serverDir = Data.getServerDirectory();
//     var url = "$serverDir/GET_NEW_ANNONCES.php";
//     print("url=$url");
//     Uri myUri = Uri.parse(url);
//     http
//         .post(myUri, body: {"ID_USER": Data.currentUser!.idUser.toString()})
//         .timeout(Duration(seconds: Data.timeOut))
//         .then((response) async {
//           if (response.statusCode == 200) {
//             var responsebody = jsonDecode(response.body);
//             String annc = "";
//             for (var m in responsebody) {
//               annc = m['MSG'];
//               if (annc.isNotEmpty) {
//                 List<String> idAnnonces = annc.split(",");
//                 _existAnnonces(idAnnonces);
//               }
//             }
//             print("responsebody=$responsebody");
//           }
//         })
//         .catchError((error) {
//           print("erreur : $error");
//         });
//     _fetchAnnonce = false;
//   }

//   static _existAnnonces(List<String> idAnnonces) async {
//     _prefs = await SharedPreferences.getInstance();
//     String prefKey = 'annonces_' + Data.currentUser!.idUser.toString();
//     _annces = _prefs.getStringList(prefKey);
//     if (_annces == null) {
//       _addAnnonces(idAnnonces);
//     } else {
//       List<String> list = [];
//       for (var item in idAnnonces) {
//         if (!_annces!.contains(item)) {
//           list.add(item);
//         }
//       }
//       if (list.isNotEmpty) {
//         _addAnnonces(list);
//       }
//     }
//   }

//   static _addAnnonces(List<String> list) async {
//     _prefs = await SharedPreferences.getInstance();
//     String prefKey = 'annonces_' + Data.currentUser!.idUser.toString();
//     _annces = _prefs.getStringList(prefKey);
//     _annces ??= [];
//     for (var item in list) {
//       _annces!.add(item);
//     }
//     _prefs.setStringList(prefKey, _annces!);
//     cancelAnnounceNotification();
//     createAnnounceNotification();
//   }
// }
