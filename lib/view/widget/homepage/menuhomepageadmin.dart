import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/homepage/menuitem.dart';
import 'package:flutter/material.dart';

class MenuHomePageAdmin extends StatelessWidget {
  const MenuHomePageAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
            height: AppSizes.heightScreen / 10,
            child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 10),
                  const MenuItemHomePage(
                      title: "Annonces",
                      icon: Icons.announcement,
                      color: AppColor.annocne,
                      index: 0),
                  const MenuItemHomePage(
                      title: "Messages",
                      icon: Icons.sms,
                      color: AppColor.message,
                      index: 1),
                  const MenuItemHomePage(
                      title: "Gallery",
                      icon: Icons.photo_camera,
                      color: AppColor.gallery,
                      index: 2),
                  const MenuItemHomePage(
                      title: "Enfants",
                      icon: Icons.person_outline_sharp,
                      color: AppColor.enfant,
                      index: 3),
                  const MenuItemHomePage(
                      title: "Parents",
                      icon: Icons.group_outlined,
                      color: AppColor.parent,
                      index: 4),
                  const MenuItemHomePage(
                      title: "Groupes",
                      icon: Icons.groups_outlined,
                      color: AppColor.groupe,
                      index: 5),
                  const MenuItemHomePage(
                      title: "Enseignants",
                      icon: Icons.person_pin_outlined,
                      color: AppColor.enseignant,
                      index: 6),
                  MenuItemHomePage(
                      title: "Déconnecter",
                      icon: Icons.logout,
                      color: AppColor.red,
                      index: 7),
                  const SizedBox(width: 10),
                ])));
  }
}
