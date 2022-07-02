import 'dart:math';
import 'package:atlas_school/controller/bottomlistenseignants_controller.dart';
import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/core/class/enseignant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/ficheenseignant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetWidgetListEnseignants extends StatelessWidget {
  final int ind;
  const BottomSheetWidgetListEnseignants({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BottomListEnseignantsController(indice: ind));
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child:
            GetBuilder<BottomListEnseignantsController>(builder: (controller) {
          Enseignant enseignant = controller.enseignant;
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        ListView(primary: false, shrinkWrap: true, children: [
                      Text(enseignant.fullName.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline1,
                          overflow: TextOverflow.clip),
                      if (enseignant.dateNaiss.isNotEmpty)
                        Row(children: [
                          const Icon(Icons.date_range_rounded),
                          const SizedBox(width: 20),
                          Text(enseignant.dateNaiss + " ("),
                          Text(
                              enseignant.dateNaiss.isEmpty
                                  ? ""
                                  : AppData.calculateAge(
                                      DateTime.parse(enseignant.dateNaiss)),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const Text(" )")
                        ]),
                      if (enseignant.adresse != "")
                        Row(children: [
                          const Icon(Icons.gps_fixed),
                          const SizedBox(width: 20),
                          Text(enseignant.adresse)
                        ]),
                      if (enseignant.tel1 != "")
                        Row(children: [
                          const Icon(Icons.phone),
                          const SizedBox(width: 20),
                          Text(enseignant.tel1)
                        ]),
                      if (enseignant.matiere != "")
                        Row(children: [
                          const Icon(Icons.book),
                          const SizedBox(width: 20),
                          Text(enseignant.matiere)
                        ]),
                      const Divider(),
                      if (enseignant.userName != "")
                        Row(children: [
                          const Icon(Icons.verified_user),
                          const SizedBox(width: 20),
                          Text(enseignant.userName)
                        ]),
                      if (enseignant.password != "")
                        Row(children: [
                          const Icon(Icons.password),
                          const SizedBox(width: 20),
                          Text(enseignant.password)
                        ]),
                      Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                        ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green, onPrimary: Colors.white),
                            onPressed: () {
                              Get.to(() => FicheEnseignant(
                                      idEnseignant: controller.enseignant.id))
                                  ?.then((value) {
                                if (value == "success") {
                                  ListEnseignantsController listcontroller =
                                      Get.find();
                                  listcontroller.getEnseignants();
                                  Get.back();
                                }
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Modifier")),
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
                                        ListEnseignantsController
                                            listcontroller = Get.find();
                                        listcontroller.deleteEnseignant(ind);
                                      },
                                      btnCancelOnPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      desc:
                                          'Voulez vraiment supprimer cet enseignant ?')
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
