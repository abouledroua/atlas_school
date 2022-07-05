import 'dart:math';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';

class IconNameListMessage extends StatelessWidget {
  final String letter;
  const IconNameListMessage({Key? key, required this.letter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = Random().nextInt(4) + 1;
    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  AppColor.lightColor[
                      Random().nextInt(AppColor.lightColor.length - 1) + 1],
                  AppColor.darkColor[
                      Random().nextInt(AppColor.darkColor.length - 1) + 1],
                  AppColor.lightColor[
                      Random().nextInt(AppColor.lightColor.length - 1) + 1],
                  AppColor.lightColor[
                      Random().nextInt(AppColor.lightColor.length - 1) + 1],
                  AppColor.darkColor[
                      Random().nextInt(AppColor.darkColor.length - 1) + 1],
                  AppColor.lightColor[
                      Random().nextInt(AppColor.lightColor.length - 1) + 1],
                ],
                begin: (i == 1)
                    ? Alignment.topLeft
                    : (i == 2)
                        ? Alignment.bottomRight
                        : (i == 3)
                            ? Alignment.topCenter
                            : Alignment.centerRight,
                end: (i == 1)
                    ? Alignment.bottomRight
                    : (i == 2)
                        ? Alignment.topLeft
                        : (i == 3)
                            ? Alignment.bottomLeft
                            : Alignment.topLeft),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
            child: Text(letter, style: Theme.of(context).textTheme.headline2)));
  }
}
