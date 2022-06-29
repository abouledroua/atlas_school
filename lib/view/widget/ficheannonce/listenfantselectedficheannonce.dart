import 'package:atlas_school/controller/ficheannonce_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEnfantSelectedFicheAnnonce extends StatelessWidget {
  const ListEnfantSelectedFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FicheAnnonceController controller = Get.find();
    return ListView.builder(
        itemCount: controller.enfants.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, i) => Card(
            elevation: 3,
            child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Row(children: [
                  Text((i + 1).toString() + " -  ",
                      style: Theme.of(context).textTheme.bodyText1),
                  SizedBox(
                      width: 40,
                      child: (controller.enfants[i].photo == "")
                          ? Image.asset("images/noPhoto.png")
                          : CachedNetworkImage(
                              //  fit: BoxFit.contain,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              imageUrl: AppData.getImage(
                                  controller.enfants[i].photo,
                                  "PHOTO/ENFANT"))),
                  const SizedBox(width: 5),
                  Text(controller.enfants[i].fullName,
                      style: Theme.of(context).textTheme.bodyText1),
                  const Spacer(),
                  InkWell(
                      onTap: controller.valider
                          ? null
                          : () {
                              // setState(() {
                              //   enfants.removeAt(i);
                              // });
                            },
                      child: Ink(
                          child: const Icon(Icons.delete, color: Colors.red)))
                ]))));
  }
}
