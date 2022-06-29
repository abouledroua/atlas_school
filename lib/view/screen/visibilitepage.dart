// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/ficheannonce/mybuttonficheannonce.dart';
import 'package:atlas_school/view/widget/visibilite/myradiovisibilitewidget.dart';
import 'package:atlas_school/view/widget/visibilite/noselectedvisibilitewidget.dart';
import 'package:atlas_school/view/widget/visibilite/showselectedenfantsvisilitewidget.dart';
import 'package:atlas_school/view/widget/visibilite/showselectedgroupesvisilitewidget.dart';
import 'package:atlas_school/view/widget/visibilite/showselectedparentsvisilitewidget.dart';
import 'package:atlas_school/view/widget/visibilite/titlelistvisibilitewidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisibilitePage extends GetView<FicheAnnonceController> {
  const VisibilitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyWidget(
        title: "Audience",
        child: WillPopScope(
          onWillPop: controller.onWillPopVisibilite,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Qui peut voir votre annonce ?",
                style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(height: 30),
            const MyRadioWidgetVisibilite(
                title: "Public",
                sub: "Tous le monde",
                val: "Public",
                icon: Icons.all_inclusive),
            const MyRadioWidgetVisibilite(
                title: "Groupes spécifié",
                sub: "Seulement les groupes sélectionnés",
                val: "Groupe",
                icon: Icons.people_alt_outlined),
            const MyRadioWidgetVisibilite(
                title: "Parents spécifié",
                sub: "Seulement les parents sélectionnés",
                val: "Parent",
                icon: Icons.group_rounded),
            const MyRadioWidgetVisibilite(
                title: "Enfants spécifié",
                sub: "Seulement les enfants sélectionnés",
                val: "Enfant",
                icon: Icons.person_outline_outlined),
            const SizedBox(height: 10),
            const Divider(),
            GetBuilder<FicheAnnonceController>(
                builder: (controller) => Visibility(
                    visible: (controller.visibiliteMode == 2),
                    child: Visibility(
                        visible: controller.groupes.isNotEmpty,
                        child: const TitleListVisibiliteWidget(
                            msg: "List des Groupes"),
                        replacement: const NoSelectedVisibiliteWidget(
                            msg: "Aucun groupe séléctionné !!!")),
                    replacement: Visibility(
                        visible: (controller.visibiliteMode == 3),
                        child: Visibility(
                            visible: controller.parents.isNotEmpty,
                            child: const TitleListVisibiliteWidget(
                                msg: "List des Parents"),
                            replacement: const NoSelectedVisibiliteWidget(
                                msg: "Aucun parent séléctionné !!!")),
                        replacement: Visibility(
                            visible: (controller.visibiliteMode == 4),
                            child: Visibility(
                                visible: controller.enfants.isNotEmpty,
                                child: const TitleListVisibiliteWidget(
                                    msg: "List des Enfants"),
                                replacement: const NoSelectedVisibiliteWidget(
                                    msg: "Aucun enfant séléctionné !!!")))))),
            GetBuilder<FicheAnnonceController>(
                builder: (controller) => Visibility(
                    visible: (controller.visibiliteMode == 2 &&
                        controller.groupes.isNotEmpty),
                    child: const Expanded(
                        child: SelectedGroupesVisibiliteWidget()),
                    replacement: Visibility(
                        visible: (controller.visibiliteMode == 3 &&
                            controller.parents.isNotEmpty),
                        child: const Expanded(
                            child: SelectedParentsVisibiliteWidget()),
                        replacement: Visibility(
                            visible: (controller.visibiliteMode == 4 &&
                                controller.enfants.isNotEmpty),
                            child: const Expanded(
                                child: SelectedEnfantsVisibiliteWidget()))))),
            Center(
                child: MyButtonsFicheAnnonce(
                    onPressed: () {
                      print("im here");
                      if ((controller.visibiliteMode == 2 &&
                              controller.groupes.isEmpty) ||
                          (controller.visibiliteMode == 3 &&
                              controller.parents.isEmpty) ||
                          (controller.visibiliteMode == 4 &&
                              controller.enfants.isEmpty)) {
                      } else {
                        Get.back();
                      }
                    },
                    borderColor: AppColor.white,
                    backgroundcolor: AppColor.blue1,
                    text: 'Valider',
                    textColor: AppColor.white)),
            const SizedBox(height: 20)
          ])
        ));
  }
}
