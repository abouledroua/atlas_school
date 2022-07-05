import 'package:atlas_school/controller/listmessages_controller.dart';
import 'package:atlas_school/view/widget/listmessages/emptylistmessages.dart';
import 'package:atlas_school/view/widget/listmessages/listmessageswidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:get/get.dart';

class ListMessages extends StatelessWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListMessagesController controller = Get.find();
    return MyWidget(
        title: "Liste des Messages",
        drawer: AppData.myDrawer(context),
        color: AppColor.grey,
        actions: controller.myActions(),
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: AppColor.message,
                onPressed: () {
                  controller.newMessage();
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListMessagesController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.personnes.isEmpty,
                    child: const EmptyListMessages(),
                    replacement: const ListMessagesWidget()))));
  }
}
