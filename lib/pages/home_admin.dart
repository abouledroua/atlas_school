// // ignore_for_file: avoid_print

// import 'package:atlas_school/classes/gest_annonce_images.dart';
// import 'package:atlas_school/classes/gest_gallery_images.dart';
// import 'package:atlas_school/pages/lists/gallery.dart';
// import 'package:atlas_school/pages/lists/list_annonce.dart';
// import 'package:atlas_school/pages/lists/list_messages.dart';
// import 'package:atlas_school/classes/data.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class HomeAdmin extends StatefulWidget {
//   const HomeAdmin({Key? key}) : super(key: key);

//   @override
//   _HomeAdminState createState() => _HomeAdminState();
// }

// class _HomeAdminState extends State<HomeAdmin> {
//   List<Widget> screens = [];
//   List<Widget> items = <Widget>[];
//   bool i = false;

//   Future<bool> _onWillPop() async {
//     return (await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//                     title: Row(children: const [
//                       Icon(Icons.exit_to_app_sharp, color: Colors.red),
//                       Padding(
//                           padding: EdgeInsets.only(left: 8.0),
//                           child: Text('Etes-vous sur ?'))
//                     ]),
//                     content: const Text(
//                         "Voulez-vous vraiment quitter l'application ?"),
//                     actions: <Widget>[
//                       TextButton(
//                           onPressed: () => Navigator.of(context).pop(false),
//                           child: const Text('Non',
//                               style: TextStyle(color: Colors.red))),
//                       TextButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           child: const Text('Oui',
//                               style: TextStyle(color: Colors.green)))
//                     ]))) ??
//         false;
//   }

//   majItems() {
//     items = <Widget>[
//       const Icon(Icons.person_outline_sharp, color: Colors.white),
//       const Icon(Icons.group_outlined, color: Colors.white),
//       const Icon(Icons.groups_outlined, color: Colors.white),
//       const Icon(Icons.announcement_outlined, color: Colors.white),
//       const Icon(Icons.sms, color: Colors.white),
//       const Icon(Icons.person_pin_outlined, color: Colors.white),
//       const Icon(Icons.photo, color: Colors.white)
//     ];
//     if (!Data.production) {
//       items.add(const FaIcon(FontAwesomeIcons.cogs, color: Colors.white));
//     }
//   }

//   majScreens() {
//     screens = [const ListAnnonce(), const ListMessages(), const GalleriePage()];
//   }

//   @override
//   void initState() {
//     WidgetsFlutterBinding.ensureInitialized(); //all widgets are rendered here
//     Data.index = 0;
//     majItems();
//     majScreens();
//     GestAnnounceImages.uploadAnnonceImages();
//     GestGalleryImages.uploadGalleryImages();
//     super.initState();
//   }

//   Color getItemColor() {
//     switch (Data.index) {
//       case 0:
//         return Colors.indigo;
//       case 1:
//         return Colors.green.shade600;
//       case 2:
//         return Colors.black;
//       default:
//         return Colors.blue;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     Data.myContext = context;
//     Data.setSizeScreen(context);
//     return Container(
//         color: getItemColor(),
//         child: SafeArea(
//             child: WillPopScope(
//                 onWillPop: _onWillPop,
//                 child: ClipRect(
//                     child: Scaffold(
//                         resizeToAvoidBottomInset: true,
//                         bottomNavigationBar: bottomNavigationBar(),
//                         body: screens[Data.index])))));
//   }

//   Widget bottomNavigationBar() => BottomNavigationBar(
//           currentIndex: Data.index,
//           onTap: (value) {
//             setState(() {
//               Data.index = value;
//               majScreens();
//               //  majItems();
//             });
//           },
//           elevation: 0,
//           backgroundColor: Colors.white,
//           fixedColor: Data.index == 0
//               ? Colors.indigo
//               : Data.index == 1
//                   ? Colors.green
//                   : Colors.black,
//           iconSize: 32,
//           selectedLabelStyle:
//               const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           unselectedLabelStyle: const TextStyle(fontSize: 18),
//           items: [
//             if (!Data.currentUser!.isEns)
//               myBottomBarItem(
//                   index: 0,
//                   color: Colors.indigo,
//                   icon: Icons.announcement,
//                   title: "Annonces"),
//             myBottomBarItem(
//                 index: 1,
//                 color: Colors.green,
//                 icon: Icons.message,
//                 title: 'Messages'),
//             myBottomBarItem(
//                 index: 2,
//                 color: Colors.black,
//                 icon: Icons.photo,
//                 title: 'Gallerie')
//           ]);

//   BottomNavigationBarItem myBottomBarItem(
//           {required IconData icon,
//           required Color color,
//           required String title,
//           required int index}) =>
//       BottomNavigationBarItem(
//           icon: Icon(icon,
//               color: Data.index == index ? color : Colors.grey.shade400),
//           label: title,
//           backgroundColor: Colors.white);
// }
