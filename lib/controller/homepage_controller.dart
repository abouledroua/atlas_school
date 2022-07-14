// ignore_for_file: avoid_print

import 'dart:async';
import 'package:atlas_school/controller/fichemessage_controller.dart';
import 'package:atlas_school/controller/listphotos_controller.dart';
import 'package:atlas_school/controller/user_controller.dart';
import 'package:atlas_school/core/class/gest_annonce_images.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/core/services/dataservice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/collection.dart';

class HomePageController extends GetxController {
  int pageIndex = 0, oldPage = 0;
  bool newMessage = false;
  int nbImagesTotal = 0, nbImageUploaded = 0;
  List<int> idMessageUnread = [], idParentUnread = [];

  final item0 = GlobalKey();
  final item1 = GlobalKey();
  final item2 = GlobalKey();
  final item3 = GlobalKey();
  final item4 = GlobalKey();
  final item5 = GlobalKey();
  final item6 = GlobalKey();

  addImage() {
    nbImagesTotal++;
    update();
  }

  imageUploaded() {
    nbImageUploaded++;
    if (nbImageUploaded == nbImagesTotal) {
      nbImagesTotal = 0;
      nbImageUploaded = 0;
    }
    update();
    ListPhotosController contrphot = Get.find();
    contrphot.getAllPhotos();
  }

  updateUnreadMsg({required List<int> idp, required List<int> idm}) {
    bool thesamelists = (idp.isEmpty &&
            idm.isEmpty &&
            idMessageUnread.isEmpty &&
            idParentUnread.isEmpty) ||
        (listsEqual(idp, idParentUnread) && listsEqual(idm, idMessageUnread));

    if (!thesamelists) {
      idParentUnread = idp;
      idMessageUnread = idm;
    }
    bool val = idMessageUnread.isNotEmpty;
    if (val != newMessage) {
      print('updateNewMessage');
      newMessage = val;
      update();
      if (idm.isNotEmpty) {
        FicheMessageController contrmsg = Get.find();
        contrmsg.getMessages();
      }
    }
  }

  Future initialService() async {
    await Get.putAsync(() => DataServices().init());
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

  initiate() async {
    AppSizes.setSizeScreen(Get.context);
    await initialService();
    Get.put(UserController());
    GestAnnounceImages.uploadAnnonceImages();
  }

  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initiate();
    super.onInit();
  }
}
