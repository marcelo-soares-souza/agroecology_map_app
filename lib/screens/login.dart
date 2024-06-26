import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:agroecology_map_app/configs/config.dart';
import 'package:agroecology_map_app/screens/home.dart';
import 'package:agroecology_map_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 500);
  Duration get singupTime => const Duration(milliseconds: 500);

  Future<String?> _authUser(LoginData data) async {
    bool isAuthenticated = await AuthService.login(data.name, data.password);

    return Future.delayed(loginTime).then((_) {
      if (!isAuthenticated) {
        return 'Incorrect e-mail or password.';
      }

      return null;
    });
  }

  Future<String?> _signUp(SignupData signupData) async {
    // signupData.additionalSignupData?.forEach((key, value) {
    //  debugPrint('$key: $value');
    // });

    Map<String, String> response =
        await AuthService.signup(signupData.additionalSignupData!['name'], signupData.name, signupData.password);

    String status = response['status'].toString();
    String message = response['message'].toString();

    return Future.delayed(singupTime).then((_) {
      if (status == 'failed') {
        return 'Something is wrong. $message';
      }

      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return 'Password recovery not implemented';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: FlutterLogin(
          hideForgotPasswordButton: true,
          hideProvidersTitle: true,
          theme: LoginTheme(
            primaryColor: Theme.of(context).copyWith().shadowColor,
            cardTheme: CardTheme(
              color: Theme.of(context).copyWith().shadowColor,
              surfaceTintColor: Colors.white,
            ),
            inputTheme: const InputDecorationTheme(
              fillColor: Color.fromARGB(255, 99, 180, 101),
              filled: true,
              contentPadding: EdgeInsets.all(10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              labelStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          logo: const AssetImage('assets/images/logo.png'),
          onLogin: _authUser,
          onSignup: _signUp,
          userValidator: (value) => value!.isEmpty ? 'E-mail is required' : null,
          passwordValidator: (value) => value!.length < 6 ? 'Password must be at least 6 characters long.' : null,
          additionalSignupFields: [
            UserFormField(
              fieldValidator: (value) {
                if (value!.isEmpty || value.length < 4) {
                  return 'Must be at least 4 characters long.';
                }
                return null;
              },
              keyName: 'name',
              icon: const Icon(FontAwesomeIcons.userLarge),
              displayName: 'Your Name',
            ),
          ],
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          onRecoverPassword: _recoverPassword,
        )),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          child: Text('Read our Privacy Policy',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          onTap: () => launchUrl(Uri.parse(Config.privacyPolicyPage)),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
