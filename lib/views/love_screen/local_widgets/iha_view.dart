import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../models/language_model.dart';
import '../../../views/all_widgets/card_view.dart';

class InHouseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    var appLangCode = context.select((LanguageModel _) => _.appLangCode);
    return CardView(
      headTitle: Text(
        'VNAppMob Apps',
        style: TextStyle(
          color: textColor,
        ),
      ),
      child: Column(
        children: List.generate(globals.appList.length, (index) {
          Map<String, dynamic> app = globals.appList[index];
          return Card(
            elevation: 4,
            color: globals.appThemeDict[appTheme]['colors'][0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(app['icon']),
                ),
              ),
              title: Text(
                app['title'] ?? '',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              subtitle: Text(
                app['description'][appLangCode] ?? '',
                style: TextStyle(
                  color: textColor,
                ),
              ),
              onTap: () async {
                if (await canLaunch(app['onelink'] ?? '')) {
                  await launch(app['onelink'] ?? '');
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
