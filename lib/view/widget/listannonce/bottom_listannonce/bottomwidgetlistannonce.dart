import 'dart:math';
import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/detailsannonce.dart';
import 'package:atlas_school/view/screen/ficheannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsenfantsbottomwidgetlistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsgroupebottomwidgetlistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsparentbottomwidgetlistannonce.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetWidgetListAnnonce extends StatelessWidget {
  final int ind;
  const BottomSheetWidgetListAnnonce({Key? key, required this.ind})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListAnnonceController controller = Get.find();
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                    child: Center(
                        child: Text(controller.annonces[ind].titre,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.headline1,
                            overflow: TextOverflow.clip))),
                IconButton(
                    onPressed: () {
                      Get.to(() => DetailsAnnoncePage(index: ind));
                    },
                    icon: const Icon(Icons.zoom_out_map_rounded))
              ]),
              const Divider(),
              if (controller.annonces[ind].detail.isNotEmpty)
                Center(
                    child: Text(controller.annonces[ind].detail,
                        maxLines: 6,
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.clip)),
              const Divider(),
              if (User.isAdmin)
                Row(children: [
                  Icon(controller.annonces[ind].visiblite == 1
                      ? Icons.all_inclusive
                      : controller.annonces[ind].visiblite == 2
                          ? Icons.people_alt_outlined
                          : controller.annonces[ind].visiblite == 3
                              ? Icons.group_rounded
                              : Icons.person_outline_outlined),
                  const SizedBox(width: 5),
                  Text(
                      (controller.annonces[ind].visiblite == 1)
                          ? "Visible par tous le monde"
                          : (controller.annonces[ind].visiblite == 2)
                              ? "Visible aux groupes suivant : "
                              : (controller.annonces[ind].visiblite == 3)
                                  ? "Visible aux parents suivant : "
                                  : "Visible aux enfants suivant : ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold))
                ]),
              if (User.isAdmin && controller.annonces[ind].visiblite != 1)
                Visibility(
                    visible: (controller.annonces[ind].visiblite == 2),
                    child: DetailsGroupeBottomWidgetListAnnonce(ind: ind),
                    replacement: Visibility(
                        visible: (controller.annonces[ind].visiblite == 3),
                        child: DetailsParentBottomWidgetListAnnonce(ind: ind),
                        replacement:
                            DetailsEnfantsBottomWidgetListAnnonce(ind: ind))),
              if (User.isAdmin) const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                if (User.isAdmin)
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue, onPrimary: Colors.white),
                      onPressed: () {
                        Get.to(() => FicheAnnonce(
                                idAnnonce: controller.annonces[ind].id))
                            ?.then((value) {
                          if (value == "success") {
                            controller.getAnnonces();
                            Get.back();
                          }
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text("Modifier")),
                if (User.isAdmin)
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, onPrimary: Colors.white),
                      onPressed: () {
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.QUESTION,
                                showCloseIcon: true,
                                title: 'Confirmation',
                                btnOkText: "Oui",
                                btnCancelText: "Non",
                                width: min(
                                    AppSizes.maxWidth, AppSizes.widthScreen),
                                btnOkOnPress: () {
                                  controller.deleteAnnonce(ind);
                                },
                                btnCancelOnPress: () {},
                                desc:
                                    'Voulez vraiment supprimer cette annonce ?')
                            .show();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Supprimer"))
              ])
            ]));
  }
}
