import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEnfantDetailAnnonce extends StatelessWidget {
  final int index;
  const ListEnfantDetailAnnonce({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    List<Enfant> enfants = controller.annonces[index].enfants;
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
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                      width: 40,
                      child: (enfants[i].photo == "")
                          ? Image.asset(AppImageAsset.noPhoto)
                          : CachedNetworkImage(
                              //  fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              imageUrl: AppData.getImage(
                                  enfants[i].photo, "PHOTO/ENFANT"))),
                  const SizedBox(width: 5),
                  Text(enfants[i].fullName,
                      style: Theme.of(context).textTheme.bodyText1)
                ]))));
  }
}
