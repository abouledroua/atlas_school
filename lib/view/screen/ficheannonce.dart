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
import 'package:atlas_school/view/widget/mybuttonfiches.dart';
import 'package:atlas_school/view/widget/ficheannonce/validationwidgetficheannonce.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
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
        leading: IconButton(
            onPressed: () {
              controller.onWillPop().then((value) {
                if (value) {
                  Get.back();
                }
              });
            },
            icon: const Icon(Icons.arrow_back)),
        backgroudImage: AppImageAsset.annonceOpac,
        title: "Fiche Annonce",
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: GetBuilder<FicheAnnonceController>(
                    builder: (controller) => Visibility(
                        visible: controller.loading,
                        child: const LoadingWidget(),
                        replacement: ListView(children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: padLeft, vertical: padBottom),
                              child: EditTextFicheAnnonce(
                                  hintText: "Titre de l'annonce",
                                  icon: Icons.title_rounded,
                                  check: controller.valTitre,
                                  nbline: 1,
                                  mycontroller: controller.titreController,
                                  title: "Titre")),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: padLeft,
                                  right: padLeft,
                                  bottom: padBottom / 2),
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
                          if (controller.valider)
                            const ValidationEnCoursFicheAnnonce(),
                          if (!controller.valider)
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyButtonFiches(
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
                                  MyButtonFiches(
                                      onPressed: () {
                                        controller.saveAnnonce();
                                      },
                                      borderColor: AppColor.white,
                                      backgroundcolor: AppColor.green,
                                      text: 'Valider',
                                      textColor: AppColor.white)
                                ]),
                          const SizedBox(height: 20)
                        ]))))));
  }
}
