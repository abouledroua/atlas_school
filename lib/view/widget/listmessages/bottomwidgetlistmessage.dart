import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/view/widget/listmessages/searchenseignantlistmessage.dart';
import 'package:atlas_school/view/widget/listmessages/searchparentlistmessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/controller/listmessages_controller.dart';

class BottomWidgetListMessages extends StatelessWidget {
  const BottomWidgetListMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListMessagesController controller = Get.find();
    return SafeArea(
        child: Container(
            color: AppColor.white,
            padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text("Envoyer le message vers : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          Get.back();
                          await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const SearchParentListMessages())
                              .then((value) {
                            controller.getListMessages();
                          });
                        },
                        child: Ink(
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    color: AppColor.parent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.group_outlined),
                                      SizedBox(width: 10),
                                      Text("Parent",
                                          style: TextStyle(fontSize: 20))
                                    ]))))),
                const SizedBox(width: 25),
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          Get.back();
                          await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const SearchEnseignantListMessages())
                              .then((value) {
                            controller.getListMessages();
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                color: AppColor.enseignant,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Ink(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                  Icon(Icons.person_pin_outlined),
                                  SizedBox(width: 10),
                                  Text("Enseignant",
                                      style: TextStyle(fontSize: 20))
                                ])))))
              ])
            ])));
  }
}
