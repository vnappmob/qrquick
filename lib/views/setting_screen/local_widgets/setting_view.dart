import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../models/language_model.dart';
import 'language_screen.dart';

class SettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    bool appTutorial = context.select((AppModel _) => _.appTutorial);
    var appLangCode = context.select((LanguageModel _) => _.appLangCode);
    String languageName = globals.appLanguageDict[appLangCode] ?? '';
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.translate,
            color: textColor,
          ),
          title: Text(
            languageName,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LanguageScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
