import 'package:atlas_school/controller/listmessages_controller.dart';
import 'package:atlas_school/view/screen/fichemessage.dart';
import 'package:atlas_school/view/widget/listmessages/tilelistmessages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListMessagesWidget extends StatelessWidget {
  const ListMessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListMessagesController controller = Get.find();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: controller.personnes.length,
            itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  Get.to(() => FicheMessage(
                          idUser: controller.personnes[i].idUser,
                          parentName: controller.personnes[i].name))
                      ?.then((value) => controller.getListMessages());
                },
                child: Container(
                    color: controller.personnes[i].newMsg
                        ? Colors.grey.shade400
                        : Colors.transparent,
                    child: Card(child: TileListMessages(index: i))))));
  }
}
