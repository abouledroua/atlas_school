import 'package:atlas_school/core/constant/routes.dart';
import 'package:atlas_school/view/screen/homepage.dart';
import 'package:atlas_school/view/screen/login.dart';
import 'package:atlas_school/view/screen/privacy_policy.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.login: (context) => const LoginPage(),
  AppRoute.privacy: (context) => const PrivacyPolicy(),
  AppRoute.home: (context) => const HomePage(),
};
