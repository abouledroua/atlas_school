import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/screen/ficheparent.dart';
import 'package:atlas_school/view/widget/listparent/emptylistparent.dart';
import 'package:atlas_school/view/widget/listparent/listparentwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParents extends StatelessWidget {
  const ListParents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListParentsController controller = Get.find();
    return MyWidget(
        drawer: AppData.myDrawer(context),
        actions: controller.myActions(),
        title: "Liste des Parents",
        floatingActionButton: User.isAdmin
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: AppColor.parent,
                onPressed: () {
                  Get.to(() => FicheParent())?.then((value) {
                    if (value == "success") {
                      controller.getParents();
                    }
                  });
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListParentsController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.parents.isEmpty,
                    child: const EmptyListParent(),
                    replacement: const ListParentWidget()))));
  }
}
