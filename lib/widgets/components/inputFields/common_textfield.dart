import 'package:flutter/material.dart';
import '../../../utils/color.dart';
import '../../../utils/constant/constant.dart';
import '../../../utils/typograpgy.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController fieldController;
  final String? hintText;

  const CommonTextField(
      {Key? key,
      required this.fieldController,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: fieldController,
      autofocus: false,
      cursorColor: primaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        hintStyle: hintTextStyle,
        focusedBorder: AppConstant.focusOutLineBorder,
        enabledBorder: AppConstant.enableOutLineBorder,
        errorBorder: AppConstant.outlineErrorBorder,
        focusedErrorBorder: AppConstant.outlineErrorBorder,
        focusColor: primaryColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
