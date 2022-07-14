// ignore_for_file: avoid_print

import 'package:atlas_school/core/class/fetch.dart';
import 'package:atlas_school/core/class/gest_photos.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/services/settingservice.dart';
import 'package:atlas_school/routes.dart';
import 'package:atlas_school/view/screen/welcome.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialService();
  Fetch.searchNewMessages();
  GestGalleryImages.uploadGalleryImages();
  runApp(const MyApp());
}

Future initialService() async {
  await Get.putAsync(() => SettingServices().init());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Atlas School',
        routes: routes,
        home: const WelcomePage(),
        theme: ThemeData(
            primaryColor: Colors.blue,
            textTheme: const TextTheme(
                headline1: TextStyle(
                    color: AppColor.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Traditional"),
                headline2: TextStyle(
                    color: AppColor.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Traditional"),
                bodyText1: TextStyle(
                    color: AppColor.greyblack,
                    fontSize: 16,
                    fontFamily: "Traditional"),
                bodyText2: TextStyle(
                    color: AppColor.black,
                    fontSize: 12,
                    fontFamily: "Traditional"),
                button: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: "Traditional"))));
  }
}
