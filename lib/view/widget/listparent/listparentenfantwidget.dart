import 'package:atlas_school/controller/bottomlistparents_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListParentEnfantWidget extends StatelessWidget {
  const ListParentEnfantWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomListParentsController controller = Get.find();
    return Container(
        color: Colors.green.shade50,
        child: Column(children: [
          Text("Liste des Enfants",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.clip),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: controller.enfants.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => ListTile(
                  horizontalTitleGap: 4,
                  title: Text(controller.enfants[i].fullName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip),
                  leading: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SizedBox(
                          width: 60,
                          child: (controller.enfants[i].photo == "")
                              ? Image.asset("images/noPhoto.png")
                              : CachedNetworkImage(
                                  //   fit: BoxFit.contain,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  imageUrl: AppData.getImage(
                                      controller.enfants[i].photo,
                                      "PHOTO/ENFANT"))))))
        ]));
  }
}
