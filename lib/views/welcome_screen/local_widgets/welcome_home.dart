import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../all_widgets/card_view.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../views/all_widgets/bottom_bar_clipper.dart';

class WelcomeHome extends StatefulWidget {
  @override
  _WelcomeHomeState createState() => _WelcomeHomeState();
}

class _WelcomeHomeState extends State<WelcomeHome>
    with SingleTickerProviderStateMixin {
  final Color bezelColor = Colors.grey;
  final double bezelSize = 15;
  final double bezelRadius = 40;
  final double bottomSize = 60;

  bool _learning = true;

  late AnimationController controller;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    var guideColor = Colors.white70;
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
              AppLocalizations.of(context)!.welcome_2,
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
                height: 200,
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
                AppLocalizations.of(context)!.welcome_2_1,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
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
                AppLocalizations.of(context)!.welcome_2_2,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(bezelRadius),
              ),
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: bezelSize, color: bezelColor),
                    right: BorderSide(width: bezelSize, color: bezelColor),
                    top: BorderSide(width: bezelSize, color: bezelColor),
                  ),
                  color: bezelColor,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(bezelRadius - bezelSize),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                        colors: globals.appThemeDict[appTheme]['colors'],
                      ),
                    ),
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.add_new_code,
                          style: TextStyle(color: textColor),
                        ),
                        backgroundColor: globals.appThemeDict[appTheme]
                            ['colors'][0],
                        iconTheme: IconThemeData(color: textColor),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {},
                          ),
                        ],
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
                        child: Center(
                          child: ListView(
                            children: [
                              CardView(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Column(
                                  children: [
                                    TextField(
                                      cursorColor: textColor,
                                      style: TextStyle(color: textColor),
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: textColor.withOpacity(0.6),
                                        ),
                                        hintText:
                                            AppLocalizations.of(context)!.name,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Colors.grey,
                                    ),
                                    TextField(
                                      maxLines: 3,
                                      cursorColor: textColor,
                                      style: TextStyle(color: textColor),
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: textColor.withOpacity(0.6),
                                        ),
                                        hintText: AppLocalizations.of(context)!
                                            .code_content,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                    Flex(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      direction: Axis.vertical,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                    .choose_from_photo_lib),
                                            icon: Icon(Icons.photo_album),
                                            onPressed: () {},
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                    .scan_from_camera),
                                            icon: Icon(Icons.qr_code_scanner),
                                            onPressed: () {},
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            label: Text(
                                                AppLocalizations.of(context)!
                                                    .paste_from_clipboard),
                                            icon: Icon(Icons.paste),
                                            onPressed: () {},
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
