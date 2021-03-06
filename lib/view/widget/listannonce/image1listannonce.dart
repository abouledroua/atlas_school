import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/view/widget/listannonce/showimagewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Image1ListAnnonce extends StatelessWidget {
  final int index;
  const Image1ListAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListAnnonceController>(builder: (controller) {
      Annonce annonce = controller.annonces[index];
      return ShowImageWidget(annonce: annonce, index: 0);
    });
  }
}
