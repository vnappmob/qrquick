import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';

class ThemeView extends StatelessWidget {
  List<Widget> getThemeList(context, currentTheme) {
    List<Widget> _themes = [];
    globals.appThemeDict.forEach((key, value) {
      var textColor = value['text'] ?? Colors.white;
      _themes.add(
        GestureDetector(
          onTap: () async {
            Provider.of<AppModel>(context, listen: false).updateAppTheme(key);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: value['colors'],
              ),
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            width: 140.0,
            child: currentTheme == key
                ? Icon(
                    Icons.check_circle,
                    color: textColor,
                  )
                : Center(
                    child: Text(
                      value['name'],
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),
                  ),
          ),
        ),
      );
    });
    return _themes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: getThemeList(
          context,
          context.select((AppModel _) => _.appTheme),
        ),
      ),
    );
  }
}
