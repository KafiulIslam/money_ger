import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/views/auth/login/login_screen.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
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
                    primaryVerticalSpace,
                    PrimaryButton(
                      onTap: () {
                        if (_email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          authProvider.signUp(
                              _email.text, _password.text, _name.text, context);
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
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
}
