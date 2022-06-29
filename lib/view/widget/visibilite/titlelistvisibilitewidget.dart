import 'package:flutter/material.dart';

class TitleListVisibiliteWidget extends StatelessWidget {
  final String msg;
  const TitleListVisibiliteWidget({Key? key, required this.msg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 20.0, bottom: 8),
        child: Text(msg, style: Theme.of(context).textTheme.headline2));
  }
}
