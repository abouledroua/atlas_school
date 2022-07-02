import 'package:flutter/material.dart';

class EmptyListParentGroupeEnfant extends StatelessWidget {
  final String type;
  const EmptyListParentGroupeEnfant({Key? key, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green.shade50,
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.warning, color: Colors.amber),
            const SizedBox(width: 10),
            Text("Aucun $type !!!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
                overflow: TextOverflow.clip)
          ])
        ]));
  }
}
