import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGroupeSelectedFicheAnnonce extends StatelessWidget {
  const ListGroupeSelectedFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
      builder: (controller) => ListView.builder(
          itemBuilder: (context, i) => Card(
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Row(children: [
                    Text(
                        (i + 1).toString() +
                            " -  " +
                            controller.groupes[i].designation,
                        style: Theme.of(context).textTheme.bodyText1),
                    const Spacer(),
                    InkWell(
                        onTap: controller.valider
                            ? null
                            : () {
                                controller.removeGroupe(controller.groupes[i]);
                                // setState(() {
                                //   groupes.removeAt(i);
                                // });
                              },
                        child: Ink(
                            child: const Icon(Icons.delete, color: Colors.red)))
                  ]))),
          itemCount: controller.groupes.length,
          primary: false,
          shrinkWrap: true),
    );
  }
}
