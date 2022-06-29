import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopPagePhotoView extends StatelessWidget {
  const TopPagePhotoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.black,
        child: Row(children: [
          const SizedBox(width: 5),
          InkWell(
              onTap: () {
                Get.back();
              },
              child: Ink(
                  child: const Icon(Icons.arrow_back, color: Colors.white))),
          const Spacer()
        ]));
  }
}
