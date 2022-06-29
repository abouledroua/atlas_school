import 'dart:math';

import 'package:atlas_school/controller/photoview_controller.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomPagePhotoView extends StatelessWidget {
  final bool delete;
  final List<Photo> myImages;
  const BottomPagePhotoView(
      {Key? key, required this.delete, required this.myImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPhotoViewController>(
        builder: (controller) => Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                color: AppColor.black,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Photo ${controller.index + 1} / ${myImages.length}",
                          style: const TextStyle(color: Colors.white)),
                      if (!User.isParent && delete)
                        InkWell(
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.QUESTION,
                                      showCloseIcon: true,
                                      title: 'Confirmation',
                                      btnOkText: "Oui",
                                      btnCancelText: "Non",
                                      width: min(AppSizes.maxWidth,
                                          AppSizes.widthScreen),
                                      btnOkOnPress: () {
                                        controller.deletePhoto(
                                            image: myImages[controller.index]);
                                      },
                                      btnCancelOnPress: () {},
                                      desc:
                                          'Voulez vraiment supprimer cette photo ?')
                                  .show();
                            },
                            child: Ink(
                                child: Row(children: const [
                              Text("Supprimer ",
                                  style: TextStyle(color: Colors.white)),
                              Icon(Icons.delete, color: Colors.white)
                            ])))
                    ]))));
  }
}
