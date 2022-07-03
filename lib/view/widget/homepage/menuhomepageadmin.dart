// ignore_for_file: avoid_print

import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/homepage/menuitem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuHomePageAdmin extends StatelessWidget {
  const MenuHomePageAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
            height: AppSizes.heightScreen / 10,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  const SizedBox(width: 10),
                  Container(
                      key: controller.item0,
                      child: const MenuItemHomePage(
                          title: "Annonces",
                          icon: Icons.announcement,
                          color: AppColor.annocne,
                          index: 0)),
                  Container(
                      key: controller.item1,
                      child: const MenuItemHomePage(
                          title: "Messages",
                          icon: Icons.sms,
                          color: AppColor.message,
                          index: 1)),
                  Container(
                      key: controller.item2,
                      child: const MenuItemHomePage(
                          title: "Gallery",
                          icon: Icons.photo_camera,
                          color: AppColor.gallery,
                          index: 2)),
                  Container(
                      key: controller.item3,
                      child: const MenuItemHomePage(
                          title: "Enfants",
                          icon: Icons.person_outline_sharp,
                          color: AppColor.enfant,
                          index: 3)),
                  Container(
                      key: controller.item4,
                      child: const MenuItemHomePage(
                          title: "Parents",
                          icon: Icons.group_outlined,
                          color: AppColor.parent,
                          index: 4)),
                  Container(
                      key: controller.item5,
                      child: const MenuItemHomePage(
                          title: "Groupes",
                          icon: Icons.groups_outlined,
                          color: AppColor.groupe,
                          index: 5)),
                  Container(
                      key: controller.item6,
                      child: const MenuItemHomePage(
                          title: "Enseignants",
                          icon: Icons.person_pin_outlined,
                          color: AppColor.enseignant,
                          index: 6)),
                  MenuItemHomePage(
                      title: "Déconnecter",
                      icon: Icons.logout,
                      color: AppColor.red,
                      index: 7),
                  const SizedBox(width: 10),
                ]))));
  }
}
