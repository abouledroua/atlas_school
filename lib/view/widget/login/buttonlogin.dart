import 'package:atlas_school/controller/login_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonLogin extends StatelessWidget {
  final Color backcolor, textcolor;
  final void Function()? onPressed;
  const ButtonLogin(
      {Key? key,
      this.onPressed,
      required this.textcolor,
      required this.backcolor})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: onPressed,
      child: GetBuilder<LoginController>(
          builder: (controller) => Ink(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: backcolor),
              padding: EdgeInsets.symmetric(
                  vertical: 15, horizontal: controller.valider ? 15 : 40),
              child: Visibility(
                  visible: controller.valider,
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: AppColor.white),
                        const SizedBox(width: 24),
                        FittedBox(
                            child: Text("Connexion en cours ...",
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    ?.copyWith(color: textcolor)))
                      ]),
                  replacement: Text("Connect",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          ?.copyWith(color: textcolor))))));
}
