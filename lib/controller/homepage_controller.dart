// ignore_for_file: avoid_print

import 'dart:async';

import 'package:atlas_school/controller/user_controller.dart';
import 'package:atlas_school/core/class/gest_annonce_images.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/dataservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  int pageIndex = 0, oldPage = 0;

  final item0 = GlobalKey();
  final item1 = GlobalKey();
  final item2 = GlobalKey();
  final item3 = GlobalKey();
  final item4 = GlobalKey();
  final item5 = GlobalKey();
  final item6 = GlobalKey();

  Future initialService() async {
    await Get.putAsync(() => DataServices().init());
  }

  repeatMyFunction() {
    myFunc().then((_) {
      const oneSec = Duration(seconds: 1);
      if (User.idUser != 0) Timer(oneSec, repeatMyFunction);
      print("finish ...");
    });
  }

  Future myFunc() async {
    print('start ...');
    await Future.delayed(const Duration(seconds: 4));
  }

  Future<bool> onWillPop() async {
    return (await showDialog(
            context: Get.context!,
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
                          onPressed: () => Get.back(result: false),
                          child: const Text('Non',
                              style: TextStyle(color: Colors.red))),
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Oui',
                              style: TextStyle(color: Colors.green)))
                    ]))) ??
        false;
  }

  changePage(newIndex) {
    oldPage = pageIndex;
    pageIndex = newIndex;

    if (pageIndex == 7) {
      AppData.logout();
    }
    update();
  }

  scrolltoitem() async {
    late BuildContext? mycontext = item0.currentContext;
    switch (pageIndex) {
      case 0:
        mycontext = item0.currentContext;
        break;
      case 1:
        mycontext = item1.currentContext;
        break;
      case 2:
        mycontext = item2.currentContext;
        break;
      case 3:
        mycontext = item3.currentContext;
        break;
      case 4:
        mycontext = item4.currentContext;
        break;
      case 5:
        mycontext = item5.currentContext;
        break;
      case 6:
        mycontext = item6.currentContext;
        break;
    }
    if (mycontext != null) {
      await Scrollable.ensureVisible(mycontext, alignment: 0.5);
    }
  }

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    await initialService();
    Get.put(UserController());
    repeatMyFunction();
    GestAnnounceImages.uploadAnnonceImages();
    super.onInit();
  }
}
