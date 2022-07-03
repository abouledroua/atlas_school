import 'package:atlas_school/controller/ficherelation_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularPhotoWidgetFicheRelation extends StatelessWidget {
  const CircularPhotoWidgetFicheRelation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: 130,
        height: 130,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: showPhoto(), fit: BoxFit.contain)));
  }

  showPhoto() {
    FicheRelationController controller = Get.find();
    if (controller.enfant?.photo == "") {
      return const AssetImage(AppImageAsset.noPhoto);
    } else {
      return NetworkImage(
          AppData.getImage(controller.enfant?.photo, "PHOTO/ENFANT"));
    }
  }
}
