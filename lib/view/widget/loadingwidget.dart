import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const CircularProgressIndicator()),
          const Text("Chargement en cours ...")
        ]));
  }
}
