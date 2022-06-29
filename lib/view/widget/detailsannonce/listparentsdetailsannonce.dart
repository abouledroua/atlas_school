import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParentDetailAnnonce extends StatelessWidget {
  final int index;
  const ListParentDetailAnnonce({Key? key, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListAnnonceController>(builder: (controller) {
      List<Parent> parents = controller.annonces[index].parents;
      return ListView.builder(
          itemCount: parents.length,
          primary: false,
          shrinkWrap: true,
          itemBuilder: (context, i) => Card(
              elevation: 3,
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10),
                  child: Text((i + 1).toString() + " -  " + parents[i].fullName,
                      style: Theme.of(context).textTheme.bodyText1))));
    });
  }
}
