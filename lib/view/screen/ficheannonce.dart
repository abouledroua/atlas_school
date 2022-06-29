// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/ficheannonce/edittextficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/entetevisibiliteficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/espaceimageficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/espacevisibiliteficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/enteteimageficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/mybuttonficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/validationwidgetficheannonce.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheAnnonce extends StatelessWidget {
  int? idAnnonce;
  FicheAnnonce({Key? key, this.idAnnonce}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    idAnnonce ??= 0;
    FicheAnnonceController controller =
        Get.put(FicheAnnonceController(idAnnonce!));
    double padLeft = 10, padBottom = 30;
    return MyWidget(
        backgroudImage: AppImageAsset.annonceOpac,
        title: "Fiche Annonce",
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padLeft, vertical: padBottom),
                  child: EditTextFicheAnnonce(
                      hintText: "Titre de l'annonce",
                      icon: Icons.title_rounded,
                      mycontroller: controller.titreController,
                      title: "Titre")),
              Padding(
                  padding: EdgeInsets.only(
                      left: padLeft, right: padLeft, bottom: padBottom / 2),
                  child: EditTextFicheAnnonce(
                      hintText: "Détails sur l'annonce",
                      icon: Icons.description_outlined,
                      mycontroller: controller.detailsController,
                      title: "Détails")),
              const Divider(),
              const EnteteImageFicheAnnonce(),
              const EspaceImageFicheAnnonce(),
              const Divider(),
              const EnteteVisibiliteFicheAnnonce(),
              EspaceVisibiliteFicheAnnonce(padBottom: padBottom),
              const Divider(),
              if (controller.valider) const ValidationEnCoursFicheAnnonce(),
              if (!controller.valider)
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButtonsFicheAnnonce(
                          onPressed: () {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.QUESTION,
                                    showCloseIcon: true,
                                    btnCancelText: "Non",
                                    btnOkText: "Oui",
                                    btnCancelOnPress: () {},
                                    width: min(AppSizes.maxWidth,
                                        AppSizes.widthScreen),
                                    btnOkOnPress: () {
                                      Get.back();
                                    },
                                    desc:
                                        'Voulez-vous vraiment annuler tous les changements !!!')
                                .show();
                          },
                          borderColor: AppColor.red,
                          backgroundcolor: AppColor.white,
                          text: 'Annuler',
                          textColor: AppColor.red),
                      MyButtonsFicheAnnonce(
                          onPressed: () {
                            controller.saveAnnonce();
                          },
                          borderColor: AppColor.white,
                          backgroundcolor: AppColor.green,
                          text: 'Valider',
                          textColor: AppColor.white)
                    ])
            ])));
  }
}