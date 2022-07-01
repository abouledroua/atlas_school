import 'dart:math';
import 'package:atlas_school/controller/bottomlistparents_controller.dart';
import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
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
                              // Get.to(() => FicheEnfant(
                              //         idEnfant: controller.enfant.id))
                              //     ?.then((value) {
                              //   if (value == "success") {
                              //     ListEnfantsController listcontroller =
                              //         Get.find();
                              //     listcontroller.update();
                              //     Get.back();
                              //   }
                              // });
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
