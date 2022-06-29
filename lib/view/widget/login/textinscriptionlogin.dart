// ignore_for_file: avoid_print

import 'package:atlas_school/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextInscriptionLogin extends StatelessWidget {
  final double horPad;
  const TextInscriptionLogin({Key? key, required this.horPad})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: horPad, vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text("Vous n'avez pas un Compte !!!  ",
              style: Theme.of(context).textTheme.bodyText2),
          GetBuilder<LoginController>(
              builder: (controller) => InkWell(
                  onTap: controller.valider
                      ? null
                      : () {
                          print("inscrire");
                        },
                  child: Ink(
                      child: Text("Inscrire",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                  color: Colors.deepPurpleAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)))))
        ]));
  }
}
