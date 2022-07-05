// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/controller/ajouterenfantficheclasse_controller.dart';
import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutEnfantFicheClasse extends StatelessWidget {
  const AjoutEnfantFicheClasse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AjoutEnfantFicheClasseController controller =
        Get.put(AjoutEnfantFicheClasseController());
    FicheClasseController classeController = Get.find();

    return MyWidget(
        title: "Selectionner Enfant(s)",
        child: Visibility(
            visible: classeController.allenfants.isEmpty,
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
                            classeController.getAllEnfants();
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text("Actualiser"))
                    ])),
            replacement:
                GetBuilder<FicheClasseController>(builder: (classeController) {
              return Column(children: [
                Visibility(
                    visible: classeController.enfants.isEmpty,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            color: AppColor.enfant,
                            child: const Text("Pas d'enfant sélectionné",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black)))),
                    replacement: Wrap(
                        children: classeController.enfants
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
                                                    width: min(
                                                        AppSizes.maxWidth,
                                                        AppSizes.widthScreen),
                                                    btnOkOnPress: () {
                                                      int i = classeController
                                                          .enfants
                                                          .indexOf(item);
                                                      print(
                                                          "suppression de la classe ${classeController.enfants[i].id},$classeController.idEnfant");
                                                      classeController.deleteClasse(
                                                          idGroupe:
                                                              classeController
                                                                  .idGroupe,
                                                          idEnfant:
                                                              classeController
                                                                  .enfants[i]
                                                                  .id,
                                                          context: context);
                                                      classeController
                                                          .removeEnfant(item);
                                                    },
                                                    btnCancelOnPress: () {},
                                                    desc:
                                                        'Voulez vraiment supprimer cette classe ?')
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
                Expanded(child: GetBuilder<AjoutEnfantFicheClasseController>(
                    builder: (controller) {
                  final List<Enfant> suggestionList =
                      controller.query.isEmpty &&
                              classeController.enfants.isEmpty
                          ? classeController.allenfants
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
                                          classeController.insertClasse(
                                              idGroupe:
                                                  classeController.idGroupe,
                                              idEnfant: suggestionList[i].id,
                                              context: context);
                                          classeController
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
