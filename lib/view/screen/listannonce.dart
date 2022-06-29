// ignore_for_file: avoid_print

import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/screen/ficheannonce.dart';
import 'package:atlas_school/view/widget/listannonce/emptylistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/listannoncewidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAnnonces extends StatelessWidget {
  const ListAnnonces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    return MyWidget(
        color: AppColor.grey,
        actions: controller.myActions(),
        title: "Liste des Annonces",
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: Colors.indigo,
                onPressed: () {
                  Get.to(() => FicheAnnonce())?.then((value) {
                    if (value == "success") {
                      controller.getAnnonces();
                    }
                  });
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListAnnonceController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.annonces.isEmpty,
                    child: const EmptyListAnnonce(),
                    replacement: const ListAnnonceWidget()))));
  }
}
