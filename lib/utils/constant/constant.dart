import 'package:flutter/material.dart';
import '../color.dart';


class AppConstant{

  static final divider = Divider(color: borderColor);

  static final focusOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: secondaryColor),
  );

  static final enableOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: trans),
  );

  static final outlineErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: red, width: 1.0),
  );

  static final primaryRadius = BorderRadius.circular(12);


  /// user image url ///

  static String userImageUrl = '';

 /// base url ///
static const baseUrl = 'http://arabic.live.pwtech.pw:9001/';

}


// InputDecoration(
// filled: true,
// fillColor: assColor,
// contentPadding: const EdgeInsets.all(12),
// hintText: 'Enter your this month\'s budget',
// hintStyle: hintTextStyle,
// focusedBorder: AppConstant.focusOutLineBorder,
// enabledBorder: AppConstant.enableOutLineBorder,
// errorBorder: AppConstant.outlineErrorBorder,
// focusedErrorBorder: AppConstant.outlineErrorBorder,
// focusColor: primaryColor,
// )