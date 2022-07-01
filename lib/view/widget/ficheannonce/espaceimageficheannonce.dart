import 'dart:io';
import 'dart:math';
import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspaceImageFicheAnnonce extends StatelessWidget {
  const EspaceImageFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
        builder: (controller) => SizedBox(
            height: AppSizes.heightScreen / 6,
            child: Visibility(
                visible: controller.myImages.isEmpty,
                child: const Center(
                    child: Text("Pas d'images",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold))),
                replacement: ListView.builder(
                    itemCount: controller.myImages.length,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Stack(children: [
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: i < controller.nbAnnImg
                                ? CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    imageUrl: AppData.getImage(
                                        controller.myImages[i].chemin,
                                        "ANNONCE"))
                                : Image.file(
                                    File(controller.myImages[i].chemin),
                                    fit: BoxFit.contain)),
                        Positioned(
                            top: -16,
                            right: -16,
                            child: IconButton(
                                onPressed: controller.valider
                                    ? null
                                    : () {
                                        AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.QUESTION,
                                                showCloseIcon: true,
                                                btnCancelText: "Non",
                                                btnOkText: "Oui",
                                                width: min(AppSizes.maxWidth,
                                                    AppSizes.widthScreen),
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  if (i < controller.nbAnnImg) {
                                                    controller.deletedImages
                                                        .add(controller
                                                            .myImages[i].num);
                                                    controller.nbAnnImg--;
                                                  }
                                                  controller.removeImage(i);
                                                },
                                                desc:
                                                    'Voulez-vous vraiment supprimer cette image ?')
                                            .show();
                                      },
                                icon: const Icon(Icons.delete,
                                    color: Colors.red)))
                      ]);
                    }))));
  }
}
