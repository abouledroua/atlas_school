import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/annonce.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/detailsannonce.dart';
import 'package:atlas_school/view/widget/listannonce/showimagewidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Image4ListAnnonce extends StatelessWidget {
  final int index;
  const Image4ListAnnonce({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    Annonce annonce = controller.annonces[index];
    int nb = annonce.images.length - 3;
    return GestureDetector(
        onTap: () {
          Get.to(() => DetailsAnnoncePage(index: index));
        },
        child: Stack(children: [
          Row(children: [
            Expanded(
                child: GetBuilder<ListAnnonceController>(builder: (controller) {
              Annonce annonce = controller.annonces[index];
              return ShowImageWidget(annonce: annonce, index: 0);
            })),
            Expanded(
                child: Column(children: [
              Expanded(child:
                  GetBuilder<ListAnnonceController>(builder: (controller) {
                Annonce annonce = controller.annonces[index];
                return ShowImageWidget(annonce: annonce, index: 1);
              })),
              const SizedBox(height: 10),
              Expanded(child:
                  GetBuilder<ListAnnonceController>(builder: (controller) {
                Annonce annonce = controller.annonces[index];
                return ShowImageWidget(annonce: annonce, index: 2);
              }))
            ]))
          ]),
          Positioned(
              top: AppSizes.heightScreen / 4 - 10,
              left: AppSizes.widthScreen / 2 - 10,
              child: Container(
                  color: Colors.grey.withOpacity(0.5),
                  height: AppSizes.heightScreen / 4,
                  width: AppSizes.widthScreen / 2,
                  child: Center(
                      child: Text("+$nb",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 40)))))
        ]));
  }
}
