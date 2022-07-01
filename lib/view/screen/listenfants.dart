import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/screen/ficheenfant.dart';
import 'package:atlas_school/view/widget/listenfants/listenfantwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/listenfants/emptylistenfant.dart';

class ListEnfants extends StatelessWidget {
  const ListEnfants({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListEnfantsController controller = Get.put(ListEnfantsController());
    return MyWidget(
        drawer: AppData.myDrawer(context),
        actions: controller.myActions(),
        title: "Liste des Enfants",
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.indigo,
                onPressed: () {
                  Get.to(() => FicheEnfant())?.then((value) {
                    if (value == "success") {
                      controller.getEnfants();
                    }
                  });
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListEnfantsController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.enfants.isEmpty,
                    child: const EmptyListEnfant(),
                    replacement: const ListEnfantWidget()))));
  }
}
