import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/view/widget/listparent/alphabetlistparent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParentWidget extends StatelessWidget {
  const ListParentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: GetBuilder<ListParentsController>(
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
                  const Expanded(child: AlphabetScrollPageParent())
                ])));
  }
}
