import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:provider/provider.dart';
import 'package:qrquick/models/scan_model.dart';
import 'package:qrquick/views/cud_screen/cud_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../views/all_widgets/bottom_bar_clipper.dart';
import '../../views/love_screen/love_screen.dart';
import '../../views/setting_screen/setting_screen.dart';
import 'local_widgets/code_list_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final double bottomSize = 60;
  late StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    initReceiveSharing();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {}
  }

  void initReceiveSharing() {
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> files) {
      if (files.isNotEmpty) {
        receiveContent(sharedMedias: files);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> files) {
      if (files.isNotEmpty) {
        receiveContent(sharedMedias: files);
      }
    });

    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value.length > 0) {
        receiveContent(sharedText: value);
      }
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    ReceiveSharingIntent.getInitialText().then((String? value) {
      if ((value?.length ?? 0) > 0) {
        receiveContent(sharedText: value);
      }
    });
  }

  Future<void> receiveContent({sharedText, sharedMedias}) async {
    String content = "";
    if (sharedText != null) {
      content = sharedText;
    } else if (sharedMedias != null) {
      content = await FlutterQrReader.imgScan(
        sharedMedias[0].path,
      );
    }
    Provider.of<ScanModel>(context, listen: false).updateContent(content);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return CUDScreen();
      }),
    ).then((value) {
      Provider.of<ScanModel>(context, listen: false).updateContent("");
    });
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
                child: Consumer<AppModel>(
                  builder: (_, data, ___) {
                    List codeList = data.codeList;

                    if (codeList.length > 0) {
                      return CodeListView(codeList: codeList);
                    }
                    return Center(
                      child: Text(
                        'No code provided\nPress "+" to add',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                )),
            Positioned(
              bottom: bottomSize * 0.53,
              right: 0,
              left: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return CUDScreen();
                      }),
                    ).then((value) {
                      Provider.of<ScanModel>(context, listen: false)
                          .updateContent("");
                    });
                  },
                  backgroundColor: globals.appThemeDict[appTheme]['colors'][0],
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          Icons.add,
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
