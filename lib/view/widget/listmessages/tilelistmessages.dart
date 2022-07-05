import 'package:atlas_school/controller/listmessages_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/widget/listmessages/iconnamelistmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TileListMessages extends StatelessWidget {
  final int index;
  const TileListMessages({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListMessagesController>(
        builder: (controller) => ListTile(
            title: Text(controller.personnes[index].name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold)),
            leading: controller.personnes[index].isAdmin
                ? const Icon(Icons.admin_panel_settings_outlined,
                    size: 40, color: Colors.blue)
                : IconNameListMessage(
                    letter: controller.personnes[index].name.isEmpty
                        ? ""
                        : controller.personnes[index].name.substring(0, 1)),
            subtitle: Text(controller.personnes[index].lastMsg,
                maxLines: 1, style: Theme.of(context).textTheme.bodyText2),
            trailing: Text(AppData.printDate(controller.personnes[index].date),
                style: const TextStyle(fontSize: 13))));
  }
}
