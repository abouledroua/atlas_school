import 'package:flutter/material.dart';

class SubTitleLogin extends StatelessWidget {
  final double horPad;
  final String title;
  const SubTitleLogin({Key? key, required this.horPad, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horPad),
            child: Text(title, style: Theme.of(context).textTheme.bodyText1)));
  }
}
