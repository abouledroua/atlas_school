import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParentSelectedFicheAnnonce extends StatelessWidget {
  const ListParentSelectedFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
      builder: (controller) => ListView.builder(
          itemCount: controller.parents.length,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, i) => Card(
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Row(children: [
                    Text(
                        (i + 1).toString() +
                            " -  " +
                            controller.parents[i].fullName,
                        style: Theme.of(context).textTheme.bodyText1),
                    const Spacer(),
                    InkWell(
                        onTap: controller.valider
                            ? null
                            : () {
                                controller.removeParent(controller.parents[i]);
                              },
                        child: Ink(
                            child: const Icon(Icons.delete, color: Colors.red)))
                  ])))),
    );
  }
}
