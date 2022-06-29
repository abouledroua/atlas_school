import 'package:atlas_school/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditTextLogin extends StatelessWidget {
  final String title, hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController mycontroller;
  const EditTextLogin(
      {Key? key,
      required this.title,
      required this.isPassword,
      required this.icon,
      required this.hintText,
      required this.mycontroller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        builder: (controller) => TextFormField(
            controller: mycontroller,
            obscureText: isPassword,
            enabled: !controller.valider,
            readOnly: controller.valider,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                label: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 9),
                    child: Text(title)),
                suffixIcon: Icon(icon),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16)))));
  }
}
