// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyPhotoViewController extends GetxController {
  int index = 0;
  PageController? pageController;

  MyPhotoViewController({required this.index});

  updateIndex(newIndex) {
    index = newIndex;
    update();
  }

  deletePhoto({required Photo image}) async {
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/DELETE_GALLERY.php";
    print(url);
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"ID_PHOTO": image.id.toString()})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var result = response.body;
            if (result != "0") {
              AppData.mySnackBar(
                  title: 'Gallery',
                  message: "Image supprimé ...",
                  color: AppColor.green);
              Get.back();
            } else {
              AppData.mySnackBar(
                  title: 'Gallery',
                  message: "Probleme lors de la suppression !!!",
                  color: AppColor.red);
            }
          } else {
            AppData.mySnackBar(
                title: 'Gallery',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          AppData.mySnackBar(
              title: 'Gallery',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    pageController = PageController(initialPage: index);
    super.onInit();
  }
}
