// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constant/data.dart';
import 'image_annonce.dart';
import 'user.dart';

class GestAnnounceImages {
  static List<ImageAnnounce> myImages = [];
  static bool _uploading = false,
      _wasUploading = false,
      isThereNewUploaded = false;

  static uploadAnnonceImages() async {
    while (User.isAdmin) {
      if (myImages.isEmpty || _uploading) {
        print(_uploading
            ? "ImageAnnonce : Someone else is uploading ..."
            : "ImageAnnonce : Waiting for upload");
        if (myImages.isEmpty && _wasUploading) {
          // createUploadNotification('chargerment des Images est terminé ...');
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "chargerment des Images est terminé ...",
              color: AppColor.amber);
        }
        _wasUploading = myImages.isNotEmpty;
        await Future.delayed(const Duration(seconds: 5));
      } else {
        //     cancelUploadNotification();
        if (!_wasUploading) {
          AppData.mySnackBar(
              title: 'Fiche Annonce',
              message: "En cours de chargement des images ...",
              color: AppColor.amber);
        }
        _wasUploading = true;
        send(myImages[0]);
        await Future.delayed(const Duration(seconds: 2));
      }
    }
  }

  static void send(ImageAnnounce item) async {
    String serverDir = AppData.getServerDirectory();
    final String url = "$serverDir/UPLOAD_ANNONCE_IMAGES.php";
    print(url);
    Uri myUri = Uri.parse(url);
    var body = {};
    body['ID_ANNONCE'] = item.idAnnonce.toString();
    body['data'] = item.base64Image;
    body['ext'] = item.extension;
    http.post(myUri, body: body).then((result) {
      if (result.statusCode == 200) {
        print('result.body=${result.body}');
        isThereNewUploaded = true;
        int index = getIndex(myImages[0].idAnnonce);
        String filename = result.body.removeAllWhitespace.replaceAll('"', "");
        ListAnnonceController controller = Get.find();
        controller.addImage(filename: filename, index: index);
        myImages.removeAt(0);
      } else {
        print("ImageAnnonce : Error Uploading Image");
      }
      _uploading = false;
    }).catchError((error) {
      print("ImageAnnonce : erreur : $error");
    });
  }

  static int getIndex(int pid) {
    ListAnnonceController controller = Get.find();
    for (var i = 0; i < controller.annonces.length; i++) {
      if (controller.annonces[i].id == pid) return i;
    }
    return 0;
  }
}
