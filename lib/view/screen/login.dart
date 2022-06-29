// import 'package:atlas_school/classes/data.dart';
import 'package:atlas_school/controller/login_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/image_asset.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/widget/login/buttonlogin.dart';
import 'package:atlas_school/view/widget/login/edittextlogin.dart';
import 'package:atlas_school/view/widget/login/subtitlelogin.dart';
import 'package:atlas_school/view/widget/login/textinscriptionlogin.dart';
import 'package:atlas_school/view/widget/login/titlelogin.dart';
import 'package:atlas_school/view/widget/mywidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    double horPad = AppSizes.widthScreen / 6;
    double internPad = 20;
    return MyWidget(
        backgroudImage: AppImageAsset.wallLogin,
        child: WillPopScope(
            onWillPop: controller.onWillPop,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(children: [
                  const SizedBox(height: 30),
                  TitleLogin(title: 'Bonjour', horPad: horPad),
                  const SizedBox(height: 10),
                  SubTitleLogin(
                      title: 'Connectez-vous à votre compte', horPad: horPad),
                  const SizedBox(height: 30),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: AppSizes.widthScreen / 10),
                      padding: const EdgeInsets.all(10),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 10,
                          child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              children: [
                                const SizedBox(height: 16),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: internPad,
                                        vertical: internPad / 2),
                                    child: EditTextLogin(
                                        title: "Nom d'utilisateur",
                                        hintText: "nom d'utilisateur",
                                        isPassword: false,
                                        icon: Icons.person_outline_outlined,
                                        mycontroller:
                                            controller.userController)),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: internPad,
                                        right: internPad,
                                        top: internPad / 2),
                                    child: EditTextLogin(
                                        title: "Mot de passe",
                                        hintText: "mot de passe",
                                        isPassword: true,
                                        icon: Icons.password_outlined,
                                        mycontroller:
                                            controller.passController)),
                                TextInscriptionLogin(horPad: internPad),
                                const SizedBox(height: 16),
                                Center(
                                    child: GetBuilder<LoginController>(
                                        builder: (controller) => ButtonLogin(
                                            onPressed: controller.valider
                                                ? null
                                                : () {
                                                    controller.onValidate();
                                                  },
                                            text: "Connect",
                                            backcolor: AppColor.primary,
                                            textcolor: AppColor.white))),
                                const SizedBox(height: 16)
                              ])))
                ]))));
  }
}
