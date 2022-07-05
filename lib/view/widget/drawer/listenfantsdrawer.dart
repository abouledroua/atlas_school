// ignore_for_file: avoid_print

import 'package:atlas_school/controller/user_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOfEnfantDrawer extends StatelessWidget {
  const ListOfEnfantDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (controller) {
      print('list of enfants = ${controller.enfants.length}');
      bool loading = controller.loading || controller.enfants.isEmpty;
      return Visibility(
          visible: loading,
          child: Visibility(
              visible: controller.error,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    controller.getListEnfant();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Actualiser"))),
          replacement: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.enfants.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                        horizontalTitleGap: 4,
                        title: Text(controller.enfants[i].fullName,
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.clip),
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
                                            "PHOTO/ENFANT")))));
                  })));
    });
  }
}
