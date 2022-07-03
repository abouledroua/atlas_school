// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ajoutergroupeficheclasse_controller.dart';
import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AjoutGroupeFicheClasse extends StatelessWidget {
  const AjoutGroupeFicheClasse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AjoutGroupeFicheClasseController controller =
        Get.put(AjoutGroupeFicheClasseController());
    FicheClasseController classeController = Get.find();

    return MyWidget(
        title: "Selectionner Groupe(s)",
        child: Visibility(
            visible: classeController.allgroupes.isEmpty,
            child: Container(
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text("Aucun Groupe !!!!",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold))),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue, onPrimary: Colors.white),
                          onPressed: () {
                            classeController.getAllGroupes;
                          },
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text("Actualiser"))
                    ])),
            replacement:
                GetBuilder<FicheClasseController>(builder: (classeController) {
              return Column(children: [
                Visibility(
                    visible: classeController.groupes.isEmpty,
                    child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            width: double.infinity,
                            color: AppColor.groupe,
                            child: const Text("Pas de groupe sélectionné",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)))),
                    replacement: Wrap(
                        children: classeController.groupes
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
                                                      int i = classeController
                                                          .groupes
                                                          .indexOf(item);
                                                      print(
                                                          "suppression de la classe ${classeController.groupes[i].id},$classeController.idEnfant");

                                                      classeController.deleteClasse(
                                                          idGroupe:
                                                              classeController
                                                                  .groupes[i]
                                                                  .id,
                                                          idEnfant:
                                                              classeController
                                                                  .idEnfant,
                                                          context: context);
                                                      classeController
                                                          .removeGroupe(item);
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
                                              child: Text(item.designation,
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
                Expanded(child: GetBuilder<AjoutGroupeFicheClasseController>(
                    builder: (controller) {
                  final List<Groupe> suggestionList =
                      controller.query.isEmpty &&
                              classeController.groupes.isEmpty
                          ? classeController.allgroupes
                          : controller.filtrerCours();
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: suggestionList.length,
                      itemBuilder: (context, i) => Visibility(
                          visible:
                              !controller.existGroupe(suggestionList[i].id),
                          child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                      onTap: () {
                                        print(suggestionList[i].designation);
                                        if (!controller.existGroupe(
                                            suggestionList[i].id)) {
                                          classeController.insertClasse(
                                              idGroupe: suggestionList[i].id,
                                              idEnfant:
                                                  classeController.idEnfant,
                                              context: context);
                                          classeController
                                              .addGroupe(suggestionList[i]);
                                        }
                                      },
                                      title: Text(suggestionList[i].designation,
                                          style: TextStyle(
                                              color: controller.existGroupe(
                                                      suggestionList[i].id)
                                                  ? Colors.grey
                                                  : Colors.black)))))));
                }))
              ]);
            })));
  }
}
