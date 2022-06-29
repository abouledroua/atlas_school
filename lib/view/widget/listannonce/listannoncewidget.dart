import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/bottomwidgetlistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/tileannonce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAnnonceWidget extends StatelessWidget {
  const ListAnnonceWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: controller.annonces.length,
            itemBuilder: (context, i) => GestureDetector(
                onTap: () {
                  Get.bottomSheet(BottomSheetWidgetListAnnonce(ind: i),
                      isScrollControlled: true,
                      enterBottomSheetDuration:
                          const Duration(milliseconds: 600),
                      exitBottomSheetDuration:
                          const Duration(milliseconds: 600));
                },
                child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Card(child: TileAnnonce(index: i))))));
  }
}
