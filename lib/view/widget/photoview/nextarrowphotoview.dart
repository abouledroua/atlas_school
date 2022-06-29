import 'package:atlas_school/controller/photoview_controller.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NextArrowButtonPhotoView extends StatelessWidget {
  final int nbImages;
  const NextArrowButtonPhotoView({Key? key, required this.nbImages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPhotoViewController>(
        builder: (controller) => Visibility(
            visible: (controller.index < nbImages - 1),
            child: Positioned(
                top: AppSizes.heightScreen / 2,
                right: 0,
                child: InkWell(
                    onTap: () {
                      MyPhotoViewController controller = Get.find();
                      controller.updateIndex(controller.index + 1);
                    },
                    child: Ink(
                        color: Colors.black,
                        child: Icon(Icons.arrow_forward_ios_rounded,
                            size: AppSizes.heightScreen / 15,
                            color: Colors.white))))));
  }
}
