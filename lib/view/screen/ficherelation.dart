// ignore_for_file: must_be_immutable

import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/ficherelation/ficherelationwidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheRelation extends StatelessWidget {
  int? idParent, idEnfant;
  FicheRelation({Key? key, this.idParent, this.idEnfant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    idParent ??= 0;
    idEnfant ??= 0;
    Get.put(FicheRelationController(idE: idEnfant!, idP: idParent!));
    return MyWidget(
        title: "Fiche Relation",
        child: GestureDetector(onTap: () {
          FocusScope.of(context).unfocus();
        }, child: GetBuilder<FicheRelationController>(builder: (controller) {
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
            return const FicheRelationWidget();
          }
        })));
  }
}
