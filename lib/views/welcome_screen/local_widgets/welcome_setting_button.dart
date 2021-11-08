import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../views/all_widgets/bottom_bar_clipper.dart';
import '../../../views/all_widgets/rive_item.dart';
import '../../../views/setting_screen/setting_screen.dart';

class WelcomeSettingButton extends StatefulWidget {
  @override
  _WelcomeSettingButtonState createState() => _WelcomeSettingButtonState();
}

class _WelcomeSettingButtonState extends State<WelcomeSettingButton> {
  final Color bezelColor = Colors.grey;
  final double bezelSize = 15;
  final double bezelRadius = 40;
  final double bottomSize = 60;
  final DateTime now = DateTime.now();
  late DateTime today;

  bool _learning = true;

  @override
  Widget build(BuildContext context) {
    today = DateTime(now.year, now.month, now.day, 0, 0, 0);
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
              AppLocalizations.of(context)!.welcome_4,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(bezelRadius),
              ),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: bezelSize, color: bezelColor),
                    right: BorderSide(width: bezelSize, color: bezelColor),
                    bottom: BorderSide(width: bezelSize, color: bezelColor),
                  ),
                  color: bezelColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: RiveItem(
                              mediaUrl: 'assets/rive/painting.riv',
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: bottomSize * 0.53,
                          right: 0,
                          left: 0,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: globals.appThemeDict[appTheme]
                                  ['colors'][0],
                              child: Icon(
                                Icons.add,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipPath(
                            clipper: BottomBarClipper(centerSize: bottomSize),
                            child: Container(
                              height: bottomSize,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomLeft,
                                  colors: globals.appThemeDict[appTheme]
                                      ['colors'],
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: CupertinoButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SettingScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.setting,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                AppLocalizations.of(context)!.welcome_4_1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
