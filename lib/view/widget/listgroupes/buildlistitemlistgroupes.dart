// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listgroupes_controller.dart';
import 'package:atlas_school/core/class/groupe.dart';
import 'package:atlas_school/view/widget/buildheaderlists.dart';
import 'package:atlas_school/view/widget/listgroupes/bottomwidgetlistgroupes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildListItemListGroupes extends StatelessWidget {
  final Groupe item;
  const BuildListItemListGroupes({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListGroupesController controller = Get.find();
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(children: [
      Offstage(offstage: offstage, child: BuildHeaderLists(tag: tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.designation),
          leading: const Text(" - "),
          horizontalTitleGap: 6,
          onTap: () {
            int i = controller.groupes.indexOf(item);
            print("item:${item.designation}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListGroupes(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
          })
    ]);
  }
}
