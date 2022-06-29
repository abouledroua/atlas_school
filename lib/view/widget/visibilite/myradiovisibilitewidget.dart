import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyRadioWidgetVisibilite extends StatelessWidget {
  final String title, sub, val;
  final IconData icon;
  const MyRadioWidgetVisibilite(
      {Key? key,
      required this.title,
      required this.sub,
      required this.val,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
        builder: (controller) => RadioListTile(
            selected: controller.radio == val,
            title: InkWell(
                onTap: () {
                  controller.onRadioChange(val);
                },
                child: Ink(
                    child: Row(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(icon)),
                  const SizedBox(width: 6),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(sub,
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 11)))
                      ])
                ]))),
            groupValue: controller.radio,
            onChanged: (value) {
              controller.onRadioChange(value);
            },
            value: val));
  }
}
