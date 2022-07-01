import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/core/class/enfant.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AlphabetScrollPage extends StatelessWidget {
  const AlphabetScrollPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListEnfantsController>(builder: (controller) {
      List<Enfant> items = controller.enfants;
      return AzListView(
          indexBarItemHeight: (AppSizes.heightScreen - 80) / 40,
          data: items,
          itemCount: items.length,
          itemBuilder: (context, i) {
            Enfant item = items[i];
            if ((controller.query.isEmpty) ||
                (item.fullName
                    .toUpperCase()
                    .contains(controller.query.toUpperCase()))) {
              return controller.buildListItem(item);
            } else {
              return Container();
            }
          },
          indexHintBuilder: (context, tag) => Container(
              alignment: Alignment.center,
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              child: Text(tag,
                  style: const TextStyle(color: Colors.white, fontSize: 28))),
          indexBarOptions: IndexBarOptions(
              needRebuild: true,
              selectTextStyle: TextStyle(
                  color: Colors.white, fontSize: context.isPortrait ? 12 : 7),
              textStyle: TextStyle(
                  color: Colors.black, fontSize: context.isPortrait ? 12 : 7),
              selectItemDecoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue),
              indexHintAlignment: Alignment.centerRight,
              indexHintOffset: const Offset(-20, 0)),
          padding: const EdgeInsets.all(16));
    });
  }
}
