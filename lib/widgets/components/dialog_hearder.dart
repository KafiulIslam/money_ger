import 'package:flutter/material.dart';
import '../../utils/color.dart';
import '../../utils/typograpgy.dart';

class DialogHeader extends StatelessWidget {
  final String title;

  const DialogHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.clear,
              color: trans,
            )),
        Text(
          title,
          style: tTextStyle500.copyWith(fontSize: 18, color: black),
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.clear,
              color: iconColor,
            )),
      ],
    );
  }
}
