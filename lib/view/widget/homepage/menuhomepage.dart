import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/homepage/menuitem.dart';
import 'package:flutter/material.dart';

class MenuHomePage extends StatelessWidget {
  const MenuHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              MenuItemHomePage(
                  title: "Annonces",
                  icon: Icons.announcement,
                  color: AppColor.annocne,
                  index: 0),
              MenuItemHomePage(
                  title: "Messages",
                  icon: Icons.sms,
                  color: AppColor.message,
                  index: 1),
              MenuItemHomePage(
                  title: "Gallery",
                  icon: Icons.photo_camera,
                  color: AppColor.gallery,
                  index: 2)
            ]));
  }
}
