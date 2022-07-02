import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/listannonce/image1listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image2listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image3listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image4listannonce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TileAnnonce extends StatelessWidget {
  final int index;
  const TileAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListAnnonceController>(builder: (controller) {
      Annonce annonce = controller.annonces[index];
      int nbImages = annonce.images.length;
      return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      child: Text(annonce.titre,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip)),
                  GetBuilder<ListAnnonceController>(
                      builder: (controller) => IconButton(
                          onPressed: (!User.isAdmin)
                              ? null
                              : () {
                                  controller.pinAnnonce(index: index);
                                },
                          icon: Icon(Icons.flag,
                              color: annonce.pin
                                  ? AppColor.amber
                                  : User.isAdmin
                                      ? AppColor.grey.withOpacity(0.5)
                                      : Colors.transparent)))
                ]),
                Row(children: [
                  Icon(annonce.visiblite == 1
                      ? Icons.all_inclusive
                      : annonce.visiblite == 2
                          ? Icons.people_alt_outlined
                          : annonce.visiblite == 3
                              ? Icons.group_rounded
                              : Icons.person_outline_outlined),
                  const SizedBox(width: 5),
                  Text(AppData.printDate(annonce.dateTime),
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.clip)
                ]),
                if (annonce.detail.isNotEmpty) const SizedBox(height: 10),
                if (annonce.detail.isNotEmpty)
                  Text(annonce.detail,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.clip),
                if (!annonce.images.isNotEmpty) const SizedBox(height: 10),
                // yarham babak khaliha haka ay dega koun traja3ha visibility
                if (annonce.images.isNotEmpty)
                  SizedBox(
                      height: AppSizes.heightScreen * 0.4,
                      child: nbImages == 1
                          ? Image1ListAnnonce(index: index)
                          : nbImages == 2
                              ? Image2ListAnnonce(index: index)
                              : nbImages == 3
                                  ? Image3ListAnnonce(index: index)
                                  : Image4ListAnnonce(index: index))
              ]));
    });
  }
}
