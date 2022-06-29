// ignore_for_file: avoid_print

import 'package:atlas_school/controller/privacy_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:atlas_school/view/widget/privacy/buttonprivacy.dart';
import 'package:atlas_school/view/widget/privacy/privacytext.dart';
import 'package:atlas_school/view/widget/privacy/swicthprivacy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PrivacyController controller = Get.put(PrivacyController());
    double heightPad = 20;
    return MyWidget(
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(children: [
                  SizedBox(height: heightPad),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Règles d'utilisation de l'application",
                              style: Theme.of(context).textTheme.headline1))),
                  Center(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              "Veuillez lire et accepter les termes d'utilisation de l'application ATLAS SCHOOL",
                              style: Theme.of(context).textTheme.bodyText1))),
                  const Divider(color: AppColor.black),
                  const PrivacyText(),
                  const Divider(),
                  const SwitchPrivacy(),
                  SizedBox(height: heightPad),
                  const ButtonPrivacy(),
                  SizedBox(height: heightPad)
                ]))));
  }
}
