// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ajouterenfantficherelation_controller.dart';
import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutEnfantFicheRelation extends StatelessWidget {
  const AjoutEnfantFicheRelation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AjoutEnfantFicheRelationController controller =
        Get.put(AjoutEnfantFicheRelationController());
    FicheRelationController relationController = Get.find();

    return MyWidget(
        title: "Selectionner Enfant(s)",
        child: Visibility(
            visible: relationController.allenfants.isEmpty,
            child: Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text("Aucun Enfant !!!!",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, onPrimary: Colors.white),
                          onPressed: () {
                            relationController.getAllEnfants();
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text("Actualiser"))
                    ])),
            replacement: GetBuilder<FicheRelationController>(
                builder: (relationController) {
              return Column(children: [
                Visibility(
                    visible: relationController.enfants.isEmpty,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            color: AppColor.enfant,
                            child: const Text("Pas d'enfant sélectionné",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black)))),
                    replacement: Wrap(
                        children: relationController.enfants
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
                                                          .enfants
                                                          .indexOf(item);
                                                      print(
                                                          "suppression de la relation ${relationController.enfants[i].id},$relationController.idEnfant");

                                                      relationController.deleteRelation(
                                                          idParent:
                                                              relationController
                                                                  .idParent,
                                                          idEnfant:
                                                              relationController
                                                                  .enfants[i]
                                                                  .id,
                                                          context: context);

                                                      relationController
                                                          .removeEnfant(item);
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
                Expanded(child: GetBuilder<AjoutEnfantFicheRelationController>(
                    builder: (controller) {
                  final List<Enfant> suggestionList =
                      controller.query.isEmpty &&
                              relationController.enfants.isEmpty
                          ? relationController.allenfants
                          : controller.filtrerCours();
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: suggestionList.length,
                      itemBuilder: (context, i) => Visibility(
                          visible:
                              !controller.existEnfant(suggestionList[i].id),
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                      onTap: () {
                                        print(suggestionList[i].fullName);
                                        if (!controller.existEnfant(
                                            suggestionList[i].id)) {
                                          relationController.insertRelation(
                                              idParent:
                                                  relationController.idParent,
                                              idEnfant: suggestionList[i].id,
                                              context: context);
                                          relationController
                                              .addEnfant(suggestionList[i]);
                                        }
                                      },
                                      title: Text(suggestionList[i].fullName,
                                          style: TextStyle(
                                              color: controller.existEnfant(
                                                      suggestionList[i].id)
                                                  ? Colors.grey
                                                  : Colors.black)))))));
                }))
              ]);
            })));
  }
}
