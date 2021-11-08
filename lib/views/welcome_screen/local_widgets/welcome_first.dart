import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/language_model.dart';
import '../../../views/all_widgets/rive_item.dart';

class WelcomeFirst extends StatefulWidget {
  @override
  _WelcomeFirstState createState() => _WelcomeFirstState();
}

class _WelcomeFirstState extends State<WelcomeFirst> {
  final Color bezelColor = Colors.grey;
  final double bezelSize = 15;
  final double bezelRadius = 40;
  final double bottomSize = 60;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget dropDownWidget(
    context,
    _items,
    _value, {
    required Function(dynamic) onChanged,
  }) {
    List<DropdownMenuItem> _dropdownItems = [];
    _items.forEach((k, v) {
      _dropdownItems.add(
        DropdownMenuItem(
          value: k,
          child: Text(
            v,
            style: TextStyle(color: Colors.blueGrey),
          ),
        ),
      );
    });

    return DropdownButton(
      value: _value,
      icon: Icon(
        Icons.expand_more,
        color: Colors.blueGrey,
      ),
      isExpanded: true,
      style: TextStyle(
        color: Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      underline: Container(
        height: 2,
        color: Colors.blueGrey,
      ),
      onChanged: onChanged,
      items: _dropdownItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
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
                AppLocalizations.of(context)!.getting_started,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            Divider(),
            Consumer<LanguageModel>(
              builder: (context, model, child) {
                return ListTile(
                  leading: Icon(
                    Icons.translate_sharp,
                    color: Colors.blueGrey,
                  ),
                  title: dropDownWidget(
                    context,
                    globals.appLanguageDict,
                    model.appLangCode,
                    onChanged: (newValue) {
                      model.updateAppLangCode(newValue).then((value) {});
                    },
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  AppLocalizations.of(context)!.welcome_1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            RiveItem(
              mediaUrl: 'assets/rive/note_book.riv',
            ),
          ],
        ),
      ),
    );
  }
}
