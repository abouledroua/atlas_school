import 'package:atlas_school/view/screen/visibilitepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/controller/ficheannonce_controller.dart';

class EnteteVisibiliteFicheAnnonce extends StatelessWidget {
  const EnteteVisibiliteFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FicheAnnonceController controller = Get.find();
    return Stack(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.gpp_maybe),
        const SizedBox(width: 10),
        Text("Visiblitée",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.clip)
      ]),
      Positioned(
          top: 0,
          right: 6,
          child: InkWell(
              onTap: controller.valider
                  ? null
                  : () async {
                      Get.to(() => const VisibilitePage());
                    },
              child: Ink(
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.blue),
                      child: const Icon(Icons.edit, color: Colors.white)))))
    ]);
  }
}
