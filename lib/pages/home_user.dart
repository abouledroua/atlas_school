// ignore_for_file: avoid_print

import 'dart:math';
import 'package:atlas_school/pages/fiches/fiche_message.dart';
import 'package:atlas_school/pages/lists/gallery.dart';
import 'package:atlas_school/pages/lists/list_annonce.dart';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/pages/settings.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({Key? key}) : super(key: key);

  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  late List<Widget> screens = [];

  List<Widget> items = <Widget>[];

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Row(children: const [
                      Icon(Icons.exit_to_app_sharp, color: Colors.red),
                      Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Etes-vous sur ?'))
                    ]),
                    content: const Text(
                        "Voulez-vous vraiment quitter l'application ?"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Non',
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Oui',
                              style: TextStyle(color: Colors.green)))
                    ]))) ??
        false;
  }

  Color getItemColor() {
    switch (Data.index) {
      case 0:
        return Colors.indigo;
      case 1:
        return Colors.green.shade600;
      case 2:
        return Colors.black;
      default:
        return Colors.blue;
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
    Data.index = 0;
    majScreen();
    majItems();
    super.initState();
  }

  majItems() {
    items = <Widget>[
      const Icon(Icons.announcement_outlined, color: Colors.white),
      const Icon(Icons.sms, color: Colors.white),
      const Icon(Icons.photo, color: Colors.white),
    ];
    if (!Data.production) {
      items.add(const FaIcon(FontAwesomeIcons.cogs, color: Colors.white));
    }
  }

  majScreen() {
    if (Data.errorAdmin) {
      Data.getAdminUser();
    }
    screens = [
      const ListAnnonce(),
      Data.loadingAdmin
          ? Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  CircularProgressIndicator(
                      color: Data.darkColor[
                          Random().nextInt(Data.darkColor.length - 1) + 1]),
                  const SizedBox(width: 20),
                  const Text("Charegement en cours ...")
                ]))
          : FicheMessage(idUser: Data.adminId!, parentName: "Administration"),
      const GalleriePage(),
      const SettingPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    Data.myContext = context;
    Data.setSizeScreen(context);
    return Container(
        color: getItemColor(),
        child: SafeArea(
            child: WillPopScope(
                onWillPop: _onWillPop,
                child: ClipRect(
                    child: Scaffold(
                        resizeToAvoidBottomInset: true,
                        bottomNavigationBar: CurvedNavigationBar(
                            buttonBackgroundColor: getItemColor(),
                            color: getItemColor(),
                            index: Data.index,
                            backgroundColor: Colors.white,
                            height: 60,
                            items: items,
                            onTap: (value) {
                              setState(() {
                                Data.index = value;
                                majScreen();
                                majItems();
                              });
                            }),
                        body: screens[Data.index])))));
  }
}