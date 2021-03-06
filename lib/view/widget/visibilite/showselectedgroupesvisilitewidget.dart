import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectedGroupesVisibiliteWidget extends GetView<FicheAnnonceController> {
  const SelectedGroupesVisibiliteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    (i + 1).toString() +
                        " -  " +
                        controller.groupes[i].designation,
                    style: Theme.of(context).textTheme.headline2))),
        itemCount: controller.groupes.length,
        primary: false,
        shrinkWrap: true);
  }
}
