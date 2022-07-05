import 'dart:math';
import 'package:atlas_school/controller/bottomlistgroupes_controller.dart';
import 'package:atlas_school/controller/listgroupes_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/ficheclasse.dart';
import 'package:atlas_school/view/screen/fichegroupe.dart';
import 'package:atlas_school/view/widget/listenfants/emptylistenfantparent.dart';
import 'package:atlas_school/view/widget/listgroupes/listgroupeenfantwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetWidgetListGroupes extends StatelessWidget {
  final int ind;
  const BottomSheetWidgetListGroupes({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BottomListGroupesController(indice: ind));
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child: GetBuilder<BottomListGroupesController>(builder: (controller) {
          Groupe groupe = controller.groupe;
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        ListView(primary: false, shrinkWrap: true, children: [
                      Text(groupe.designation.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.clip),
                      if (controller.loadingEnf) const LoadingWidget(),
                      if (!controller.loadingEnf)
                        Visibility(
                            visible: controller.enfants.isEmpty,
                            child: const EmptyListParentGroupeEnfant(
                                type: 'enfant'),
                            replacement: const LisGroupeEnfantWidget()),
                      const Divider(),
                      Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green, onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheGroupe(
                                      idGroupe: controller.groupe.id))
                                  ?.then((value) {
                                if (value == "success") {
                                  ListGroupesController listcontroller =
                                      Get.find();
                                  listcontroller.getGroupes();
                                  Get.back();
                                }
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Infos")),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.enfant,
                                onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheClasse(
                                      idGroupe: controller.groupe.id))
                                  ?.then((value) {
                                Get.back();
                              });
                            },
                            icon: const Icon(Icons.person_outline_sharp),
                            label: const Text("Enfants")),
                        if (controller.enfants.isEmpty)
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.red, onPrimary: Colors.white),
                              onPressed: () {
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.QUESTION,
                                        showCloseIcon: true,
                                        title: 'Confirmation',
                                        btnOkText: "Oui",
                                        btnCancelText: "Non",
                                        width: min(AppSizes.maxWidth,
                                            AppSizes.widthScreen),
                                        btnOkOnPress: () {
                                          ListGroupesController listcontroller =
                                              Get.find();
                                          listcontroller.deleteGroupe(ind);
                                        },
                                        btnCancelOnPress: () {
                                          Get.back();
                                        },
                                        desc:
                                            'Voulez vraiment supprimer ce parent ?')
                                    .show();
                              },
                              icon: const Icon(Icons.delete),
                              label: const Text("Supprimer"))
                      ])
                    ]))
              ]);
        }));
  }
}
