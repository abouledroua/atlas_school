// ignore_for_file: must_be_immutable

import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/ficheclasse/ficheclassewidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheClasse extends StatelessWidget {
  int? idGroupe, idEnfant;
  FicheClasse({Key? key, this.idGroupe, this.idEnfant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    idGroupe ??= 0;
    idEnfant ??= 0;
    Get.put(FicheClasseController(idE: idEnfant!, idG: idGroupe!));
    return MyWidget(
        title: "Fiche Classe",
        child: GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: GetBuilder<FicheClasseController>(builder: (controller) {
          if (controller.loading) {
            return const LoadingWidget();
          }
          if (controller.error) {
            return Center(
                child: Text("Erreur de Chargement de données ...",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: AppColor.red)));
          } else {
            return const FicheClasseWidget();
          }
        })));
  }
}
