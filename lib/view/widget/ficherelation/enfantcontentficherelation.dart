// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnfantContentFicheRelation extends StatelessWidget {
  const EnfantContentFicheRelation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheRelationController>(
        builder: (controller) => ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: controller.parents.length,
            itemBuilder: (context, i) {
              return Card(
                  elevation: 4,
                  child: ListTile(
                      title: Text(controller.parents[i].fullName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip),
                      subtitle: Text(controller.parents[i].adresse,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey.shade800),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        Column(children: [
                          (controller.parents[i].tel1 != "")
                              ? GestureDetector(
                                  onTap: () {
                                    AppData.makeExternalRequest(
                                        'tel:${controller.parents[i].tel1}');
                                  },
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(controller.parents[i].tel1,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 11)),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.call,
                                            color: Colors.green)
                                      ]))
                              : const SizedBox(width: 0, height: 0),
                          (controller.parents[i].tel2 != "")
                              ? GestureDetector(
                                  onTap: () {
                                    AppData.makeExternalRequest(
                                        'tel:${controller.parents[i].tel2}');
                                  },
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(controller.parents[i].tel2,
                                            textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 11)),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.call,
                                            color: Colors.green)
                                      ]))
                              : const SizedBox(width: 0, height: 0)
                        ]),
                        const SizedBox(width: 5),
                        GestureDetector(
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      showCloseIcon: true,
                                      title: 'Erreur',
                                      btnOkText: "Oui",
                                      btnCancelText: "Non",
                                      btnOkOnPress: () {
                                        print(
                                            "suppression de la relation ${controller.parents[i].id},$controller.idEnfant");
                                        controller
                                            .deleteRelation(
                                                context: context,
                                                idEnfant: controller.idEnfant,
                                                idParent:
                                                    controller.parents[i].id)
                                            .then((value) {
                                          controller.removeParent(
                                              controller.parents[i]);
                                        });
                                      },
                                      btnCancelOnPress: () {},
                                      desc:
                                          'Voulez vraiment supprimer cette relation ?')
                                  .show();
                            },
                            child: const Icon(Icons.delete, color: Colors.red))
                      ])));
            }));
  }
}
