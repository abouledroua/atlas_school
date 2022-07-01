// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'alphabetlistenfant.dart';

class ListEnfantWidget extends StatelessWidget {
  const ListEnfantWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: GetBuilder<ListEnfantsController>(
            builder: (controller) => Column(children: [
                  if (controller.searching)
                    TextFormField(
                        initialValue: controller.query,
                        onChanged: (value) {
                          controller.updateQuery(value);
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Recherche",
                            suffixIcon: InkWell(
                                onTap: () {
                                  if (controller.searching) {
                                    controller.updateQuery("");
                                  }
                                  controller.updateSearching();
                                },
                                child: Ink(child: const Icon(Icons.clear))),
                            prefixIcon: const Icon(Icons.search))),
                  const Expanded(child: AlphabetScrollPage())
                ])));
  }
}
