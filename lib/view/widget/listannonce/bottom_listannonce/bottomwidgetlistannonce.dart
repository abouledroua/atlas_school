import 'package:atlas_school/controller/listannonce_controller.dart';
import 'package:atlas_school/core/class/user.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:atlas_school/view/screen/detailsannonce.dart';
import 'package:atlas_school/view/screen/ficheannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsenfantsbottomwidgetlistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsgroupebottomwidgetlistannonce.dart';
import 'package:atlas_school/view/widget/listannonce/bottom_listannonce/detailsparentbottomwidgetlistannonce.dart';
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
              Visibility(
                  visible: User.isAdmin,
                  child: Row(children: [
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
                  ])),
              Visibility(
                  visible: User.isAdmin,
                  child: Visibility(
                      visible: (controller.annonces[ind].visiblite != 1),
                      child: Visibility(
                          visible: (controller.annonces[ind].visiblite == 2),
                          child: DetailsGroupeBottomWidgetListAnnonce(ind: ind),
                          replacement: Visibility(
                              visible:
                                  (controller.annonces[ind].visiblite == 3),
                              child: DetailsParentBottomWidgetListAnnonce(
                                  ind: ind),
                              replacement:
                                  DetailsEnfantsBottomWidgetListAnnonce(
                                      ind: ind))))),
              Visibility(visible: User.isAdmin, child: const Divider()),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Visibility(
                    visible: User.isAdmin,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue, onPrimary: Colors.white),
                        onPressed: () {
                          Get.to(() => FicheAnnonce(
                                  idAnnonce: controller.annonces[ind].id))
                              ?.then((value) {
                            if (value == "success") {
                              controller.getAnnonces();
                            }
                          });
                          // var route = MaterialPageRoute(
                          //     builder: (context) =>
                          //         FicheAnnonce(id: annonces[ind].id));
                          // Navigator.of(context).push(route).then(
                          //     (value) => Navigator.of(context).pop("update"));
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Modifier"))),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: controller.annonces[ind].pin
                            ? Colors.grey
                            : Colors.amber,
                        onPrimary: Colors.white),
                    onPressed: () {
                      if (controller.annonces[ind].pin) {
                        controller
                            .unpinAnnonce(ind)
                            .then((value) => Get.back());
                      } else {
                        controller.pinAnnonce(ind).then((value) => Get.back());
                      }
                    },
                    icon: Icon(controller.annonces[ind].pin
                        ? Icons.flag_outlined
                        : Icons.flag),
                    label: Text(
                        controller.annonces[ind].pin ? "Lacher" : "Epingler")),
                Visibility(
                    visible: User.isAdmin,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red, onPrimary: Colors.white),
                        onPressed: () {
                          // AwesomeDialog(
                          //         context: context,
                          //         dialogType: DialogType.QUESTION,
                          //         showCloseIcon: true,
                          //         title: 'Confirmation',
                          //         btnOkText: "Oui",
                          //         btnCancelText: "Non",
                          //         btnOkOnPress: () {
                          //           deleteAnnonce(ind);
                          //         },
                          //         btnCancelOnPress: () {
                          //           Navigator.of(context).pop();
                          //         },
                          //         desc:
                          //             'Voulez vraiment supprimer cette annonce ?')
                          //     .show();
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Supprimer")))
              ])
            ]));
  }
}
