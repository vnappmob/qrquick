import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _userDefaultsChannel =
    const MethodChannel('com.vnappmob.qrquick/UserDefaultsChannel');

class AppModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  Future<void> updateLoading(bool value) async {
    _loading = value;
    notifyListeners();
  }

  String _appTheme = 'plum_plate';
  String get appTheme => _appTheme;
  Future<void> updateAppTheme(String value) async {
    _appTheme = value;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('appTheme', _appTheme);
    notifyListeners();

    if (Platform.isIOS) {
      _userDefaultsChannel.invokeMethod('updateAppTheme');
    }
  }

  bool _appTutorial = true;
  bool get appTutorial => _appTutorial;
  Future<void> updateAppTutorial(bool value) async {
    _appTutorial = value;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool('appTutorial', value);

    notifyListeners();
  }

  Future<void> fetchSaved() async {
    var prefs = await SharedPreferences.getInstance();

    _appTutorial = prefs.getBool('appTutorial') ?? _appTutorial;
    print('---appTutorial: $_appTutorial');

    _appTheme = prefs.getString('appTheme') ?? _appTheme;
    print('---appTheme: $_appTheme');
  }
}