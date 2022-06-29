import 'package:atlas_school/controller/login_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonLogin extends StatelessWidget {
  final String text;
  final Color backcolor, textcolor;
  final void Function()? onPressed;
  const ButtonLogin(
      {Key? key,
      required this.text,
      this.onPressed,
      required this.textcolor,
      required this.backcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onPressed,
      child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: backcolor),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
          child: GetBuilder<LoginController>(
              builder: (controller) => Visibility(
                  visible: controller.valider,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: AppColor.white),
                        const SizedBox(width: 24),
                        Text("Connexion en cours ...",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                ?.copyWith(color: textcolor))
                      ]),
                  replacement: Text(text,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: textcolor))))));
}
