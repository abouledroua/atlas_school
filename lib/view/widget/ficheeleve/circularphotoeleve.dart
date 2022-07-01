import 'dart:io';

import 'package:atlas_school/view/widget/selectcameragellerywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/ficheenfant_controller.dart';
import '../../../core/constant/data.dart';

class CircularPhotoFicheEleve extends StatelessWidget {
  const CircularPhotoFicheEleve({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GetBuilder<FicheEnfantController>(
            builder: (controller) => Stack(children: [
                  Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          image: controller.myPhoto.isEmpty
                              ? null
                              : controller.selectPhoto
                                  ? DecorationImage(
                                      image:
                                          FileImage(File(controller.myPhoto)),
                                      fit: BoxFit.cover)
                                  : DecorationImage(
                                      image: NetworkImage(AppData.getImage(
                                          controller.myPhoto, "PHOTO/ENFANT")),
                                      fit: BoxFit.cover))),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              color: Colors.green),
                          child: InkWell(
                              onTap: controller.valider
                                  ? null
                                  : () {
                                      Get.bottomSheet(
                                          SelectCameraGalleryWidget(
                                              onTapCamera: () {
                                            controller
                                                .pickPhoto(ImageSource.camera);
                                            Get.back();
                                          }, onTapGallery: () {
                                            controller
                                                .pickPhoto(ImageSource.gallery);
                                            Get.back();
                                          }),
                                          isScrollControlled: true,
                                          enterBottomSheetDuration:
                                              const Duration(milliseconds: 600),
                                          exitBottomSheetDuration:
                                              const Duration(
                                                  milliseconds: 600));
                                    },
                              child: Ink(
                                  child: const Icon(Icons.edit,
                                      color: Colors.white)))))
                ])));
  }
}
