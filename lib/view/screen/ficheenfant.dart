// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:atlas_school/controller/ficheenfant_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/ficheeleve/circularphotoeleve.dart';
import 'package:atlas_school/view/widget/ficheeleve/edittextficheeleve.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mybuttonfiches.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/image_asset.dart';

class FicheEnfant extends StatelessWidget {
  int? idEnfant;
  FicheEnfant({Key? key, this.idEnfant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    idEnfant ??= 0;
    FicheEnfantController controller =
        Get.put(FicheEnfantController(idEnfant!));
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
        backgroudImage: AppImageAsset.kidOpac,
        title: "Fiche Enfant",
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: GetBuilder<FicheEnfantController>(
                    builder: (controller) => Visibility(
                        visible: controller.loading,
                        child: const LoadingWidget(),
                        replacement: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView(
                                primary: false,
                                shrinkWrap: true,
                                children: [
                                  const CircularPhotoFicheEleve(),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10, bottom: 20),
                                      child: EditTextFicheEleve(
                                          hintText: "Nom de l'élève",
                                          nbline: 1,
                                          check: controller.valNom,
                                          icon: Icons
                                              .supervised_user_circle_outlined,
                                          keyboardType: TextInputType.text,
                                          mycontroller: controller.txtNom,
                                          title: "Nom de l'élève")),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, left: 10, bottom: 20),
                                      child: EditTextFicheEleve(
                                          hintText: "Prénom de l'élève",
                                          icon: Icons
                                              .supervised_user_circle_outlined,
                                          check: controller.valPrenom,
                                          nbline: 1,
                                          keyboardType: TextInputType.text,
                                          mycontroller: controller.txtPrenom,
                                          title: "Prénom de l'élève")),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 5),
                                      child: EditTextFicheEleve(
                                          hintText: "Date de Naissance",
                                          check: controller.valDateNaiss,
                                          icon: Icons.date_range_rounded,
                                          onPressedIcon: () {
                                            controller.datePicker(
                                                context: context);
                                          },
                                          nbline: 1,
                                          mycontroller: controller.txtDateNaiss,
                                          keyboardType: TextInputType.datetime,
                                          title: "Date de Naissance")),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text("Sexe",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                            const SizedBox(width: 25),
                                            Radio(
                                                groupValue: controller.sexe,
                                                value: 1,
                                                onChanged: (value) {
                                                  if (!controller.valider) {
                                                    controller.updateSexe(
                                                        value as int?);
                                                  }
                                                }),
                                            InkWell(
                                                child: const Text("Homme"),
                                                onTap: () {
                                                  if (!controller.valider) {
                                                    controller.updateSexe(1);
                                                  }
                                                }),
                                            Radio(
                                                groupValue: controller.sexe,
                                                value: 2,
                                                onChanged: (value) {
                                                  if (!controller.valider) {
                                                    controller.updateSexe(
                                                        value as int?);
                                                  }
                                                }),
                                            InkWell(
                                                child: const Text("Femme"),
                                                onTap: () {
                                                  if (!controller.valider) {
                                                    controller.updateSexe(2);
                                                  }
                                                })
                                          ])),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: EditTextFicheEleve(
                                          hintText: "Adresse de l'élève",
                                          keyboardType: TextInputType.multiline,
                                          icon: Icons
                                              .supervised_user_circle_outlined,
                                          nbline: null,
                                          mycontroller: controller.txtAdresse,
                                          title: "Adresse de l'élève")),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Switch(
                                            value: controller.isSwitched,
                                            onChanged: (value) {
                                              if (!controller.valider) {
                                                controller.updateSwitch();
                                              }
                                            }),
                                        const SizedBox(width: 5),
                                        Text(
                                            controller.isSwitched
                                                ? "Actif"
                                                : "Inactif",
                                            style: const TextStyle(
                                                color: Colors.black))
                                      ]),
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
                                                controller.saveEnfant();
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
