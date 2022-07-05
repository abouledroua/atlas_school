import 'package:atlas_school/controller/fichemessage_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/widget/fichemessage/fichemessageswidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheMessage extends StatelessWidget {
  final int idUser;
  final String parentName;
  const FicheMessage({Key? key, required this.parentName, required this.idUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FicheMessageController controller =
        Get.put(FicheMessageController(idU: idUser, pName: parentName));
    return MyWidget(
        drawer: AppData.myDrawer(context),
        title: parentName,
        actions: controller.myActions(),
        child: GetBuilder<FicheMessageController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: const FicheMessagesWidget())));
  }
}
