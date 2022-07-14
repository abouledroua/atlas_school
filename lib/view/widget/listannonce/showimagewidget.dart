import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/screen/photoview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowImageWidget extends StatelessWidget {
  final Annonce annonce;
  final int index;
  const ShowImageWidget({Key? key, required this.annonce, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          List<Photo> gallery = [];
          for (var item in annonce.images) {
            gallery.add(Photo(chemin: item, date: '', heure: '', id: 0));
          }
          Get.to(() => PhotoViewPage(
              index: index,
              folder: "ANNONCE",
              myImages: gallery,
              delete: false));
        },
        child: Center(
            child: Ink(
                padding: const EdgeInsets.all(2),
                child: CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl:
                        AppData.getImage(annonce.images[index], "ANNONCE"),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator()))));
  }
}
