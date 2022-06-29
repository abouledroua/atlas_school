import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:atlas_school/controller/ficheannonce_controller.dart';

class EnteteImageFicheAnnonce extends StatelessWidget {
  const EnteteImageFicheAnnonce({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FicheAnnonceController controller = Get.find();
    return Stack(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.image),
        const SizedBox(width: 10),
        GetBuilder<FicheAnnonceController>(
            builder: (controller) => Text(
                "Images ( ${controller.myImages.length} )",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontWeight: FontWeight.bold),
                overflow: TextOverflow.clip))
      ]),
      Positioned(
          top: 0,
          right: 6,
          child: InkWell(
              onTap: controller.valider
                  ? null
                  : () {
                      controller.showModal();
                    },
              child: Ink(
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.green),
                      child: const Icon(Icons.add, color: Colors.white)))))
    ]);
  }
}
