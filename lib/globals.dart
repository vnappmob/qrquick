library qrquick.globals;

import 'package:flutter/material.dart';

const bool PRODUCTION = bool.fromEnvironment('dart.vm.product');

const String appIdentifier = 'com.vnappmob.qrquick';
const String appStoreIdentifier = '1589085179';
const String googlePlayUrl =
    'https://play.google.com/store/apps/details?id=$appIdentifier';
const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreIdentifier';
const String appShareSubject = 'Please check out this cool app! ';
const String appSupportUrl = 'https://app.vnappmob.com/contact';
const String appLegalese =
    'Copyright (c) 2021 VNAppMob\nhttps://app.vnappmob.com\nhi@vnappmob.com';

final Map<String, String> appLanguageDict = const <String, String>{
  'en': 'English',
  'vi': 'Tiếng Việt',
};

const Map<String, dynamic> productDict = {
  '$appIdentifier.love2': {
    'id': '$appIdentifier.love2',
    'title': 'x 02',
    'description': 'Sponsor 2❤️  to this app'
  },
  '$appIdentifier.love10': {
    'id': '$appIdentifier.love10',
    'title': 'x 10',
    'description': 'Sponsor 10❤️ to this app'
  },
  '$appIdentifier.love50': {
    'id': '$appIdentifier.love50',
    'title': 'x 50',
    'description': 'Sponsor 50❤️ to this app'
  }
};
final List<Map<String, dynamic>> appList = [
  {
    'title': 'vLunar',
    'description': {
      'en': 'Vietnamese lunar calendar',
      'vi': 'Âm lịch Việt Nam'
    },
    'icon': 'assets/iha/vlunar.png',
    'onelink': 'http://onelink.to/xmwnpy',
  },
  {
    'title': 'PipPip',
    'description': {
      'en': 'Get notify on every new hour',
      'vi': 'Chuông báo mỗi tiếng'
    },
    'icon': 'assets/iha/pippip.png',
    'onelink': 'http://onelink.to/undta5',
  },
  {
    'title': 'MoPip',
    'description': {
      'en': 'Diary book with privacy first',
      'vi': 'Nhật ký cá nhân'
    },
    'icon': 'assets/iha/mopip.png',
    'onelink': 'http://onelink.to/22yxb5',
  },
  {
    'title': 'vPrice',
    'description': {
      'en': 'Gold & Exchange rate in Vietnam market',
      'vi': 'Giá vàng & Tỷ giá'
    },
    'icon': 'assets/iha/vprice.png',
    'onelink': 'http://onelink.to/4surga',
  }
];

final Map<String, dynamic> appThemeDict = const <String, dynamic>{
  'plum_plate': {
    'name': 'Plum Plate',
    'colors': [
      Color(0xFF667EEA),
      Color(0xFF764BA2),
    ]
  },
  'royal_blue': {
    'name': 'Royal Blue',
    'colors': [
      Color(0xFF536976),
      Color(0xFF292E49),
    ]
  },
  'everlasting_sky': {
    'name': 'Everlasting Sky',
    'colors': [
      Color(0xFFFDFCFB),
      Color(0xFFE2D1C3),
    ],
    'text': Color(0xFF222222),
  },
};
