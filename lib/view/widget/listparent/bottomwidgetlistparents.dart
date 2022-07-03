import 'dart:math';
import 'package:atlas_school/controller/bottomlistparents_controller.dart';
import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/ficheparent.dart';
import 'package:atlas_school/view/screen/ficherelation.dart';
import 'package:atlas_school/view/widget/listenfants/emptylistenfantparent.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'listparentenfantwidget.dart';

class BottomSheetWidgetListParents extends StatelessWidget {
  final int ind;
  const BottomSheetWidgetListParents({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BottomListParentsController(indice: ind));
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child: GetBuilder<BottomListParentsController>(builder: (controller) {
          Parent parent = controller.parent;
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        ListView(primary: false, shrinkWrap: true, children: [
                      Text(parent.fullName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.clip),
                      if (parent.dateNaiss.isNotEmpty)
                        Row(children: [
                          const Icon(Icons.date_range_rounded),
                          const SizedBox(width: 20),
                          Text(parent.dateNaiss + " ("),
                          Text(
                              parent.dateNaiss.isEmpty
                                  ? ""
                                  : AppData.calculateAge(
                                      DateTime.parse(parent.dateNaiss)),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Text(" )")
                        ]),
                      if (parent.adresse != "")
                        Row(children: [
                          const Icon(Icons.gps_fixed),
                          const SizedBox(width: 20),
                          Text(parent.adresse)
                        ]),
                      if (parent.tel1 != "")
                        Row(children: [
                          const Icon(Icons.phone),
                          const SizedBox(width: 20),
                          Text(parent.tel1)
                        ]),
                      if (parent.tel2 != "")
                        Row(children: [
                          const Icon(Icons.phone),
                          const SizedBox(width: 20),
                          Text(parent.tel2)
                        ]),
                      const Divider(),
                      if (parent.userName != "")
                        Row(children: [
                          const Icon(Icons.verified_user),
                          const SizedBox(width: 20),
                          Text(parent.userName)
                        ]),
                      if (parent.password != "")
                        Row(children: [
                          const Icon(Icons.password),
                          const SizedBox(width: 20),
                          Text(parent.password)
                        ]),
                      if (controller.loadingEnf) const LoadingWidget(),
                      if (!controller.loadingEnf)
                        Visibility(
                            visible: controller.enfants.isEmpty,
                            child: const EmptyListParentGroupeEnfant(
                                type: 'enfant'),
                            replacement: const ListParentEnfantWidget()),
                      const Divider(),
                      Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green, onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheParent(
                                      idParent: controller.parent.id))
                                  ?.then((value) {
                                if (value == "success") {
                                  ListParentsController listcontroller =
                                      Get.find();
                                  listcontroller.getParents();
                                  Get.back();
                                }
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Modifier")),
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: AppColor.enfant,
                                onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheRelation(
                                      idParent: controller.parent.id))
                                  ?.then((value) {
                                Get.back();
                              });
                            },
                            icon: const Icon(Icons.group_outlined),
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
                                          ListParentsController listcontroller =
                                              Get.find();
                                          listcontroller.deleteParent(ind);
                                        },
                                        btnCancelOnPress: () {
                                          Navigator.of(context).pop();
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
