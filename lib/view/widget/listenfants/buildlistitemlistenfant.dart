// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/view/widget/listenfants/bottomwidgetlistenfants.dart';
import 'package:atlas_school/view/widget/buildheaderlists.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuildListItemListEnfant extends StatelessWidget {
  final Enfant item;
  const BuildListItemListEnfant({Key? key, required this.item})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListEnfantsController controller = Get.find();
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    final photo = AppData.getImage(item.photo, "PHOTO/ENFANT");
    return Column(children: [
      Offstage(offstage: offstage, child: BuildHeaderLists(tag: tag)),
      ListTile(
          tileColor: item.etat == 1 ? Colors.transparent : Colors.grey.shade400,
          title: Text(item.fullName),
          leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: SizedBox(
                  width: 60,
                  child: (item.photo == "")
                      ? Image.asset(AppImageAsset.noPhoto)
                      : CachedNetworkImage(
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          imageUrl: photo))),
          subtitle: Row(children: [
            Text(item.dateNaiss + "  --  ",
                style: const TextStyle(fontSize: 11)),
            Text(AppData.calculateAge(DateTime.parse(item.dateNaiss)),
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
          ]),
          horizontalTitleGap: 6,
          onTap: () {
            int i = controller.enfants.indexOf(item);
            print("item:${item.fullName}, index =$i");
            Get.bottomSheet(BottomSheetWidgetListEnfant(ind: i),
                isScrollControlled: true,
                enterBottomSheetDuration: const Duration(milliseconds: 600),
                exitBottomSheetDuration: const Duration(milliseconds: 600));
          })
    ]);
  }
}
