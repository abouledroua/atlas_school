// ignore_for_file: avoid_print

import 'package:atlas_school/controller/searchparentlistmessage_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/view/screen/fichemessage.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchParentListMessages extends StatelessWidget {
  const SearchParentListMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SearchParentListMessageController());

    return MyWidget(
        title: "Selectionner Parent(s)",
        child: GetBuilder<SearchParentListMessageController>(
            builder: (controller) {
          final List<Parent> suggestionList = controller.query.isEmpty
              ? controller.allparents
              : controller.filtrerCours();
          return Visibility(
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
                                child: Ink(child: const Icon(Icons.search))))),
                    Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            itemCount: suggestionList.length,
                            itemBuilder: (context, i) => Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        onTap: () {
                                          print(suggestionList[i].fullName);
                                          Get.to(() => FicheMessage(
                                                idUser:
                                                    suggestionList[i].idUser,
                                                parentName:
                                                    suggestionList[i].fullName,
                                              ))?.then((value) => Get.back());

                                          // idUser: suggestionList[i]
                                          //     .idUser,
                                          // parentName:
                                          //     suggestionList[i]
                                          //         .fullName));
                                        },
                                        title: Text(
                                            suggestionList[i].fullName))))))
                  ])));
        }));
  }
}
