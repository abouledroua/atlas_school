// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:atlas_school/controller/fichegroupe_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/fichegroupe/edittextfichegroupe.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mybuttonfiches.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheGroupe extends StatelessWidget {
  int? idGroupe;

  FicheGroupe({Key? key, this.idGroupe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    idGroupe ??= 0;
    FicheGroupeController controller =
        Get.put(FicheGroupeController(idGroupe!));
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
        backgroudImage: AppImageAsset.groupeOpac,
        title: "Fiche Enfant",
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: GetBuilder<FicheGroupeController>(
                    builder: (controller) => Visibility(
                        visible: controller.loading,
                        child: const LoadingWidget(),
                        replacement: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  const SizedBox(height: 20),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10, bottom: 20),
                                      child: EditTextFicheGroupe(
                                          hintText: "Désignation du groupe",
                                          nbline: 1,
                                          check: controller.valDes,
                                          icon: Icons
                                              .supervised_user_circle_outlined,
                                          keyboardType: TextInputType.text,
                                          mycontroller: controller.txtDes,
                                          title: "Désignation du groupe")),
                                  if (controller.valider)
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          CircularProgressIndicator(),
                                          SizedBox(width: 20),
                                          Text("validation en cours ...")
                                        ]),
                                  if (!controller.valider)
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          MyButtonFiches(
                                              onPressed: () {
                                                AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.QUESTION,
                                                        showCloseIcon: true,
                                                        btnCancelText: "Non",
                                                        btnOkText: "Oui",
                                                        btnCancelOnPress: () {},
                                                        width: min(
                                                            AppSizes.maxWidth,
                                                            AppSizes
                                                                .widthScreen),
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
                                                controller.saveGroupe();
                                              },
                                              borderColor: AppColor.white,
                                              backgroundcolor: AppColor.green,
                                              text: 'Valider',
                                              textColor: AppColor.white)
                                        ]),
                                  const SizedBox(height: 20)
                                ])))))));
  }
}
