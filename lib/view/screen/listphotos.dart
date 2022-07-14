import 'package:atlas_school/controller/listphotos_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/widget/listgallery/emptylistgallery.dart';
import 'package:atlas_school/view/widget/listgallery/listgallerywidget.dart';
import 'package:atlas_school/view/widget/loadingwidget.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:atlas_school/view/widget/selectcameragellerywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPhotos extends StatelessWidget {
  const ListPhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListPhotosController controller = Get.find();
    return MyWidget(
        drawer: AppData.myDrawer(context),
        actions: controller.myActions(),
        title: "Gallerie des Photos",
        floatingActionButton: User.isEns
            ? FloatingActionButton(
                heroTag: "btn2",
                backgroundColor: AppColor.gallery,
                onPressed: () {
                  Get.bottomSheet(
                      SelectCameraGalleryWidget(onTapCamera: () {
                        controller.captureImage();
                        Get.back();
                      }, onTapGallery: () {
                        controller.pickPhotos();
                        Get.back();
                      }),
                      isScrollControlled: true,
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 600),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 600));
                },
                child: const Icon(Icons.add))
            : null,
        child: GetBuilder<ListPhotosController>(
            builder: (controller) => Visibility(
                visible: controller.loading,
                child: const LoadingWidget(),
                replacement: Visibility(
                    visible: controller.listPhotos.isEmpty,
                    child: const EmptyListGallery(),
                    replacement: const ListGalleryWidget()))));
  }
}
