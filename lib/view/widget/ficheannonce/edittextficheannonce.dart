import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTextFicheAnnonce extends StatelessWidget {
  final String title, hintText;
  final IconData icon;
  final TextEditingController mycontroller;
  final int? nbline;
  const EditTextFicheAnnonce(
      {Key? key,
      required this.title,
      required this.icon,
      required this.hintText,
      required this.mycontroller,
      this.nbline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheAnnonceController>(
        builder: (controller) => TextFormField(
            controller: mycontroller,
            enabled: !controller.valider,
            readOnly: controller.valider,
            maxLines: nbline,
            textInputAction:
                nbline == null ? TextInputAction.newline : TextInputAction.next,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                label: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(title)),
                suffixIcon: Icon(icon),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(16)))));
  }
}
