// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/classes/annonce.dart';
import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/classes/enfant.dart';
import 'package:atlas_school/classes/groupe.dart';
import 'package:atlas_school/classes/parent.dart';
import 'package:atlas_school/classes/photo.dart';
import 'package:atlas_school/pages/widgets/widget_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowAnnonce extends StatefulWidget {
  final Annonce annonce;
  final List<Groupe> groupes;
  final List<Parent> parents;
  final List<Enfant> enfants;
  const ShowAnnonce(
      {Key? key,
      required this.annonce,
      required this.enfants,
      required this.groupes,
      required this.parents})
      : super(key: key);

  @override
  _ShowAnnonceState createState() => _ShowAnnonceState();
}

late Annonce annonce;
late List<Groupe> groupes;
late List<Parent> parents;
late List<Enfant> enfants;

class _ShowAnnonceState extends State<ShowAnnonce> {
  @override
  void initState() {
    annonce = widget.annonce;
    groupes = widget.groupes;
    parents = widget.parents;
    enfants = widget.enfants;
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text(annonce.titre)),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  Center(
                      child: Text(annonce.titre,
                          style: GoogleFonts.laila(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip)),
                  const Divider(),
                  Center(
                      child: Text(annonce.detail,
                          style: GoogleFonts.laila(fontSize: 13),
                          overflow: TextOverflow.clip)),
                  const Divider(),
                  Visibility(
                      visible: Data.currentUser!.isAdmin,
                      child: Row(children: [
                        Icon(annonce.visiblite == 1
                            ? Icons.all_inclusive
                            : annonce.visiblite == 2
                                ? Icons.people_alt_outlined
                                : annonce.visiblite == 3
                                    ? Icons.group_rounded
                                    : Icons.person_outline_outlined),
                        const SizedBox(width: 5),
                        Text(
                            (annonce.visiblite == 1)
                                ? "Visible par tous le monde"
                                : (annonce.visiblite == 2)
                                    ? "Visible aux groupes suivant : "
                                    : (annonce.visiblite == 3)
                                        ? "Visible aux parents suivant : "
                                        : "Visible aux enfants suivant : ",
                            style: GoogleFonts.laila(
                                fontSize: 12, fontWeight: FontWeight.bold))
                      ])),
                  Visibility(
                      visible: Data.currentUser!.isAdmin,
                      child: Visibility(
                          visible: (annonce.visiblite != 1),
                          child: Visibility(
                              visible: (annonce.visiblite == 2),
                              child: showListGroupeSelected(),
                              replacement: Visibility(
                                  visible: (annonce.visiblite == 3),
                                  child: showListParentSelected(),
                                  replacement: showListEnfantSelected())))),
                  Visibility(
                      visible: annonce.images.isNotEmpty, child: imageTile())
                ]))));
  }

  imageTile() {
    return Wrap(
        children: annonce.images
            .map((item) => Padding(
                padding: const EdgeInsets.all(4),
                child: SizedBox(
                    height: Data.heightScreen / 3,
                    child: Hero(
                        tag: 'myHero${annonce.images.indexOf(item)}',
                        child: GestureDetector(
                            onTap: () async {
                              List<Photo> gallery = [];
                              for (var item in annonce.images) {
                                gallery.add(Photo(
                                    chemin: item, date: '', heure: '', id: 0));
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => GalleryWidget(
                                      index: annonce.images.indexOf(item),
                                      myImages: gallery,
                                      delete: false,
                                      folder: "ANNONCE")));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                            color: Data
                                                .darkColor[Random().nextInt(
                                                    Data.darkColor.length - 1) +
                                                1])),
                                    imageUrl:
                                        Data.getImage(item, "ANNONCE"))))))))
            .toList()
            .cast<Widget>());
  }

  showListGroupeSelected() {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    (i + 1).toString() + " -  " + groupes[i].designation,
                    style: GoogleFonts.laila(fontSize: 16)))),
        itemCount: groupes.length,
        primary: false,
        shrinkWrap: true);
  }

  showListParentSelected() {
    return ListView.builder(
        itemCount: parents.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text((i + 1).toString() + " -  " + parents[i].fullName,
                    style: GoogleFonts.laila(fontSize: 16)))));
  }

  showListEnfantSelected() {
    return ListView.builder(
        itemCount: enfants.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(children: [
                  Text((i + 1).toString() + " -  ",
                      style: GoogleFonts.laila(fontSize: 16)),
                  SizedBox(
                      width: 40,
                      child: (enfants[i].photo == "")
                          ? Image.asset("images/noPhoto.png")
                          : CachedNetworkImage(
                              //  fit: BoxFit.contain,
                              placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                      color: Data.darkColor[Random().nextInt(
                                              Data.darkColor.length - 1) +
                                          1])),
                              imageUrl: Data.getImage(
                                  enfants[i].photo, "PHOTO/ENFANT"))),
                  const SizedBox(width: 5),
                  Text(enfants[i].fullName,
                      style: GoogleFonts.laila(fontSize: 16))
                ]))));
  }
}
