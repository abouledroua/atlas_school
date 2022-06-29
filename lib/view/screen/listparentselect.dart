// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/controller/listparentselect_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParentSelect extends StatelessWidget {
  const ListParentSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListParentSelectController controller =
        Get.put(ListParentSelectController());
    List<Parent> suggestionList = controller.query.isEmpty
        ? controller.allparents
        : controller.filtrerCours();
    return MyWidget(
        title: "Selectionner Parent(s)",
        child: GetBuilder<ListParentSelectController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const Center(child: CircularProgressIndicator()),
                replacement: Visibility(
                    visible: controller.allparents.isEmpty,
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
                                          : "Aucun Parent !!!!",
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
                                    controller.getAllParents();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Actualiser"))
                            ])),
                    replacement: Column(children: [
                      GetBuilder<FicheAnnonceController>(
                          builder: (fcontroller) => Visibility(
                              visible: fcontroller.parents.isEmpty,
                              child: Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: double.infinity,
                                      color: Colors.amber,
                                      child: const Text(
                                          "Pas de parent sélectionné",
                                          textAlign: TextAlign.center,
                                          style:
                                              TextStyle(color: Colors.white)))),
                              replacement: Wrap(
                                  children: fcontroller.parents
                                      .map((item) => Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      fcontroller
                                                          .removeParent(item);
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
                                                            item.fullName,
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
                                          .existParent(suggestionList[i].id),
                                      child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                  onTap: () {
                                                    print(suggestionList[i]
                                                        .fullName);
                                                    if (!controller.existParent(
                                                        suggestionList[i].id)) {
                                                      fcontroller.addParent(
                                                          suggestionList[i]);
                                                    }
                                                  },
                                                  title: Text(
                                                      suggestionList[i]
                                                          .fullName,
                                                      style: TextStyle(
                                                          color: controller
                                                                  .existParent(
                                                                      suggestionList[
                                                                              i]
                                                                          .id)
                                                              ? Colors.grey
                                                              : Colors
                                                                  .black)))))))))
                    ])))));
  }
}
