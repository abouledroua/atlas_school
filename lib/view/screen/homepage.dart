// ignore_for_file: avoid_print

// import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/view/screen/listannonce.dart';
import 'package:atlas_school/view/screen/listmessage.dart';
import 'package:atlas_school/view/screen/listphotos.dart';
import 'package:atlas_school/view/widget/homepage/menuhomepage.dart';
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
    return MyWidget(
        child: WillPopScope(
            onWillPop: hcontroller.onWillPop,
            child: GetBuilder<ListAnnonceController>(
                builder: (controller) => Column(children: [
                      if (controller.loading) const Spacer(),
                      if (controller.loading)
                        Center(
                            child: ScalingText('Chargement ...',
                                style: Theme.of(context).textTheme.headline2)),
                      if (controller.loading) const Spacer(),
                      if (!controller.loading)
                        Expanded(
                            child: GetBuilder<HomePageController>(
                                builder: (controller) => Visibility(
                                    visible: controller.pageIndex == 0,
                                    child: const ListAnnonces(),
                                    replacement: Visibility(
                                        visible: controller.pageIndex == 1,
                                        child: const ListMessages(),
                                        replacement: Visibility(
                                            visible: controller.pageIndex == 2,
                                            child: const ListPhotos()))))),
                      if (!controller.loading) const MenuHomePage()
                    ]))));
  }
}
