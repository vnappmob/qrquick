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

  List _codeList = [];
  List get codeList => _codeList;

  Future<void> addCodeList(value) async {
    _codeList.add(value);
    await updatePref('codeList', jsonEncode(_codeList));
    notifyListeners();
  }

  Future<void> updateCodeList(code, {remove = false}) async {
    bool updated = false;
    int foundIndex =
        codeList.indexWhere((_code) => _code['uuid'] == code['uuid']);
    if (foundIndex > -1) {
      if (remove) {
        codeList.removeAt(foundIndex);
      } else {
        codeList[foundIndex] = code;
      }
      updated = true;
    }
    if (updated) {
      await updatePref('codeList', jsonEncode(_codeList));
      notifyListeners();
    }
  }

  Future<void> truncateCodeList() async {
    _codeList = [];
    await updatePref('codeList', jsonEncode(_codeList));
    notifyListeners();
  }

  Future<void> updatePref(key, value) async {
    var _pref = await SharedPreferences.getInstance();
    await _pref.setString(key, value);
  }

  Future<void> fetchSaved() async {
    var prefs = await SharedPreferences.getInstance();

    _appTutorial = prefs.getBool('appTutorial') ?? _appTutorial;
    print('---appTutorial: $_appTutorial');

    _appTheme = prefs.getString('appTheme') ?? _appTheme;
    print('---appTheme: $_appTheme');

    String codeList = prefs.getString('codeList') ?? jsonEncode(_codeList);
    _codeList = jsonDecode(codeList);
    print('---codeList: $_codeList');
  }
}
