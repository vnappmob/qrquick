import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageModel extends ChangeNotifier {
  String _appLangCode = 'en';
  String get appLangCode => _appLangCode;
  Locale get appLocale => Locale(_appLangCode);
  Future<void> updateAppLangCode(String value) async {
    _appLangCode = value;
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLangCode', _appLangCode);
    notifyListeners();
  }

  Future<void> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    _appLangCode = prefs.getString('appLangCode') ?? 'en';
    print('---appLangCode: $_appLangCode---');
  }
}
