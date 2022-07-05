// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnfantContentFicheClasse extends StatelessWidget {
  const EnfantContentFicheClasse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheClasseController>(
        builder: (controller) => ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: controller.groupes.length,
            itemBuilder: (context, i) {
              return Card(
                  elevation: 4,
                  child: ListTile(
                      title: Text(controller.groupes[i].designation,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip),
                      trailing: GestureDetector(
                          onTap: () {
                            AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.ERROR,
                                    showCloseIcon: true,
                                    title: 'Erreur',
                                    btnOkText: "Oui",
                                    btnCancelText: "Non",
                                    width: min(AppSizes.maxWidth,
                                        AppSizes.widthScreen),
                                    btnOkOnPress: () {
                                      print(
                                          "suppression de la classe ${controller.groupes[i].id},$controller.idEnfant");
                                      controller
                                          .deleteClasse(
                                              context: context,
                                              idEnfant: controller.idEnfant,
                                              idGroupe:
                                                  controller.groupes[i].id)
                                          .then((value) {
                                        controller.removeGroupe(
                                            controller.groupes[i]);
                                      });
                                    },
                                    btnCancelOnPress: () {},
                                    desc:
                                        'Voulez vraiment supprimer cette classe ?')
                                .show();
                          },
                          child: const Icon(Icons.delete, color: Colors.red))));
            }));
  }
}
