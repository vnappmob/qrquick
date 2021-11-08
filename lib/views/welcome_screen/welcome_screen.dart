import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import 'local_widgets/welcome_first.dart';
import 'local_widgets/welcome_home.dart';
import 'local_widgets/welcome_setting_button.dart';
import 'local_widgets/welcome_widget.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController(initialPage: 0);
  final List<Widget> _screens = [
    WelcomeFirst(),
    WelcomeHome(),
    WelcomeWidget(),
    WelcomeSettingButton(),
  ];
  bool _lastPage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: _screens,
              onPageChanged: (page) {
                setState(() {
                  _lastPage = page == (_screens.length - 1);
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Stack(
              children: [
                Align(
                  alignment:
                      _lastPage ? Alignment.center : Alignment.centerRight,
                  child: _lastPage
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: CupertinoButton(
                            padding: EdgeInsets.all(15),
                            color: globals.appThemeDict[appTheme]['colors'][0],
                            onPressed: () {
                              if (_controller.page != _screens.length) {
                                _controller.nextPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.next,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                        ),
                ),
                AnimatedAlign(
                  alignment:
                      _lastPage ? Alignment.center : Alignment.centerLeft,
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: CupertinoButton(
                      padding: EdgeInsets.all(15),
                      color: globals.appThemeDict[appTheme]['colors'][0],
                      onPressed: () {
                        Provider.of<AppModel>(context, listen: false)
                            .updateAppTutorial(false);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.enter_app,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
