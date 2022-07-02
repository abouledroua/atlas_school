// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/parent.dart';
import 'package:atlas_school/view/widget/buildheaderlists.dart';
import 'package:atlas_school/view/widget/listparent/bottomwidgetlistparents.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildListItemListParent extends StatelessWidget {
  final Parent item;
  const BuildListItemListParent({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListParentsController controller = Get.find();
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    return Column(children: [
      Offstage(offstage: offstage, child: BuildHeaderLists(tag: tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          subtitle: Row(children: [
            Text(item.dateNaiss + "  --  ",
                style: const TextStyle(fontSize: 11)),
            Text(item.tel1.isEmpty ? item.tel2 : item.tel1,
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
          ]),
          horizontalTitleGap: 6,
          onTap: () {
            int i = controller.parents.indexOf(item);
            print("item:${item.fullName}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListParents(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
          })
    ]);
  }
}
