import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import 'local_widgets/iap_view.dart';
import 'local_widgets/iha_view.dart';

class LoveScreen extends StatefulWidget {
  @override
  _LoveScreenState createState() => _LoveScreenState();
}

class _LoveScreenState extends State<LoveScreen> {
  Widget iapView = Container();

  getIAPView() {
    if (Platform.isIOS) {
      setState(() {
        iapView = IAPView();
      });
    } else if (Platform.isAndroid) {
      setState(() {
        iapView = IAPView();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getIAPView();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.sponsor,
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
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.iap_intro,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ),
            iapView,
          ],
        ),
      ),
    );
  }
}
