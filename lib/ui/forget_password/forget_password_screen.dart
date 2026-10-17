import 'package:evently_c20_dokki/core/config/app_config.dart';
import 'package:evently_c20_dokki/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:iconsx_plus/iconsx_plus.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const String routeName = "/forget-password";

  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var provider = Provider.of<AppConfig>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.forgetPasswordTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            Image.asset(
              "assets/images/change-setting_${provider.themeMode == ThemeMode.light ? "light" : "dark"}.png",
            ),
            TextFormField(
              decoration: InputDecoration(
                hint: Text(locale.enterYourEmail),
                prefixIcon: Icon(EvaIcons.email_outline),
              ),
            ),
            FilledButton(
              onPressed: () {
                // todo login
              },
              child: Text(locale.resetPassword),
            ),
          ],
        ),
      ),
    );
  }
}
