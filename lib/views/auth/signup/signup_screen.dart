import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/routes/route_path.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
import '../../../utils/constant/constant.dart';
import '../../../utils/custom_snack.dart';
import '../../../utils/spacer.dart';
import '../../../utils/typograpgy.dart';
import '../../../widgets/components/buttons/primary_button.dart';
import '../../../widgets/components/inputFields/common_textfield.dart';
import '../../../widgets/components/inputFields/password_inputfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool isLoading = false;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _currency = TextEditingController();
  late String _selectedCurrencySymbol = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AuthProvider>(builder: (_, authProvider, child) {
                return Column(
                  children: [
                    Text(
                      'Create Account',
                      style: tTextStyle500.copyWith(
                          fontSize: 24, color: textPrimaryColor),
                    ),
                    primaryVerticalSpace,
                    CommonTextField(
                      fieldController: _name,
                      hintText: 'Enter your name',
                    ),
                    sixteenVerticalSpace,
                    CommonTextField(
                      fieldController: _email,
                      hintText: 'Enter your email',
                    ),
                    sixteenVerticalSpace,
                    PasswordInputField(
                      title: 'Password',
                      passwordController: _password,
                      hintText: 'Enter the password',
                    ),
                    sixteenVerticalSpace,
                    _buildCurrency(),
                    primaryVerticalSpace,
                    PrimaryButton(
                      onTap: () {
                        if (_email.text.isNotEmpty &&
                            _password.text.isNotEmpty &&
                            _selectedCurrencySymbol.isNotEmpty) {
                          authProvider.signUp(_email.text, _password.text,
                              _name.text, _selectedCurrencySymbol, context);
                        } else {
                          CustomSnack.warningSnack(
                              'Please enter all information', context);
                        }
                      },
                      buttonTitle: 'Sign up',
                      isLoading: authProvider.isAccountCreating,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Text(
                      'Already have an account?',
                      style: tTextStyleRegular.copyWith(fontSize: 14),
                    ),
                    TextButton(
                        onPressed: () {
                          context.go(RouterPath.login);
                        },
                        child: Text(
                          'Log in',
                          style: tTextStyle500.copyWith(
                              fontSize: 16, color: primeColor),
                        )),
                    primaryVerticalSpace
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrency() {
    return TextFormField(
      controller: _currency,
      readOnly: true,
      onTap: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency currency) {
            setState(() {
              _currency.text = currency.name;
              _selectedCurrencySymbol = currency.symbol;
            });
          },
        );
      },
      autofocus: false,
      cursorColor: primeColor,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        filled: true,
        fillColor: assColor,
        contentPadding: const EdgeInsets.all(16),
        hintText: 'Select your currency',
        hintStyle: hintTextStyle,
        focusedBorder: AppConstant.focusOutLineBorder,
        enabledBorder: AppConstant.enableOutLineBorder,
        errorBorder: AppConstant.outlineErrorBorder,
        focusedErrorBorder: AppConstant.outlineErrorBorder,
        focusColor: secondaryColor,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
