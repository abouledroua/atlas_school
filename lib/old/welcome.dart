// import 'dart:math';
// import 'package:atlas_school/classes/data.dart';
// import 'package:atlas_school/view/screen/login.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({Key? key}) : super(key: key);

//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   @override
//   initState() {
//     super.initState();
//     Timer(const Duration(seconds: 3), onClose);
//   }

//   void onClose() {
//     Navigator.of(context).pushReplacement(PageRouteBuilder(
//         maintainState: true,
//         opaque: true,
//         pageBuilder: (context, _, __) => const LoginPage(),
//         transitionDuration: const Duration(seconds: 2),
//         transitionsBuilder: (context, anim1, anim2, child) {
//           return FadeTransition(child: child, opacity: anim1);
//         }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     Data.setSizeScreen(context);
//     return SafeArea(
//         child: Scaffold(
//             body: Container(
//                 padding: EdgeInsets.all(
//                     min(Data.heightScreen, Data.widthScreen) / 6),
//                 child: Center(
//                   child:
//                       Image.asset("images/atlas_school.jpg", fit: BoxFit.cover),
//                 ))));
//   }
// }
