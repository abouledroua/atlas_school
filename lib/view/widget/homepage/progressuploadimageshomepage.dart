// ignore_for_file: avoid_print

import 'package:atlas_school/controller/homepage_controller.dart';
import 'package:atlas_school/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ProgressIndicatorImageUploadHomePage extends StatelessWidget {
  const ProgressIndicatorImageUploadHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        child: GetBuilder<HomePageController>(builder: (controller) {
          double value = controller.nbImageUploaded / controller.nbImagesTotal;
          double pourc = value * 100;
          print("value=$value");
          return Row(children: [
            Expanded(
                child: StepProgressIndicator(
                    size: 20,
                    totalSteps: controller.nbImagesTotal,
                    currentStep: controller.nbImageUploaded,
                    selectedColor: AppColor.amber,
                    unselectedColor: Colors.transparent,
                    roundedEdges: const Radius.circular(10))),
            const SizedBox(width: 10),
            Text(
                "${controller.nbImageUploaded} / ${controller.nbImagesTotal} (${pourc.toStringAsFixed(0)}%)",
                style: Theme.of(context).textTheme.bodySmall)
          ]);
        }));
  }
}
