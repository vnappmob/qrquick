import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../models/language_model.dart';
import '../../../views/all_widgets/card_view.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    var appLangCode = context.select((LanguageModel _) => _.appLangCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.language,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: globals.appThemeDict[appTheme]['colors'][0],
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: globals.appThemeDict[appTheme]['colors'],
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: ListView(
          children: [
            CardView(
              child: Column(
                children: List.generate(
                    AppLocalizations.supportedLocales.length, (i) {
                  String languageCode =
                      AppLocalizations.supportedLocales[i].languageCode;
                  String languageName =
                      globals.appLanguageDict[languageCode] ?? '';
                  bool lastItem =
                      (i + 1 == AppLocalizations.supportedLocales.length);
                  return Column(
                    children: [
                      ListTile(
                        // leading: Icon(
                        //   Icons.translate,
                        //   color: textColor,
                        // ),
                        title: Text(
                          languageName,
                          style: TextStyle(color: textColor),
                        ),
                        trailing: appLangCode == languageCode
                            ? Icon(
                                Icons.check,
                                color: textColor,
                              )
                            : null,
                        onTap: () {
                          Provider.of<LanguageModel>(context, listen: false)
                              .updateAppLangCode(languageCode);
                        },
                      ),
                      lastItem
                          ? Container()
                          : Divider(
                              height: 1,
                              color: textColor,
                              indent: 0,
                            ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
