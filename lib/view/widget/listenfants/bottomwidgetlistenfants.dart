import 'dart:math';
import 'package:atlas_school/controller/bottomlistenfants_controller.dart';
import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/ficheenfant.dart';
import 'package:atlas_school/view/widget/listenfants/circularphotoenfant.dart';
import 'package:atlas_school/view/widget/listenfants/emptylistenfantparent.dart';
import 'package:atlas_school/view/widget/listenfants/listenfantparentwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'listenfantgroupeswidget.dart';

class BottomSheetWidgetListEnfant extends StatelessWidget {
  final int ind;
  const BottomSheetWidgetListEnfant({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BottomListEnfantsController(indice: ind));
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child: GetBuilder<BottomListEnfantsController>(builder: (controller) {
          Enfant enfants = controller.enfant;
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        ListView(primary: false, shrinkWrap: true, children: [
                      Text(enfants.fullName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.clip),
                      const CircularPhotoWidget(),
                      Row(children: [
                        const Icon(Icons.date_range_rounded),
                        const SizedBox(width: 20),
                        Text(enfants.dateNaiss + " ("),
                        Text(
                            AppData.calculateAge(
                                DateTime.parse(enfants.dateNaiss)),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Text(" )")
                      ]),
                      if (enfants.adresse != "")
                        Row(children: [
                          const Icon(Icons.gps_fixed),
                          const SizedBox(width: 20),
                          Text(enfants.adresse)
                        ]),
                      if (controller.loadingPar) const LoadingWidget(),
                      if (!controller.loadingPar)
                        Visibility(
                            visible: controller.parents.isEmpty,
                            child: const EmptyListParentGroupeEnfant(
                                type: 'parent'),
                            replacement: const ListEnfantParentWidget()),
                      const Divider(),
                      if (controller.loadingGr) const LoadingWidget(),
                      if (!controller.loadingGr)
                        Visibility(
                            visible: controller.groupes.isEmpty,
                            child: const EmptyListParentGroupeEnfant(
                                type: 'groupe'),
                            replacement: const ListEnfantGroupesWidget()),
                      const Divider(),
                      Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green, onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheEnfant(
                                      idEnfant: controller.enfant.id))
                                  ?.then((value) {
                                if (value == "success") {
                                  ListEnfantsController listcontroller =
                                      Get.find();
                                  listcontroller.update();
                                  Get.back();
                                }
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Infos")),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.amber, onPrimary: Colors.white),
                            onPressed: () {
                              // var route = MaterialPageRoute(
                              //     builder: (context) => FicheRelation(
                              //         idEnfant: enfants.id, idParent: 0));
                              // Navigator.of(context).push(route).then((value) {
                              //   Navigator.of(context).pop();
                              // });
                            },
                            icon: const Icon(Icons.group_outlined),
                            label: const Text("Parents")),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.cyan, onPrimary: Colors.white),
                            onPressed: () {
                              // var route = MaterialPageRoute(
                              //     builder: (context) => FicheClasse(
                              //         idEnfant: enfants.id, idGroupe: 0));
                              // Navigator.of(context).push(route).then((value) {
                              //   Navigator.of(context).pop();
                              // });
                            },
                            icon: const Icon(Icons.groups_outlined),
                            label: const Text("Groupes")),
                        if (controller.parents.isEmpty)
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
                                          ListEnfantsController listcontroller =
                                              Get.find();
                                          listcontroller.deleteEnfant(ind);
                                        },
                                        btnCancelOnPress: () {
                                          Navigator.of(context).pop();
                                        },
                                        desc:
                                            'Voulez vraiment supprimer cet enfant ?')
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
