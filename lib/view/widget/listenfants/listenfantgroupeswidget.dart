import 'package:atlas_school/controller/bottomlistenfants_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEnfantGroupesWidget extends StatelessWidget {
  const ListEnfantGroupesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomListEnfantsController controller = Get.find();
    return Container(
        color: Colors.amber.shade50,
        child: Column(children: [
          const Divider(),
          Text("Inscrit dans le(s) groupe(s) ",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
              overflow: TextOverflow.clip),
          ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: controller.groupes.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => ListTile(
                  horizontalTitleGap: 4,
                  leading: Text((i + 1).toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip),
                  title: Text(controller.groupes[i].designation,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip)))
        ]));
  }
}
