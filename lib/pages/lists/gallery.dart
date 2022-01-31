// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/gest_gallery_images.dart';
import 'package:atlas_school/classes/photo.dart';
import 'package:atlas_school/pages/widgets/widget_gallery.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GalleriePage extends StatefulWidget {
  const GalleriePage({Key? key}) : super(key: key);

  @override
  _GalleriePageState createState() => _GalleriePageState();
}

List<Photo> gallery = [];

class _GalleriePageState extends State<GalleriePage> {
  bool loading = false, error = false;

  listenNewPhotos() async {
    while (!Data.currentUser!.isParent) {
      if (!GestGalleryImages.isThereNewUploaded) {
        await Future.delayed(const Duration(seconds: 2));
      } else {
        GestGalleryImages.isThereNewUploaded = false;
        getAllPhotos();
      }
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    getAllPhotos();
    listenNewPhotos();
    super.initState();
  }

  getAllPhotos() async {
    setState(() {
      loading = true;
      error = false;
    });
    String serverDir = Data.getServerDirectory();
    var url = "$serverDir/GET_GALLERY.php";
    print("url=$url");
    gallery.clear();
    Uri myUri = Uri.parse(url);
    http
        .post(myUri, body: {"WHERE": ""})
        .timeout(Duration(seconds: Data.timeOut))
        .then((response) async {
          if (response.statusCode == 200) {
            var responsebody = jsonDecode(response.body);
            Photo e;
            for (var m in responsebody) {
              e = Photo(
                  chemin: m['CHEMIN'],
                  date: m['DATE_PHOTO'],
                  heure: m['HEURE_PHOTO'],
                  id: int.parse(m['ID_PHOTO']));
              gallery.add(e);
            }
            setState(() {
              loading = false;
            });
          } else {
            setState(() {
              gallery.clear();
              loading = false;
              error = true;
            });
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    showCloseIcon: true,
                    title: 'Erreur',
                    desc: 'Probleme de Connexion avec le serveur !!!')
                .show();
          }
        })
        .catchError((error) {
          print("erreur : $error");
          setState(() {
            gallery.clear();
            loading = false;
            error = true;
          });
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  showCloseIcon: true,
                  title: 'Erreur',
                  desc: 'Probleme de Connexion avec le serveur !!!')
              .show();
        });
  }

  @override
  Widget build(BuildContext context) {
    if (!Data.currentUser!.isAdmin) {
      Data.myContext = context;
    }
    Data.setSizeScreen(context);
    return SafeArea(
        child: Scaffold(
            drawer: Data.myDrawer(context),
            appBar: AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                titleSpacing: 0,
                title: const Center(child: Text("Gallerie des Photos")),
                actions: [
                  IconButton(
                      onPressed: () {
                        getAllPhotos();
                      },
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white))
                ],
                leading: (Data.canPop)
                    ? IconButton(
                        onPressed: () {
                          Data.canPop = false;
                          Navigator.of(Data.myContext).pop();
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white))
                    : null),
            floatingActionButton: !Data.currentUser!.isParent
                ? FloatingActionButton(
                    backgroundColor: Colors.black,
                    onPressed: btnInsert,
                    child: const Icon(Icons.add))
                : null,
            body: Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: bodyContent())));
  }

  bodyContent() {
    //String date = "", heure = "";
    return Visibility(
        visible: loading,
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                        color: Data.darkColor[
                            Random().nextInt(Data.darkColor.length - 1) + 1]),
                  )),
              const Text("Chargement en cours ...")
            ])),
        replacement: Visibility(
            visible: gallery.isEmpty,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                          error
                              ? "Erreur de connexion !!!"
                              : "Aucune Photo !!!!",
                          style: TextStyle(
                              fontSize: 22,
                              color: error ? Colors.red : Colors.black,
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: getAllPhotos,
                      icon: const FaIcon(FontAwesomeIcons.sync,
                          color: Colors.white),
                      label: const Text("Actualiser"))
                ]),
            replacement: ListView(children: [
              Wrap(
                  children: gallery
                      .map((item) {
                        return Padding(
                            padding: const EdgeInsets.all(4),
                            child: SizedBox(
                                height: Data.heightScreen / 3,
                                child: InkWell(
                                    onTap: () {
                                      openGallery(gallery.indexOf(item));
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Image.network(
                                            Data.getImage(
                                                item.chemin, "GALLERY"),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                              child: CircularProgressIndicator(
                                                  color: Data.darkColor[Random()
                                                          .nextInt(Data
                                                                  .darkColor
                                                                  .length -
                                                              1) +
                                                      1]));
                                        }, fit: BoxFit.contain)))));
                        //     date = item.date;
                        //     heure = item.heure;
                      })
                      .toList()
                      .cast<Widget>())
            ])));
  }

  pickImages() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images == null) return;
    for (var image in images) {
      final imageTemp = File(image.path);
      GestGalleryImages.myImages.add(imageTemp);
    }
    setState(() {});
  }

  captureImage() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() {
      GestGalleryImages.myImages.add(imageTemp);
    });
  }

  btnInsert() {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            pickImages();
                            Navigator.of(context).pop();
                          },
                          child: Column(children: const [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.photo_album, size: 30)),
                            Text("Gallery", style: TextStyle(fontSize: 20))
                          ])),
                      InkWell(
                          onTap: () {
                            captureImage();
                            Navigator.of(context).pop();
                          },
                          child: Column(children: const [
                            Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.camera, size: 30)),
                            Text("Camera", style: TextStyle(fontSize: 20))
                          ]))
                    ]))
          ]);
        });
  }

  openGallery(int i) {
    //print("i'm heer in openGallery with i =" + i.toString());
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (_) => GalleryWidget(
                index: i, myImages: gallery, delete: true, folder: "GALLERY")))
        .then((value) {
      if (value == "delete") getAllPhotos();
    });
  }
}
