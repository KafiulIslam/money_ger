import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:money_ger/controllers/auth_provider.dart';
import 'package:money_ger/routes/route_path.dart';
import 'package:money_ger/widgets/components/inputFields/common_textfield.dart';
import 'package:money_ger/widgets/components/inputFields/password_inputfield.dart';
import 'package:provider/provider.dart';
import '../../../utils/color.dart';
import '../../../utils/spacer.dart';
import '../../../utils/typograpgy.dart';
import '../../../widgets/components/buttons/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool isLoading = false;
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
                      'Log in',
                      style: tTextStyle500.copyWith(
                          fontSize: 24, color: textPrimaryColor),
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
                    // sixteenVerticalSpace,
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: TextButton(
                    //       onPressed: () {},
                    //       child: Text(
                    //         'Forgot password?',
                    //         style: tTextStyleRegular.copyWith(
                    //             fontSize: 12, color: textPrimaryColor),
                    //       )),
                    // ),
                    primaryVerticalSpace,
                    PrimaryButton(
                      onTap: () async {
                        authProvider.login(
                            _email.text, _password.text, context);
                      },
                      buttonTitle: 'Log in',
                      isLoading: authProvider.isLogin,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Text(
                      'Don’t have an account?',
                      style: tTextStyleRegular.copyWith(fontSize: 14),
                    ),
                    TextButton(
                        onPressed: () {
                          context.go(RouterPath.signup);
                        },
                        child: Text(
                          'Sign up',
                          style: tTextStyle500.copyWith(
                              fontSize: 16, color: primeColor),
                        )),
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
