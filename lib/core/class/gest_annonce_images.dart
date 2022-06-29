// ignore_for_file: avoid_print

import 'package:atlas_school/classes/notifications.dart';
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
    while (User.isParent) {
      if (myImages.isEmpty || _uploading) {
        print(_uploading
            ? "ImageAnnonce : Someone else is uploading ..."
            : "ImageAnnonce : Waiting for upload");
        if (myImages.isEmpty && _wasUploading) {
          createUploadNotification('chargerment des Images est terminé ...');
        }
        _wasUploading = myImages.isNotEmpty;
        await Future.delayed(const Duration(seconds: 5));
      } else {
        cancelUploadNotification();
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
        isThereNewUploaded = true;
      } else {
        print("ImageAnnonce : Error Uploading Image");
      }
      _uploading = false;
    }).catchError((error) {
      print("ImageAnnonce : erreur : $error");
    });
    myImages.removeAt(0);
  }
}
