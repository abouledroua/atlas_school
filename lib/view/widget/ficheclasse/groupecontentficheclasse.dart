// ignore_for_file: avoid_print

import 'package:atlas_school/controller/ficheclasse_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupeContentFicheClasse extends StatelessWidget {
  const GroupeContentFicheClasse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FicheClasseController>(
        builder: (controller) => ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            primary: false,
            shrinkWrap: true,
            itemCount: controller.enfants.length,
            itemBuilder: (context, i) {
              return Container(
                  color: controller.enfants[i].isHomme
                      ? Colors.blue.shade100
                      : Colors.pink.shade100,
                  child: ListTile(
                      horizontalTitleGap: 4,
                      leading: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: SizedBox(
                              width: 60,
                              child: (controller.enfants[i].photo == "")
                                  ? Image.asset("images/noPhoto.png")
                                  : CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      imageUrl: AppData.getImage(
                                          controller.enfants[i].photo,
                                          "PHOTO/ENFANT")))),
                      title: Text(controller.enfants[i].fullName,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.clip),
                      subtitle: Text(controller.enfants[i].adresse,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey.shade800),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(controller.enfants[i].dateNaiss,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 5),
                        GestureDetector(
                            onTap: () {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.ERROR,
                                      showCloseIcon: true,
                                      title: 'Erreur',
                                      btnOkText: "Oui",
                                      btnCancelText: "Non",
                                      btnOkOnPress: () {
                                        print(
                                            "suppression de la classe $controller.idGroupe,${controller.enfants[i].id}");
                                        controller
                                            .deleteClasse(
                                                idGroupe: controller.idGroupe,
                                                idEnfant:
                                                    controller.enfants[i].id,
                                                context: context)
                                            .then((value) {
                                          controller.removeEnfant(
                                              controller.enfants[i]);
                                        });
                                      },
                                      btnCancelOnPress: () {},
                                      desc:
                                          'Voulez vraiment supprimer cette classe ?')
                                  .show();
                            },
                            child: const Icon(Icons.delete, color: Colors.red))
                      ])));
            }));
  }
}
