import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/view/widget/ficheannonce/listenfantselectedficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/listgroupeselectedficheannonce.dart';
import 'package:atlas_school/view/widget/ficheannonce/listparentselectedficheannonce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EspaceVisibiliteFicheAnnonce extends StatelessWidget {
  final double padBottom;
  const EspaceVisibiliteFicheAnnonce({Key? key, required this.padBottom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
        builder: (controller) =>
            ListView(primary: false, shrinkWrap: true, children: [
              Padding(
                  padding: EdgeInsets.all(padBottom / 2),
                  child: Text(
                      (controller.visibiliteMode == 1)
                          ? "Tous le Monde"
                          : (controller.visibiliteMode == 2)
                              ? "Seulement les groupes suivants : "
                              : (controller.visibiliteMode == 3)
                                  ? "Seulement les parents suivants : "
                                  : "Seulement les enfants suivants : ",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                      overflow: TextOverflow.clip)),
              controller.loadingSub
                  ? const Center(child: CircularProgressIndicator())
                  : Visibility(
                      visible: (controller.visibiliteMode != 1),
                      child: Visibility(
                          visible: (controller.visibiliteMode == 2),
                          child: const ListGroupeSelectedFicheAnnonce(),
                          replacement: Visibility(
                              visible: (controller.visibiliteMode == 3),
                              child: const ListParentSelectedFicheAnnonce(),
                              replacement:
                                  const ListEnfantSelectedFicheAnnonce()))),
              if (controller.visibiliteMode == 2 &&
                      controller.groupes.isEmpty ||
                  controller.visibiliteMode == 3 &&
                      controller.parents.isEmpty ||
                  controller.visibiliteMode == 4 && controller.enfants.isEmpty)
                Center(
                    child: Text(
                        (controller.visibiliteMode == 2)
                            ? "Aucun groupe séléctionné !!!"
                            : (controller.visibiliteMode == 3)
                                ? "Aucun parent séléctionné !!!"
                                : "Aucun enfant séléctionné !!!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold)))
            ]));
  }
}
