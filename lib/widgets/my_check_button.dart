import 'package:flutter/material.dart';

class MyCheckButton extends StatefulWidget {
  final String text;
  final Function()? function;

  const MyCheckButton({super.key, required this.text, required this.function,});

  @override
  State<MyCheckButton> createState() => _MyCheckButtonState();
}

class _MyCheckButtonState extends State<MyCheckButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.blue,
      ),
      child: TextButton(
        onPressed: widget.function,
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
