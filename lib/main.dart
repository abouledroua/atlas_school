// ignore_for_file: avoid_print

import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/fetch.dart';
import 'package:atlas_school/pages/fiches/fiche_message.dart';
import 'package:atlas_school/pages/home_admin.dart';
import 'package:atlas_school/pages/authentification/login.dart';
import 'package:atlas_school/pages/home_ens.dart';
import 'package:atlas_school/pages/home_user.dart';
import 'package:atlas_school/pages/lists/gallery.dart';
import 'package:atlas_school/pages/lists/list_annonce.dart';
import 'package:atlas_school/pages/lists/list_enfants.dart';
import 'package:atlas_school/pages/lists/list_enseignants.dart';
import 'package:atlas_school/pages/lists/list_groupes.dart';
import 'package:atlas_school/pages/lists/list_messages.dart';
import 'package:atlas_school/pages/lists/list_parents.dart';
import 'package:atlas_school/pages/settings.dart';
import 'package:atlas_school/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      'resource://drawable/icone',
      [
        NotificationChannel(
            channelKey: 'msg_channel',
            channelName: 'Message notifications',
            channelDescription:
                'Notification channel for receiving new message',
            defaultColor: Colors.green.shade600,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            icon: 'resource://drawable/icone',
            soundSource: 'resource://raw/res_sms',
            ledColor: Colors.white,
            onlyAlertOnce: true,
            defaultPrivacy: NotificationPrivacy.Private,
            vibrationPattern: lowVibrationPattern),
        NotificationChannel(
            channelKey: 'upload_Image_channel',
            channelName: 'Upload Image notifications',
            channelDescription: 'Notification channel for uploading images',
            defaultColor: Colors.amber,
            importance: NotificationImportance.High,
            icon: 'resource://drawable/icone',
            channelShowBadge: true,
            playSound: true,
            soundSource: 'resource://raw/res_upload',
            onlyAlertOnce: true,
            ledColor: Colors.yellow),
        NotificationChannel(
            channelKey: 'annonce_channel',
            channelName: 'Annonce notifications',
            channelDescription:
                'Notification channel for alerts about new announce',
            defaultColor: Colors.indigo,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            icon: 'resource://drawable/icone',
            soundSource: 'resource://raw/res_announce',
            defaultPrivacy: NotificationPrivacy.Private,
            ledColor: Colors.blue)
      ],
      debug: true);
  Fetch.fetchNewMessages();
  Fetch.fetchNewAnnounce();
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  AwesomeNotifications().actionStream.listen((event) {
    print("actionStream=${event.channelKey}");
    switch (event.channelKey) {
      case "msg_channel":
        if (Data.currentUser != null && Data.currentUser!.isAdmin) {
          Navigator.pushAndRemoveUntil(
              Data.myContext,
              MaterialPageRoute(builder: (_) => const ListMessages()),
              (route) => route.isFirst);
        } else {
          Navigator.pushAndRemoveUntil(
              Data.myContext,
              MaterialPageRoute(
                  builder: (_) => FicheMessage(
                      idUser: 1, parentName: Data.currentUser!.parentName)),
              (route) => route.isFirst);
        }
        break;
      case "annonce_channel":
        Navigator.pushAndRemoveUntil(
            Data.myContext,
            MaterialPageRoute(builder: (_) => const ListAnnonce()),
            (route) => route.isFirst);
        break;
      default:
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Atlas School',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 32, 99, 162),
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500)),
            inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(borderSide: BorderSide(width: 1))),
            textTheme: const TextTheme(
                caption: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
                headline4: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black))),
        routes: {
          "ListMessages": (context) => const ListMessages(),
          "ListAnnonces": (context) => const ListAnnonce(),
          "ListEnfants": (context) => const ListEnfant(),
          "ListParents": (context) => const ListParent(),
          "ListPhotos": (context) => const GalleriePage(),
          "ListEnseignants": (context) => const ListEnseignant(),
          "ListGroupes": (context) => const ListGroupes(),
          "homeAdmin": (context) => const HomeAdmin(),
          "homeUser": (context) => const HomeUser(),
          "homeEns": (context) => const HomeEns(),
          "login": (context) => const LoginPage(),
          "setting": (context) => const SettingPage()
        },
        home: const WelcomePage());
  }
}
