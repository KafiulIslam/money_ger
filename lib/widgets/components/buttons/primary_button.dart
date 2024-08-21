import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_ger/widgets/components/custom_loader.dart';
import '../../../utils/color.dart';
import '../../../utils/typograpgy.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;
  final double fontSize;
  final bool isLoading;
  final Color buttonColor;
  final Color buttonTitleColor;

  const PrimaryButton(
      {Key? key,
      required this.onTap,
      required this.buttonTitle,
      this.fontSize = 20.0,
      this.isLoading = false,
      this.buttonColor = secondaryColor,
      this.buttonTitleColor = white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.7, 1),
            colors: <Color>[
              pink,
              primeColor,
            ],
            // image: DecorationImage(
            //     image: AssetImage('assets/images/prime_button.png'),
            //     fit: BoxFit.cover)
          ),
        ),
        child: isLoading
            ? const CustomLoader()
            : Text(
                buttonTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tTextStyle700.copyWith(fontSize: 16, color: white),
              ),
        // ),
      ),
    );
  }
}
