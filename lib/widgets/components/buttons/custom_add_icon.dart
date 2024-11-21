import 'package:flutter/material.dart';
import '../../../utils/assets_path.dart';
import '../../../utils/color.dart';

class CustomAddIcon extends StatelessWidget {
  final VoidCallback onTap;

  const CustomAddIcon({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Image.asset(addIcon, height: 28, width: 28,));
  }
}
