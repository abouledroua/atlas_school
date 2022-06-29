// // ignore_for_file: avoid_print

// import 'dart:io';
// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/classes/notifications.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:path/path.dart' as p;

// class GestGalleryImages {
//   static List<File?> myImages = [];
//   static bool _uploading = false;
//   static bool isThereNewUploaded = false;

//   static uploadGalleryImages() async {
//     while (Data.currentUser != null && !Data.currentUser!.isParent) {
//       if (myImages.isEmpty || _uploading) {
//         print(_uploading
//             ? "ImageGallery : Someone else is uploading ..."
//             : "ImageGallery : Waiting for upload");
//         if (myImages.isEmpty) {
//           cancelUploadNotification();
//         }
//         await Future.delayed(const Duration(seconds: 5));
//       } else {
//         createUploadNotification('En cours de chargement des images ...');
//         send(myImages[0]);
//         await Future.delayed(const Duration(seconds: 2));
//       }
//     }
//   }

//   static void send(File? image) async {
//     String serverDir = Data.getServerDirectory();
//     final String url = "$serverDir/UPLOAD_GALLERY.php";
//     print(url);
//     Uri myUri = Uri.parse(url);
//     var body = {};
//     body['data'] = base64Encode(image!.readAsBytesSync());
//     body['ext'] = p.extension(image.path);
//     body['ID_USER'] = Data.currentUser!.idUser.toString();
//     http.post(myUri, body: body).then((result) {
//       if (result.statusCode == 200) {
//         print(result.body);
//         print("ImageGallery : result=" + result.body);
//         isThereNewUploaded = true;
//       } else {
//         print("ImageGallery : Error Uploading Image");
//       }
//       _uploading = false;
//     }).catchError((error) {
//       print("ImageGallery : erreur : $error");
//     });
//     myImages.removeAt(0);
//   }
// }

// class AnnonceImage {
//   late String base64Image, extension;
//   AnnonceImage({required this.base64Image, required this.extension});
// }
