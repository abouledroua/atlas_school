import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/screen/ficheenseignant.dart';
import 'package:atlas_school/view/widget/listenseignant/emptylistenseignant.dart';
import 'package:atlas_school/view/widget/listenseignant/listenseignantwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEnseignants extends StatelessWidget {
  const ListEnseignants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListEnseignantsController controller = Get.find();
    return MyWidget(
        drawer: AppData.myDrawer(context),
        actions: controller.myActions(),
        title: "Liste des Enseignants",
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: AppColor.enseignant,
                onPressed: () {
                  Get.to(() => FicheEnseignant())?.then((value) {
                    if (value == "success") {
                      controller.getEnseignants();
                    }
                  });
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListEnseignantsController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.enseignants.isEmpty,
                    child: const EmptyListEnseignant(),
                    replacement: const ListEnseignantsWidget()))));
  }
}
