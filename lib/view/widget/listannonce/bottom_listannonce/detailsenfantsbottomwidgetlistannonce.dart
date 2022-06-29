import 'package:atlas_school/core/constant/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:get/get.dart';

class DetailsEnfantsBottomWidgetListAnnonce extends StatelessWidget {
  final int ind;
  const DetailsEnfantsBottomWidgetListAnnonce({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    return ListView.builder(
        itemCount: controller.annonces[ind].enfants.length,
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
                      child: (controller.annonces[ind].enfants[i].photo == "")
                          ? Image.asset("images/noPhoto.png")
                          : CachedNetworkImage(
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: AppData.getImage(
                                  controller.annonces[ind].enfants[i].photo,
                                  "PHOTO/ENFANT"))),
                  const SizedBox(width: 5),
                  Text(controller.annonces[ind].enfants[i].fullName,
                      style: Theme.of(context).textTheme.bodyText1)
                ]))));
  }
}
