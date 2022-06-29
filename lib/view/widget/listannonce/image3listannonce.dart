import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Image3ListAnnonce extends StatelessWidget {
  final int index;
  const Image3ListAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    Annonce annonce = controller.annonces[index];
    return Row(children: [
      Expanded(child: AppData.showImage(annonce, 0)),
      Expanded(
          child: Column(children: [
        Expanded(child: AppData.showImage(annonce, 1)),
        const SizedBox(height: 10),
        Expanded(child: AppData.showImage(annonce, 2))
      ]))
    ]);
  }
}
