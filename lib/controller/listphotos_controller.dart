// ignore_for_file: avoid_print

import 'dart:io';
import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/class/gest_photos.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ListPhotosController extends GetxController {
  bool loading = false, error = false, searching = false;
  List<MyPhotoList> listPhotos = [];
  List<Photo> allPhotos = [];

  updateBooleans({required newloading, required newerror}) {
    loading = newloading;
    error = newerror;
    update();
  }

  getAllPhotos() async {
    updateBooleans(newloading: true, newerror: false);
    String serverDir = AppData.getServerDirectory();
    var url = "$serverDir/GET_GALLERY.php";
    print("url=$url");
    listPhotos.clear();
    allPhotos.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: AppData.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Photo e;
            String date = "", myDate = "";
            int index = -1;
            for (var m in responsebody) {
              date = m['DATE_PHOTO'];
              e = Photo(
                  chemin: m['CHEMIN'],
                  date: m['DATE_PHOTO'],
                  heure: m['HEURE_PHOTO'],
                  id: int.parse(m['ID_PHOTO']));
              if (index == -1 || myDate != date) {
                index++;
                myDate = date;
                listPhotos.add(MyPhotoList(date: myDate, photos: []));
              }
              listPhotos[index].photos.add(e);
              allPhotos.add(e);
            }
            updateBooleans(newloading: false, newerror: false);
          } else {
            updateBooleans(newloading: false, newerror: true);
            listPhotos.clear();
            allPhotos.clear();
            AppData.mySnackBar(
                title: 'Gallery de Photos',
                message: "Probleme de Connexion avec le serveur !!!",
                color: AppColor.red);
          }
        })
        .catchError((error) {
          print("erreur : $error");
          updateBooleans(newloading: false, newerror: true);
          listPhotos.clear();
          allPhotos.clear();
          AppData.mySnackBar(
              title: 'Gallery de Photos',
              message: "Probleme de Connexion avec le serveur !!!",
              color: AppColor.red);
        });
  }

  myActions() {
    return [
      PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: Row(children: const [
                      Icon(Icons.refresh),
                      SizedBox(width: 10),
                      Text("Actualiser")
                    ]))
              ],
          offset: const Offset(30, 30),
          elevation: 2,
          onSelected: (value) {
            switch (value) {
              case 1:
                getAllPhotos();
                break;
              default:
            }
          })
    ];
  }

  pickPhotos() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    HomePageController controller = Get.find();
    if (images == null) return;
    for (var image in images) {
      final imageTemp = File(image.path);
      GestGalleryImages.myImages.add(imageTemp);
      controller.addImage();
    }
  }

  captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = File(image.path);
    GestGalleryImages.myImages.add(imageTemp);
    HomePageController controller = Get.find();
    controller.addImage();
  }

  @override
  void onInit() {
    WidgetsFlutterBinding.ensureInitialized();
    AppSizes.setSizeScreen(Get.context);
    getAllPhotos();
    super.onInit();
  }
}

class MyPhotoList {
  String date;
  List<Photo> photos;
  MyPhotoList({required this.date, required this.photos});
}
