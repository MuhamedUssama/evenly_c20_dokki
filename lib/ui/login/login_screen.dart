import 'package:evently_c20_dokki/core/config/app_config.dart';
import 'package:evently_c20_dokki/core/l10n/app_localizations.dart';
import 'package:evently_c20_dokki/core/utils/numbers_extension.dart';
import 'package:evently_c20_dokki/core/utils/validators.dart';
import 'package:evently_c20_dokki/core/utils/widget_extension.dart';
import 'package:evently_c20_dokki/firebase/auth_service.dart';
import 'package:evently_c20_dokki/ui/forget_password/forget_password_screen.dart';
import 'package:evently_c20_dokki/ui/home/home_screen.dart';
import 'package:evently_c20_dokki/ui/signup/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfig>(context);
    var locale = AppLocalizations.of(context)!;
    var validator = Validator();
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 24,
              crossAxisAlignment: .start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/app_logo_${provider.themeMode == ThemeMode.light ? "light" : "dark"}.png",
                    width: MediaQuery.sizeOf(context).width * .4,
                  ),
                ),
                16.verticalSpace,
                Text(
                  locale.loginToYourAccount,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: emailController,
                  autovalidateMode: .onUserInteraction,
                  validator: (input) =>
                      validator.emailValidation(input, locale),
                  decoration: InputDecoration(
                    hint: Text(locale.enterYourEmail),
                    prefixIcon: Icon(EvaIcons.email_outline),
                  ),
                ),
                Column(
                  children: [
                    TextFormField(
                      controller: passwordController,
                      autovalidateMode: .onUserInteraction,
                      validator: (input) =>
                          validator.passwordValidation(input, locale),
                      decoration: InputDecoration(
                        hint: Text(locale.enterYourPassword),
                        prefixIcon: Icon(Iconsax.lock_outline),
                        suffixIcon: Icon(Iconsax.eye_slash_outline),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ForgetPasswordScreen.routeName,
                            );
                          },
                          child: Text(locale.forgetPasswordQuestion),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        await authService.loginAccountWithEmailAndPassword(
                          emailController.text,
                          passwordController.text,
                        );
                        Navigator.pushNamedAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          HomeScreen.routeName,
                          (route) => false,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("No user found for that email."),
                            ),
                          );
                        } else if (e.code == 'wrong-password') {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Wrong password provided for that user.",
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(
                          // ignore: use_build_context_synchronously
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.toString())));
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.surface,
                        )
                      : Text(locale.login),
                ),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(locale.dontHaveAccount),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignupScreen.routeName);
                      },
                      child: Text(locale.signUp),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Text(locale.or).allPadding(16),
                    Expanded(child: Divider()),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      Image.asset("assets/images/google_logo.png", scale: 1.4),
                      SizedBox(width: 16),
                      Text(locale.loginWithGoogle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
