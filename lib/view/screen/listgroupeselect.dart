// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/controller/listgroupeselect_controller.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGroupeSelect extends StatelessWidget {
  const ListGroupeSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListGroupeSelectController controller =
        Get.put(ListGroupeSelectController());
    List suggestionList = controller.query.isEmpty
        ? controller.allgroupes
        : controller.filtrerCours();
    return MyWidget(
        title: "Selectionner Groupe(s)",
        child: GetBuilder<ListGroupeSelectController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const Center(child: CircularProgressIndicator()),
                replacement: Visibility(
                    visible: controller.allgroupes.isEmpty,
                    child: Container(
                        color: Colors.white,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                      controller.error
                                          ? "Erreur de connexion !!!"
                                          : "Aucun Groupe !!!!",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: controller.error
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold))),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white),
                                  onPressed: () {
                                    controller.getAllGroupes();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Actualiser"))
                            ])),
                    replacement: Column(children: [
                      GetBuilder<FicheAnnonceController>(
                          builder: (fcontroller) => Visibility(
                              visible: fcontroller.groupes.isEmpty,
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      color: Colors.amber,
                                      child: const Text(
                                          "Pas de groupe sélectionné",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)))),
                              replacement: Wrap(
                                  children: fcontroller.groupes
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      fcontroller
                                                          .removeGroupe(item);
                                                    },
                                                    child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red)),
                                                Ink(
                                                    color: Colors.blue,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            item.designation,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .white))))
                                              ])))
                                      .toList()
                                      .cast<Widget>()))),
                      const Divider(),
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
                                    controller.updateQuery('');
                                  },
                                  child:
                                      Ink(child: const Icon(Icons.search))))),
                      GetBuilder<FicheAnnonceController>(
                          builder: (fcontroller) => Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: suggestionList.length,
                                  itemBuilder: (context, i) => Visibility(
                                      visible: !controller
                                          .existGroup(suggestionList[i].id),
                                      child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                  onTap: () {
                                                    print(suggestionList[i]
                                                        .designation);
                                                    if (!controller.existGroup(
                                                        suggestionList[i].id)) {
                                                      fcontroller.addGroupe(
                                                          suggestionList[i]);
                                                    }
                                                  },
                                                  title: Text(
                                                      suggestionList[i]
                                                          .designation,
                                                      style: TextStyle(
                                                          color: controller
                                                                  .existGroup(
                                                                      suggestionList[
                                                                              i]
                                                                          .id)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .black)))))))))
                    ])))));
  }
}
