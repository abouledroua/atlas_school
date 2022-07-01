import 'package:flutter/material.dart';

class MyButtonFiches extends StatelessWidget {
  final Color backgroundcolor, borderColor, textColor;
  final String text;
  final void Function()? onPressed;
  const MyButtonFiches(
      {Key? key,
      required this.backgroundcolor,
      required this.textColor,
      required this.borderColor,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: TextButton(
            onPressed: onPressed,
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: textColor))));
  }
}
