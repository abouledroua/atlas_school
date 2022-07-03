// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ajouterparentficherelation_controller.dart';
import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutParentFicheRelation extends StatelessWidget {
  const AjoutParentFicheRelation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AjoutParentFicheRelationController controller =
        Get.put(AjoutParentFicheRelationController());
    FicheRelationController relationController = Get.find();

    return MyWidget(
        title: "Selectionner Parent(s)",
        child: Visibility(
            visible: relationController.allparents.isEmpty,
            child: Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text("Aucun Parent !!!!",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, onPrimary: Colors.white),
                          onPressed: () {
                            relationController.getAllParents;
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text("Actualiser"))
                    ])),
            replacement: GetBuilder<FicheRelationController>(
                builder: (relationController) {
              return Column(children: [
                Visibility(
                    visible: relationController.parents.isEmpty,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            color: AppColor.parent,
                            child: const Text("Pas de parent sélectionné",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)))),
                    replacement: Wrap(
                        children: relationController.parents
                            .map((item) => Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            AwesomeDialog(
                                                    context: context,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    showCloseIcon: true,
                                                    title: 'Erreur',
                                                    btnOkText: "Oui",
                                                    btnCancelText: "Non",
                                                    btnOkOnPress: () {
                                                      int i = relationController
                                                          .parents
                                                          .indexOf(item);
                                                      print(
                                                          "suppression de la relation ${relationController.parents[i].id},$relationController.idEnfant");

                                                      relationController.deleteRelation(
                                                          idParent:
                                                              relationController
                                                                  .parents[i]
                                                                  .id,
                                                          idEnfant:
                                                              relationController
                                                                  .idEnfant,
                                                          context: context);
                                                      relationController
                                                          .removeParent(item);
                                                    },
                                                    btnCancelOnPress: () {},
                                                    desc:
                                                        'Voulez vraiment supprimer cette relation ?')
                                                .show();
                                          },
                                          child: Ink(
                                              child: const Icon(Icons.delete,
                                                  color: Colors.red))),
                                      Container(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(item.fullName,
                                                  style: const TextStyle(
                                                      color: Colors.white))),
                                          color: Colors.blue)
                                    ])))
                            .toList()
                            .cast<Widget>())),
                TextFormField(
                    initialValue: controller.query,
                    onChanged: (value) {
                      controller.updateQuery(value);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Recherche",
                        suffixIcon: const Icon(Icons.clear),
                        prefixIcon: InkWell(
                            onTap: () {
                              controller.updateQuery("");
                            },
                            child: Ink(child: const Icon(Icons.search))))),
                const Divider(),
                Expanded(child: GetBuilder<AjoutParentFicheRelationController>(
                    builder: (controller) {
                  final List<Parent> suggestionList =
                      controller.query.isEmpty &&
                              relationController.parents.isEmpty
                          ? relationController.allparents
                          : controller.filtrerCours();
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: suggestionList.length,
                      itemBuilder: (context, i) => Visibility(
                          visible:
                              !controller.existParent(suggestionList[i].id),
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                      onTap: () {
                                        print(suggestionList[i].fullName);
                                        if (!controller.existParent(
                                            suggestionList[i].id)) {
                                          relationController.insertRelation(
                                              idParent: suggestionList[i].id,
                                              idEnfant:
                                                  relationController.idEnfant,
                                              context: context);
                                          relationController
                                              .addParent(suggestionList[i]);
                                        }
                                      },
                                      title: Text(suggestionList[i].fullName,
                                          style: TextStyle(
                                              color: controller.existParent(
                                                      suggestionList[i].id)
                                                  ? Colors.grey
                                                  : Colors.black)))))));
                }))
              ]);
            })));
  }
}
