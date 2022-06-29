import 'package:flutter/material.dart';

class ValidationEnCoursFicheAnnonce extends StatelessWidget {
  const ValidationEnCoursFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
      CircularProgressIndicator(),
      SizedBox(width: 20),
      Text("validation en cours ...")
    ]);
  }
}
