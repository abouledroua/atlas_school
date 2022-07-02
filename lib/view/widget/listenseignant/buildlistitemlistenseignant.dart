// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/core/class/enseignant.dart';
import 'package:atlas_school/view/widget/buildheaderlists.dart';
import 'package:atlas_school/view/widget/listenseignant/bottomwidgetlistenseignants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildListItemListEnseignant extends StatelessWidget {
  final Enseignant item;
  const BuildListItemListEnseignant({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListEnseignantsController controller = Get.find();
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(children: [
      Offstage(offstage: offstage, child: BuildHeaderLists(tag: tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          subtitle: Text(item.tel1.isEmpty ? item.matiere : item.tel1,
              style: const TextStyle(fontSize: 11)),
          horizontalTitleGap: 6,
          onTap: () {
            int i = controller.enseignants.indexOf(item);
            print("item:${item.fullName}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListEnseignants(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
          })
    ]);
  }
}
