import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../color.dart';


class AppConstant{

  static final divider = Divider(color: borderColor);

  static final focusOutLineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(color: primeColor),
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

  /// expense type list ///

  static final List<String> expenseTypeList = [
    'Food or Drinks',
    'Phone Bill',
    'Transport',
    'House Rent',
    'Electricity Bill',
    'Fuel Bill',
    'Fix & Maintenance',
    'Cosmetics',
    'Groceries',
    'Internet Bill',
    'Kids',
    'Entertainment',
    'Fashion',
    'Travel',
    'Party',
    'Gift',
    'Donation',
    'Social Work',
    'Doctor',
    'Medicine',
    'Insurance',
    'Properties',
    'Vehicle',
    'Sue',
    'Consultant fee',
    'Fee & Charge',
    'Missing',
    'Interest'
  ];
  static final List<String> debtsTypeList = [
    'Debit',
    'Credit',
  ];

  /// for current month, year , id ///
  static final String currentMonth =
  DateFormat.MMMM().format(DateTime.now()).toString();

  static final String currentYear =
  DateFormat.y().format(DateTime.now()).toString();

  static final String currentMonthId = AppConstant.currentMonth + AppConstant.currentYear;


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