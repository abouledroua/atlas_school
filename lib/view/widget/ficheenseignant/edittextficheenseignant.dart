import 'package:atlas_school/controller/ficheenseignant_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTextFicheEnseignant extends StatelessWidget {
  final String title, hintText;
  final IconData icon;
  final bool? check;
  final TextEditingController mycontroller;
  final TextInputType keyboardType;
  final void Function()? onPressedIcon;
  final int? nbline;
  const EditTextFicheEnseignant(
      {Key? key,
      required this.title,
      required this.icon,
      required this.hintText,
      required this.mycontroller,
      required this.nbline,
      this.onPressedIcon,
      this.check,
      required this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheEnseignantController>(
        builder: (controller) => TextFormField(
            controller: mycontroller,
            enabled: !controller.valider,
            readOnly: controller.valider,
            maxLines: nbline,
            keyboardType: keyboardType,
            textInputAction:
                nbline == null ? TextInputAction.newline : TextInputAction.next,
            decoration: InputDecoration(
                hintText: hintText,
                errorText:
                    check == null || !check! ? null : 'Champs Obligatoire',
                hintStyle: const TextStyle(fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                label: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(title)),
                suffixIcon:
                    IconButton(onPressed: onPressedIcon, icon: Icon(icon)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColor.black),
                    borderRadius: BorderRadius.circular(16)))));
  }
}
