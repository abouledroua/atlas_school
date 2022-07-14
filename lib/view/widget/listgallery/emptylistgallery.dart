import 'package:atlas_school/controller/listphotos_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyListGallery extends StatelessWidget {
  const EmptyListGallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListPhotosController controller = Get.find();
    return Container(
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                      controller.error
                          ? "Erreur de connexion !!!"
                          : "Aucune Photo !!!!",
                      style: TextStyle(
                          fontSize: 22,
                          color: controller.error ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    controller.getAllPhotos();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Actualiser"))
            ]));
  }
}
