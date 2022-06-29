import 'package:atlas_school/core/constant/color.dart';
import 'package:atlas_school/core/constant/sizes.dart';
import 'package:flutter/material.dart';

class SelectCameraGalleryWidget extends StatelessWidget {
  final void Function() onTapGallery, onTapCamera;
  const SelectCameraGalleryWidget(
      {Key? key, required this.onTapGallery, required this.onTapCamera})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        color: AppColor.white,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: onTapGallery,
                        child: Ink(
                            width: AppSizes.widthScreen / 3,
                            child: Column(children: const [
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.photo_album, size: 30)),
                              Text("Gallery", style: TextStyle(fontSize: 20))
                            ]))),
                    InkWell(
                        onTap: onTapCamera,
                        child: Ink(
                            width: AppSizes.widthScreen / 3,
                            child: Column(children: const [
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.camera, size: 30)),
                              Text("Camera", style: TextStyle(fontSize: 20))
                            ])))
                  ]))
        ]));
  }
}
