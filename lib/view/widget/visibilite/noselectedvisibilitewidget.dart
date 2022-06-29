import 'package:flutter/material.dart';

class NoSelectedVisibiliteWidget extends StatelessWidget {
  final String msg;
  const NoSelectedVisibiliteWidget({Key? key, required this.msg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(msg,
                style: Theme.of(context).textTheme.headline2!.copyWith(
                    color: Colors.red, fontWeight: FontWeight.bold))));
  }
}
