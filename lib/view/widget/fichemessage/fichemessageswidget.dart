import 'package:atlas_school/controller/fichemessage_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/view/widget/fichemessage/emptyfichemessages.dart';
import 'package:atlas_school/view/widget/fichemessage/listmessagesfichemessage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FicheMessagesWidget extends StatelessWidget {
  const FicheMessagesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheMessageController>(
        builder: (controller) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Expanded(
                  child: Visibility(
                      visible: controller.messages.isEmpty,
                      child: const EmptyFicheMessages(),
                      replacement: const ListMessagesFicheMessage())),
              Visibility(
                  visible: User.msgBlock == 1,
                  child: Center(
                      child: Wrap(children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text("Vous êtes bloqué par l'administration",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.red)))
                  ])),
                  replacement: Row(children: [
                    Flexible(
                        child: TextFormField(
                            autofocus: false,
                            maxLines: null,
                            controller: controller.txtMsg,
                            keyboardType: TextInputType.multiline,
                            decoration:
                                const InputDecoration(hintText: "Message"))),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {
                          controller.sendMessage();
                        },
                        icon: const Icon(Icons.send))
                  ]))
            ])));
  }
}
