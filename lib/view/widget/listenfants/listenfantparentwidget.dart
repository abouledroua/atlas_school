import 'package:atlas_school/controller/bottomlistenfants_controller.dart';
import 'package:atlas_school/core/constant/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEnfantParentWidget extends StatelessWidget {
  const ListEnfantParentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomListEnfantsController controller = Get.find();
    return Container(
        color: Colors.green.shade50,
        child: Column(children: [
          const Divider(),
          Text("Liste des Parents ",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.clip),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: controller.parents.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => ListTile(
                  horizontalTitleGap: 4,
                  title: Text(controller.parents[i].fullName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip),
                  trailing: Column(children: [
                    if (controller.parents[i].tel1 != "")
                      GestureDetector(
                          onTap: () {
                            AppData.makeExternalRequest(
                                'tel:${controller.parents[i].tel1}');
                          },
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(controller.parents[i].tel1,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 10),
                            const Icon(Icons.call, color: Colors.green)
                          ])),
                    if (controller.parents[i].tel2 != "")
                      GestureDetector(
                          onTap: () {
                            AppData.makeExternalRequest(
                                'tel:${controller.parents[i].tel2}');
                          },
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(controller.parents[i].tel2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11)),
                            const SizedBox(width: 10),
                            const Icon(Icons.call, color: Colors.green)
                          ]))
                  ])))
        ]));
  }
}
