import 'package:atlas_school/controller/privacy_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonPrivacy extends StatelessWidget {
  const ButtonPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyController>(
        builder: (controller) => InkWell(
            onTap: controller.accept
                ? () async {
                    controller.continuer();
                  }
                : null,
            child: Ink(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      color: controller.accept
                          ? Colors.green
                          : Colors.grey.shade400,
                      child:
                          Row(mainAxisSize: MainAxisSize.min, children: const [
                        Text("Continuer",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(width: 10),
                        Icon(Icons.arrow_forward, color: Colors.white)
                      ]))
                ]))));
  }
}
