import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedEnfantsVisibiliteWidget extends StatelessWidget {
  const SelectedEnfantsVisibiliteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
        builder: (controller) => ListView.builder(
            itemCount: controller.enfants.length,
            primary: false,
            shrinkWrap: true,
            itemBuilder: (context, i) => Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Row(children: [
                      Text((i + 1).toString() + " -  ",
                          style: Theme.of(context).textTheme.headline2),
                      SizedBox(
                          width: 40,
                          child: (controller.enfants[i].photo == "")
                              ? Image.asset(AppImageAsset.noPhoto)
                              : CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  imageUrl: AppData.getImage(
                                      controller.enfants[i].photo,
                                      "PHOTO/ENFANT"))),
                      const SizedBox(width: 5),
                      Text(controller.enfants[i].fullName,
                          style: Theme.of(context).textTheme.headline2)
                    ])))));
  }
}
