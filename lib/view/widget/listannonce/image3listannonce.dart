import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/view/widget/listannonce/showimagewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Image3ListAnnonce extends StatelessWidget {
  final int index;
  const Image3ListAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: GetBuilder<ListAnnonceController>(builder: (controller) {
        Annonce annonce = controller.annonces[index];
        return ShowImageWidget(annonce: annonce, index: 0);
      })),
      Expanded(
          child: Column(children: [
        Expanded(
            child: GetBuilder<ListAnnonceController>(builder: (controller) {
          Annonce annonce = controller.annonces[index];
          return ShowImageWidget(annonce: annonce, index: 1);
        })),
        const SizedBox(height: 10),
        Expanded(
            child: GetBuilder<ListAnnonceController>(builder: (controller) {
          Annonce annonce = controller.annonces[index];
          return ShowImageWidget(annonce: annonce, index: 2);
        }))
      ]))
    ]);
  }
}
