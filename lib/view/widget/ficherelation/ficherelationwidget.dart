import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/screen/ajoutenfantficherelation.dart';
import 'package:atlas_school/view/screen/ajoutparentficherelation.dart';
import 'package:atlas_school/view/widget/ficherelation/circularphotoenfant.dart';
import 'package:atlas_school/view/widget/ficherelation/enfantcontentficherelation.dart';
import 'package:atlas_school/view/widget/ficherelation/parentcontentficherelation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheRelationWidget extends StatelessWidget {
  const FicheRelationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheRelationController>(builder: (controller) {
      bool isEnfantNotEmpty =
          (controller.idParent != 0 && controller.enfants.isNotEmpty);
      bool isParentNotEmpty =
          controller.idEnfant != 0 && controller.parents.isNotEmpty;
      bool isEnfantEmpty =
          (controller.idParent != 0 && controller.enfants.isEmpty);
      bool isParentEmpty =
          (controller.idEnfant != 0 && controller.parents.isEmpty);
      bool isAllEmpty = (isEnfantEmpty || isParentEmpty);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (controller.idEnfant != 0)
          const Center(child: CircularPhotoWidgetFicheRelation()),
        if (controller.idEnfant != 0)
          Center(
              child: Text(
                  controller.enfant!.fullName + controller.enfant!.fullName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.clip)),
        if (controller.idParent != 0)
          Text("Parent : " + controller.parent!.fullName,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip),
        const Divider(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(children: [
              Text(
                  (controller.idEnfant != 0)
                      ? "Liste des Parents"
                      : "Liste des Enfants",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: controller.idParent != 0
                          ? AppColor.enfant
                          : AppColor.parent,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: controller.idParent != 0
                              ? AppColor.enfant
                              : AppColor.parent,
                          onPrimary: Colors.white),
                      onPressed: () {
                        if (controller.idEnfant != 0) {
                          Get.to(() => const AjoutParentFicheRelation());
                        } else {
                          Get.to(() => const AjoutEnfantFicheRelation());
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Ajouter")))
            ])),
        const Divider(),
        if (isAllEmpty) const Spacer(),
        if (isAllEmpty)
          Center(
              child: Text(
                  "Aucun " +
                      (controller.idEnfant != 0 ? "Parents" : "Enfant") +
                      " !!!!",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: AppColor.green))),
        if (isAllEmpty) const Spacer(),
        if (isEnfantNotEmpty)
          const Expanded(child: ParentContentFicheRelation()),
        if (isParentNotEmpty)
          const Expanded(child: EnfantContentFicheRelation())
      ]);
    });
  }
}
