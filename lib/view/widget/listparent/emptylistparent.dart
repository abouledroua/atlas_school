import 'package:atlas_school/controller/listparent_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyListParent extends StatelessWidget {
  const EmptyListParent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ListParentsController controller = Get.find();
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
                          : "Aucun Parent !!!!",
                      style: TextStyle(
                          fontSize: 22,
                          color: controller.error ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold))),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    controller.getParents();
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text("Actualiser"))
            ]));
  }
}
