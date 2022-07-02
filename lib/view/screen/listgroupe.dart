import 'package:atlas_school/controller/listgroupes_controller.dart';
import 'package:atlas_school/view/screen/fichegroupe.dart';
import 'package:atlas_school/view/widget/listgroupes/emptylistgroupes.dart';
import 'package:atlas_school/view/widget/listgroupes/listgroupeswidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';

class ListGroupes extends StatelessWidget {
  const ListGroupes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListGroupesController controller = Get.find();
    return MyWidget(
        drawer: AppData.myDrawer(context),
        actions: controller.myActions(),
        title: "Liste des Groupes",
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: AppColor.groupe,
                onPressed: () {
                  Get.to(() => FicheGroupe())?.then((value) {
                    if (value == "success") {
                      controller.getGroupes();
                    }
                  });
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListGroupesController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.groupes.isEmpty,
                    child: const EmptyListGroupes(),
                    replacement: const ListGroupesWidget()))));
  }
}
