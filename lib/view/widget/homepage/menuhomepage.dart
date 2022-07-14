import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/homepage/menuitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuHomePage extends StatelessWidget {
  const MenuHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const MenuItemHomePage(
              title: "Annonces",
              icon: Icons.announcement,
              color: AppColor.annocne,
              index: 0),
          Container(
              key: controller.item1,
              child: Stack(children: [
                const MenuItemHomePage(
                    title: "Messages",
                    icon: Icons.sms,
                    color: AppColor.message,
                    index: 1),
                GetBuilder<HomePageController>(
                    builder: (controller) => Visibility(
                        visible: controller.newMessage,
                        child: Positioned(
                            right: 10,
                            top: -4,
                            child: SizedBox(
                                height: AppSizes.heightScreen / 40,
                                width: AppSizes.widthScreen / 16,
                                child:
                                    Icon(Icons.star, color: AppColor.amber)))))
              ])),
          const MenuItemHomePage(
              title: "Gallery",
              icon: Icons.photo_camera,
              color: AppColor.gallery,
              index: 2)
        ]));
  }
}
