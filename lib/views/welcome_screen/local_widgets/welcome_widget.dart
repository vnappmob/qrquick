import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';

class WelcomeWidget extends StatefulWidget {
  @override
  _WelcomeWidgetState createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  final Color bezelColor = Colors.grey;
  final double bezelSize = 15;
  final double bezelRadius = 40;
  final double bottomSize = 60;

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xffe0e8ef),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListView(
        children: [
          Center(
            child: Text(
              'Widget',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.welcome_3,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(bezelRadius),
                bottom: Radius.circular(bezelRadius),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: bezelSize, color: bezelColor),
                    left: BorderSide(width: bezelSize, color: bezelColor),
                    right: BorderSide(width: bezelSize, color: bezelColor),
                    bottom: BorderSide(width: bezelSize, color: bezelColor),
                  ),
                  color: bezelColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(bezelRadius - bezelSize),
                    bottom: Radius.circular(bezelRadius - bezelSize),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: globals.appThemeDict[appTheme]['colors'],
                      ),
                    ),
                    child: Image.asset(
                      Platform.isIOS
                          ? 'assets/image/widget_ios.gif'
                          : 'assets/image/widget_android.gif',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
