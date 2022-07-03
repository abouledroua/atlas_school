import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/screen/ajoutenfantficheclasse.dart';
import 'package:atlas_school/view/screen/ajoutgroupeficheclasse.dart';
import 'package:atlas_school/view/widget/ficheclasse/circularphotoenfant.dart';
import 'package:atlas_school/view/widget/ficheclasse/enfantcontentficheclasse.dart';
import 'package:atlas_school/view/widget/ficheclasse/groupecontentficheclasse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheClasseWidget extends StatelessWidget {
  const FicheClasseWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheClasseController>(builder: (controller) {
      bool isEnfantNotEmpty =
          (controller.idGroupe != 0 && controller.enfants.isNotEmpty);
      bool isGroupeNotEmpty =
          controller.idEnfant != 0 && controller.groupes.isNotEmpty;
      bool isEnfantEmpty =
          (controller.idGroupe != 0 && controller.enfants.isEmpty);
      bool isGroupeEmpty =
          (controller.idEnfant != 0 && controller.groupes.isEmpty);
      bool isAllEmpty = (isEnfantEmpty || isGroupeEmpty);
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (controller.idEnfant != 0)
          const Center(child: CircularPhotoWidgetFicheClasse()),
        if (controller.idEnfant != 0)
          Center(
              child: Text(
                  controller.enfant!.fullName + controller.enfant!.fullName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.clip)),
        if (controller.idGroupe != 0)
          Text("Groupe : " + controller.groupe!.designation,
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
                      ? "Liste des Groupes"
                      : "Liste des Enfants",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: controller.idGroupe != 0
                          ? AppColor.enfant
                          : AppColor.groupe,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: controller.idGroupe != 0
                              ? AppColor.enfant
                              : AppColor.groupe,
                          onPrimary: Colors.white),
                      onPressed: () {
                        if (controller.idEnfant != 0) {
                          Get.to(() => const AjoutGroupeFicheClasse());
                        } else {
                          Get.to(() => const AjoutEnfantFicheClasse());
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
                      (controller.idEnfant != 0 ? "Groupes" : "Enfant") +
                      " !!!!",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: AppColor.green))),
        if (isAllEmpty) const Spacer(),
        if (isEnfantNotEmpty) const Expanded(child: GroupeContentFicheClasse()),
        if (isGroupeNotEmpty) const Expanded(child: EnfantContentFicheClasse())
      ]);
    });
  }
}
