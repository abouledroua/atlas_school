// ignore_for_file: avoid_print

import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/controller/listenfants_controller.dart';
import 'package:atlas_school/controller/listenseignants_controller.dart';
import 'package:atlas_school/controller/listgroupes_controller.dart';
import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/view/screen/deconecterwidget.dart';
import 'package:atlas_school/view/screen/listannonce.dart';
import 'package:atlas_school/view/screen/listenfants.dart';
import 'package:atlas_school/view/screen/listenseignant.dart';
import 'package:atlas_school/view/screen/listgroupe.dart';
import 'package:atlas_school/view/screen/listmessage.dart';
import 'package:atlas_school/view/screen/listparents.dart';
import 'package:atlas_school/view/screen/listphotos.dart';
import 'package:atlas_school/view/widget/homepage/menuhomepage.dart';
import 'package:atlas_school/view/widget/homepage/menuhomepageadmin.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageController hcontroller = Get.put(HomePageController());
    Get.put(ListAnnonceController());
    Get.put(ListParentsController());
    Get.put(ListEnfantsController());
    Get.put(ListGroupesController());
    Get.put(ListEnseignantsController());
    return MyWidget(
        child: WillPopScope(
            onWillPop: hcontroller.onWillPop,
            child: GetBuilder<ListAnnonceController>(
                builder: (anncontroller) => GetBuilder<ListEnfantsController>(
                    builder: (enfcontroller) => GetBuilder<
                            ListGroupesController>(
                        builder: (grcontroller) =>
                            GetBuilder<ListEnseignantsController>(
                                builder: (enscontroller) =>
                                    GetBuilder<ListParentsController>(
                                        builder: (parcontroller) {
                                      bool adminLoading =
                                          (anncontroller.loading ||
                                              grcontroller.loading ||
                                              enfcontroller.loading ||
                                              enscontroller.loading ||
                                              parcontroller.loading);
                                      // bool userLoading = (anncontroller.loading);
                                      return Column(children: [
                                        if (adminLoading) const Spacer(),
                                        if (adminLoading)
                                          Center(
                                              child: ScalingText(
                                                  'Chargement ...',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline2)),
                                        if (adminLoading) const Spacer(),
                                        if (!adminLoading)
                                          Expanded(child:
                                              GetBuilder<HomePageController>(
                                                  builder: (controller) {
                                            if (!User.isAdmin &&
                                                controller.pageIndex > 2) {
                                              controller.changePage(0);
                                            }
                                            controller.scrolltoitem();
                                            switch (controller.pageIndex) {
                                              case 0:
                                                return const ListAnnonces();
                                              case 1:
                                                return const ListMessages();
                                              case 2:
                                                return const ListPhotos();
                                              case 3:
                                                return const ListEnfants();
                                              case 4:
                                                return const ListParents();
                                              case 5:
                                                return const ListGroupes();
                                              case 6:
                                                return const ListEnseignants();
                                              case 7:
                                                return const DeconnecterWidget();
                                              default:
                                                return const ListAnnonces();
                                            }
                                          })),
                                        Visibility(
                                            visible: User.isAdmin,
                                            child: const MenuHomePageAdmin(),
                                            replacement: const MenuHomePage())
                                      ]);
                                    })))))));
  }
}
