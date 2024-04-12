import 'package:flutter/material.dart';
import '../../../utils/color.dart';
import '../../../utils/constant/constant.dart';
import '../../../utils/typograpgy.dart';

class PasswordInputField extends StatefulWidget {
  final String title;
  final TextEditingController passwordController;
  final String? hintText;

  const PasswordInputField(
      {Key? key,
      required this.title,
      required this.passwordController,
      this.hintText})
      : super(key: key);

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  late bool isPassObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: isPassObscure,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: textFieldFillColor,
        contentPadding: const EdgeInsets.all(12),
        hintText: widget.hintText,
        hintStyle: hintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isPassObscure = !isPassObscure;
              var index = 0;
              if (!isPassObscure) {
                index = 1;
              }
            });
          },
          child: isPassObscure
              ? const Icon(
                  Icons.visibility_off_outlined,
                  color: assBold,
                )
              : const Icon(Icons.visibility_outlined),
        ),
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
