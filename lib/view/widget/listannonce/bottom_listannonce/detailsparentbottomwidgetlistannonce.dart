import 'package:flutter/material.dart';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:get/get.dart';

class DetailsParentBottomWidgetListAnnonce extends StatelessWidget {
  final int ind;
  const DetailsParentBottomWidgetListAnnonce({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    return ListView.builder(
        itemCount: controller.annonces[ind].parents.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    (i + 1).toString() +
                        " -  " +
                        controller.annonces[ind].parents[i].fullName,
                    style: Theme.of(context).textTheme.bodyText1))));
  }
}
