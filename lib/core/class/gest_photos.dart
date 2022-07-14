// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as p;

class GestGalleryImages {
  static List<File?> myImages = [];
  static bool _uploading = false;

  static uploadGalleryImages() async {
    print("start fetching for new images to upload ...");
    if (User.idUser != 0 &&
        !_uploading &&
        !User.isParent &&
        myImages.isNotEmpty) {
      print("     *******************  uploading image ****************");
      send(myImages[0]);
    } else {
      print(User.idUser == 0
          ? "you are not connected"
          : _uploading
              ? "Someone else is uploading ..."
              : "waiting for images ...");
    }
    const delayDuration = Duration(seconds: 2);
    Timer(delayDuration, uploadGalleryImages);
    print("finish fetching for new images to upload ...");
  }

  static void send(File? image) async {
    String serverDir = AppData.getServerDirectory();
    HomePageController controller = Get.find();
    final String url = "$serverDir/UPLOAD_GALLERY.php";
    print(url);
    Uri myUri = Uri.parse(url);
    var body = {};
    body['data'] = base64Encode(image!.readAsBytesSync());
    body['ext'] = p.extension(image.path);
    body['ID_USER'] = User.idUser.toString();
    http.post(myUri, body: body).then((result) {
      if (result.statusCode == 200) {
        print(result.body);
        controller.imageUploaded();
        print("ImageGallery : result=" + result.body);
      } else {
        print("ImageGallery : Error Uploading Image");
      }
      _uploading = false;
    }).catchError((error) {
      print("ImageGallery : erreur : $error");
    });
    myImages.removeAt(0);
  }
}

class AnnonceImage {
  late String base64Image, extension;
  AnnonceImage({required this.base64Image, required this.extension});
}
