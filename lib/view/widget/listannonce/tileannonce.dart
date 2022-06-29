import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/listannonce/image1listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image2listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image3listannonce.dart';
import 'package:atlas_school/view/widget/listannonce/image4listannonce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TileAnnonce extends GetView<ListAnnonceController> {
  final int index;
  const TileAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    builder: (controller) => Visibility(
                        visible: annonce.pin,
                        child: const Icon(Icons.flag, color: Colors.amber)))
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
              Visibility(
                  visible: annonce.detail.isNotEmpty,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible: annonce.detail.isNotEmpty,
                  child: Text(annonce.detail,
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodyText2,
                      overflow: TextOverflow.clip)),
              const SizedBox(height: 10),
              // yarham babak khaliha haka ay dega koun traja3ha visibility
              SizedBox(
                  height: AppSizes.heightScreen * 0.4,
                  child: annonce.images.isNotEmpty
                      ? nbImages == 1
                          ? Image1ListAnnonce(index: index)
                          : nbImages == 2
                              ? Image2ListAnnonce(index: index)
                              : nbImages == 3
                                  ? Image3ListAnnonce(index: index)
                                  : Image4ListAnnonce(index: index)
                      : Container())
            ]));
  }
}