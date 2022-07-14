import 'package:atlas_school/controller/listphotos_controller.dart';
import 'package:atlas_school/core/class/photo.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/view/screen/photoview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListGalleryWidget extends StatelessWidget {
  const ListGalleryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<ListPhotosController>(
      builder: (controller) => ListView.builder(
          itemCount: controller.listPhotos.length,
          itemBuilder: (context, index) {
            String date = controller.listPhotos[index].date;
            List<Photo> photos = controller.listPhotos[index].photos;
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text(date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.bold))),
                      Wrap(
                          children: photos
                              .map((item) => GestureDetector(
                                  onTap: () {
                                    int i = controller.allPhotos.indexOf(item);
                                    Get.to(() => PhotoViewPage(
                                        index: i,
                                        folder: "GALLERY",
                                        myImages: controller.allPhotos,
                                        delete: !User.isParent));
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.gallery)),
                                          height: 100,
                                          width: 100,
                                          child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              imageUrl: AppData.getImage(
                                                  item.chemin, "GALLERY"))))))
                              .toList()
                              .cast<Widget>())
                    ]));
          }));
}
