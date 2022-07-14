// ignore_for_file: avoid_print

import 'package:atlas_school/controller/photoview_controller.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomHorizontalListPhotosPhotoView extends StatelessWidget {
  final bool delete;
  final List<Photo> myImages;
  final String folder;
  const BottomHorizontalListPhotosPhotoView(
      {Key? key,
      required this.delete,
      required this.myImages,
      required this.folder})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<MyPhotoViewController>(
      builder: (controller) => Container(
          color: AppColor.black,
          width: double.infinity,
          child: Center(
              child: Container(
                  height: AppSizes.heightScreen / 10,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: myImages.length,
                      itemBuilder: (context, index) {
                        final bool thisPhoto = index == controller.index;
                        final Photo image = myImages[index];
                        final String chemin =
                            AppData.getImage(image.chemin, folder);
                        return GestureDetector(
                            onTap: () {
                              controller.updateIndex(index);
                            },
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: thisPhoto
                                                ? AppColor.amber
                                                : AppColor.white,
                                            width: thisPhoto ? 3 : 0.8)),
                                    width: AppSizes.widthScreen / 10,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: chemin,
                                        placeholder: (context, url) => const Center(
                                            child:
                                                CircularProgressIndicator())))));
                      })))));
}
