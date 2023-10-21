import 'package:flutter/material.dart';
import 'package:test_cnn/widgets/card.dart';

class ListOfValues extends StatelessWidget {
  final Map<String, int> listOfValues;

  ListOfValues({super.key, required this.listOfValues});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: listOfValues.entries.map((entry) {
        return CancerCard(
            name: entry.key,
            present: entry.value.toString(),
            width: MediaQuery.of(context).size.width);
      }).toList(),
    );
  }
}
