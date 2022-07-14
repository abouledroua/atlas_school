import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuItemHomePage extends StatelessWidget {
  final IconData icon;
  final int index;
  final Color color;
  final String title;
  const MenuItemHomePage(
      {Key? key,
      required this.title,
      required this.icon,
      required this.index,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomePageController>(
        builder: (controller) => InkWell(
            onTap: () {
              controller.changePage(index);
            },
            child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  width: AppSizes.widthScreen / 4 - 30,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon,
                            color: controller.pageIndex == index
                                ? color
                                : AppColor.grey),
                        FittedBox(
                          child: Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: controller.pageIndex == index
                                          ? 18
                                          : 14,
                                      fontWeight: controller.pageIndex == index
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      decoration: controller.pageIndex == index
                                          ? TextDecoration.underline
                                          : null,
                                      color: controller.pageIndex == index
                                          ? color
                                          : AppColor.grey)),
                        )
                      ]),
                ))));
  }
}
