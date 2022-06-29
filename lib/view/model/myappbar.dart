import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final bool isBack;
  final Widget? actions;
  const MyAppBar(
      {Key? key, required this.title, required this.isBack, this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Visibility(
          visible: isBack,
          child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back))),
      const Spacer(),
      Text(title, style: Theme.of(context).textTheme.headline1),
      const Spacer(),
    ]);
  }
}
