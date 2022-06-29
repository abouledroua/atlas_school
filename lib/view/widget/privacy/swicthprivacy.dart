import 'package:atlas_school/controller/privacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchPrivacy extends StatelessWidget {
  const SwitchPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyController>(
        builder: (controller) => InkWell(
            onTap: () {
              controller.updateAccepte();
            },
            child: Ink(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Switch(value: controller.accept, onChanged: (value) {}),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(children: const [
                    Text("J'accepte les terme d'utilisation",
                        overflow: TextOverflow.clip)
                  ]))
            ]))));
  }
}
