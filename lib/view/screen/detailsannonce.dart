import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/photoview.dart';
import 'package:atlas_school/view/widget/detailsannonce/listenfantsdetailsannonce.dart';
import 'package:atlas_school/view/widget/detailsannonce/listgroupedetailsannonce.dart';
import 'package:atlas_school/view/widget/detailsannonce/listparentsdetailsannonce.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsAnnoncePage extends StatelessWidget {
  final int index;
  const DetailsAnnoncePage({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    Annonce annonce = controller.annonces[index];
    return MyWidget(
        title: annonce.titre,
        child: ListView(children: [
          Center(
              child: Text(annonce.detail,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.clip)),
          const Divider(),
          Visibility(
              visible: User.isAdmin,
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold))
              ])),
          Visibility(
              visible: User.isAdmin,
              child: Visibility(
                  visible: (annonce.visiblite != 1),
                  child: Visibility(
                      visible: (annonce.visiblite == 2),
                      child: ListGroupeDetailAnnonce(index: index),
                      replacement: Visibility(
                          visible: (annonce.visiblite == 3),
                          child: ListParentDetailAnnonce(index: index),
                          replacement:
                              ListEnfantDetailAnnonce(index: index))))),
          Visibility(
              visible: annonce.images.isNotEmpty,
              child: Wrap(
                  alignment: WrapAlignment.center,
                  children: annonce.images
                      .map((item) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: SizedBox(
                              height: AppSizes.heightScreen / 3,
                              child: Hero(
                                  tag: 'myHero${annonce.images.indexOf(item)}',
                                  child: GestureDetector(
                                      onTap: () async {
                                        List<Photo> gallery = [];
                                        for (var item in annonce.images) {
                                          gallery.add(Photo(
                                              chemin: item,
                                              date: '',
                                              heure: '',
                                              id: 0));
                                        }
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) => PhotoViewPage(
                                                    delete: false,
                                                    folder: "ANNONCE",
                                                    index: annonce.images
                                                        .indexOf(item),
                                                    myImages: gallery)));
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.all(2),
                                          child: CachedNetworkImage(
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              imageUrl: AppData.getImage(
                                                  item, "ANNONCE"))))))))
                      .toList()
                      .cast<Widget>()))
        ]));
  }
}
