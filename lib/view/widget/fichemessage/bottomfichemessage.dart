// ignore_for_file: avoid_print

import 'dart:math';

import 'package:atlas_school/controller/fichemessage_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class BottomFicheMessage extends StatelessWidget {
  final int i;
  const BottomFicheMessage({Key? key, required this.i}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FicheMessageController controller = Get.find();
    print(" messages[i].sent=${controller.messages[i].sent}");
    const double textSize = 26;
    return Container(
        padding: const EdgeInsets.all(10),
        color: AppColor.white,
        child: ListView(primary: false, shrinkWrap: true, children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                  onTap: () {
                    AwesomeDialog(
                            context: context,
                            dialogType: DialogType.QUESTION,
                            showCloseIcon: true,
                            title: 'Confirmation',
                            btnOkText: "Oui",
                            btnCancelText: "Non",
                            width: min(AppSizes.maxWidth, AppSizes.widthScreen),
                            btnOkOnPress: () {
                              if (controller.messages[i].sent == 1) {
                                controller.deleteMessage(i);
                              } else {
                                controller.messages.removeAt(i);
                                controller.update();
                                Get.back();
                              }
                            },
                            btnCancelOnPress: () {
                              Get.back();
                            },
                            desc: 'Voulez vraiment supprimer ce message ?')
                        .show();
                  },
                  child: Ink(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                        Icon(Icons.delete, color: Colors.red, size: textSize),
                        SizedBox(width: 10),
                        Text("Supprimer",
                            style: TextStyle(
                                color: Colors.red, fontSize: textSize))
                      ])))),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: controller.messages[i].body));
                    AppData.mySnackBar(
                        title: 'Fiche Message',
                        message: "Text copier",
                        color: AppColor.black);
                    Get.back();
                  },
                  child: Ink(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                        Icon(Icons.copy, color: Colors.black, size: textSize),
                        SizedBox(width: 10),
                        Text("Copier Texte",
                            style: TextStyle(
                                color: Colors.black, fontSize: textSize))
                      ])))),
          if (controller.messages[i].sent != 1) const Divider(),
          if (controller.messages[i].sent != 1)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                    onTap: () {
                      AwesomeDialog(
                              context: context,
                              dialogType: DialogType.QUESTION,
                              showCloseIcon: true,
                              title: 'Confirmation',
                              btnOkText: "Oui",
                              btnCancelText: "Non",
                              width:
                                  min(AppSizes.maxWidth, AppSizes.widthScreen),
                              btnOkOnPress: () {
                                controller.resendMsg(i);
                              },
                              btnCancelOnPress: () {
                                Get.back();
                              },
                              desc: 'Voulez vraiment renvoyer ce message ?')
                          .show();
                    },
                    child: Ink(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                          Icon(Icons.send, color: Colors.green, size: textSize),
                          SizedBox(width: 10),
                          Text("Renvoyer",
                              style: TextStyle(
                                  color: Colors.green, fontSize: textSize))
                        ]))))
        ]));
  }
}
