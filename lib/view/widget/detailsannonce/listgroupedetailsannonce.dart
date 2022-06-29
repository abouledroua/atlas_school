import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGroupeDetailAnnonce extends StatelessWidget {
  final int index;
  const ListGroupeDetailAnnonce({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    List<Groupe> groupes = controller.annonces[index].groupes;
    return ListView.builder(
        itemCount: groupes.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    (i + 1).toString() + " -  " + groupes[i].designation,
                    style: Theme.of(context).textTheme.bodyText1))));
  }
}
