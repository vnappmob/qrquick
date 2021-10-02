import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../views/all_widgets/card_view.dart';

class CUDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add'),
      ),
      body: Container(
        child: Center(
          child: ListView(
            children: [
              CardView(
                headTitle: Text('QR Code content'),
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  children: [
                    TextFormField(
                      key: Key('name'),
                      cursorColor: textColor,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: textColor),
                        hintText: 'Name',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      onSaved: (String? value) {},
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    TextFormField(
                      key: Key('content'),
                      cursorColor: textColor,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: textColor),
                        hintText: 'QR Code content',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      onSaved: (String? value) {},
                    ),
                  ],
                ),
              ),
              CardView(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: FlutterLogo(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
