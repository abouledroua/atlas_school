import 'package:atlas_school/controller/photoview_controller.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:atlas_school/view/widget/photoview/backarrowphotoview.dart';
import 'package:atlas_school/view/widget/photoview/bottompagephotoview.dart';
import 'package:atlas_school/view/widget/photoview/nextarrowphotoview.dart';
import 'package:atlas_school/view/widget/photoview/photowidget.dart';
import 'package:atlas_school/view/widget/photoview/toppagephotoview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoViewPage extends StatelessWidget {
  final int index;
  final List<Photo> myImages;
  final String folder;
  final bool delete;

  const PhotoViewPage(
      {Key? key,
      required this.index,
      required this.myImages,
      required this.folder,
      required this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MyPhotoViewController(index: index));
    return MyWidget(
        child: Column(children: [
      const TopPagePhotoView(),
      Expanded(
          child: Stack(children: [
        PhotoWidget(myImages: myImages, folder: folder),
        const BackArrowButtonPhotoView(),
        NextArrowButtonPhotoView(nbImages: myImages.length)
      ])),
      BottomPagePhotoView(delete: delete, myImages: myImages)
    ]));
  }
}
