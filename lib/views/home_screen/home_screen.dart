import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../views/all_widgets/bottom_bar_clipper.dart';
import '../../views/love_screen/love_screen.dart';
import '../../views/setting_screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final double bottomSize = 60;
  late PageController controllerMonth;
  late DateTime today;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controllerMonth.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    controllerMonth = PageController(initialPage: 9999, keepPage: true);

    Stream timer = Stream.periodic(Duration(minutes: 5), (i) {
      return DateTime.now();
    });

    timer.listen((data) {
      if (mounted) {}
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {}
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: globals.appThemeDict[appTheme]['colors'],
          ),
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: bottomSize),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: globals.appThemeDict[appTheme]['colors'],
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
                  backgroundColor: globals.appThemeDict[appTheme]['colors'][0],
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.home,
                          color: textColor,
                        ),
                      ),
                    ],
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
                    color: globals.appThemeDict[appTheme]['colors'][0],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoveScreen();
                              }),
                            );
                          },
                          child: Icon(
                            Icons.favorite,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingScreen(),
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
    );
  }
}
