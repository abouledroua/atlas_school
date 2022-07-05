// ignore_for_file: avoid_print

import 'package:atlas_school/core/constant/data.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:atlas_school/controller/fichemessage_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:get/get.dart';

class ListMessagesFicheMessage extends StatelessWidget {
  const ListMessagesFicheMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheMessageController>(builder: (controller) {
      print("list of messages (${controller.messages.length})....");
      return ListView.builder(
          controller: controller.scrollController,
          primary: false,
          shrinkWrap: true,
          itemCount: controller.messages.length,
          itemBuilder: (context, i) {
            bool myMessages = (controller.messages[i].idSend == User.idUser);
            return Padding(
                padding: const EdgeInsets.all(4),
                child: Align(
                    alignment: myMessages
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: UnconstrainedBox(
                        child: Row(children: [
                      Visibility(
                          visible:
                              (myMessages && controller.messages[i].sent < 1),
                          child: SizedBox(
                              width: 20,
                              height: 20,
                              child: Center(
                                  child: (controller.messages[i].sent == 0)
                                      ? const CircularProgressIndicator()
                                      : InkWell(
                                          onTap: () {
                                            controller.showModal(i);
                                          },
                                          child: Ink(
                                              child: const Icon(Icons.warning,
                                                  color: Colors.red)))))),
                      Visibility(
                          visible:
                              (myMessages && controller.messages[i].sent < 1),
                          child: const SizedBox(width: 10)),
                      Column(
                          crossAxisAlignment: myMessages
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  controller.showModal(i);
                                },
                                child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: AppSizes.widthScreen * 5 / 7),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: (controller.messages[i].idSend ==
                                                User.idUser)
                                            ? Colors.blue
                                            : Colors.grey.shade600,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: Text(controller.messages[i].body,
                                        style: const TextStyle(
                                            color: Colors.white)))),
                            Text(AppData.printDate(controller.messages[i].date),
                                style: const TextStyle(fontSize: 11))
                          ])
                    ]))));
          });
    });
  }
}
