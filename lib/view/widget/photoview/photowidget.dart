import 'package:atlas_school/controller/photoview_controller.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoWidget extends StatelessWidget {
  final List<Photo> myImages;
  final String folder;
  const PhotoWidget({Key? key, required this.myImages, required this.folder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPhotoViewController>(builder: (controller) {
      final image = myImages[controller.index];
      return PhotoViewGallery.builder(
          loadingBuilder: (context, event) =>
              const Center(child: CircularProgressIndicator()),
          onPageChanged: (index) => controller.updateIndex(index),
          pageController: controller.pageController,
          itemCount: myImages.length,
          builder: (context, i) {
            return PhotoViewGalleryPageOptions(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
                imageProvider:
                    NetworkImage(AppData.getImage(image.chemin, folder)));
          });
    });
  }
}
