import 'package:flutter/material.dart';

class CancerCard extends StatelessWidget {
  final String name;
  final String present;
  final double width;
  CancerCard({
    super.key,
    required this.name,
    required this.present,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      color: Colors.orangeAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          Text(
            present + '%',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
