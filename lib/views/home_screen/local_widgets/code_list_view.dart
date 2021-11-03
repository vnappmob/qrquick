import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../../views/all_widgets/account_logo.dart';
import '../../../views/code_screen/code_screen.dart';

final platformChannel =
    const MethodChannel('com.vnappmob.qrquick/UserDefaultsChannel');

class CodeListView extends StatefulWidget {
  CodeListView({
    required this.codeList,
  });
  final List<dynamic> codeList;

  @override
  _CodeListViewState createState() => _CodeListViewState();
}

class _CodeListViewState extends State<CodeListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    return Container(
      padding: EdgeInsets.all(12.0),
      child: ListView(
        children: List.generate(widget.codeList.length, (index) {
          var code = widget.codeList[index];
          return Dismissible(
            key: ValueKey<String>(code['uuid']),
            direction: DismissDirection.endToStart,
            background: Container(color: Colors.white),
            secondaryBackground: Container(
              padding: EdgeInsets.only(right: 20),
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.delete, color: Colors.white),
                ],
              ),
            ),
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.remove_confirm),
                    content: Text(
                      AppLocalizations.of(context)!.remove_confirm_long,
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(AppLocalizations.of(context)!.delete)),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                    ],
                  );
                },
              );
            },
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                print("going to remove ${code['uuid']}");
                Provider.of<AppModel>(context, listen: false)
                    .updateCodeList(code, remove: true);
              }
            },
            child: Card(
              margin: EdgeInsets.only(bottom: 12),
              elevation: 8,
              color: globals.appThemeDict[appTheme]['colors'][0],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: AccountLogo(
                  textColor: textColor,
                  character: code['name'].toString()[0],
                ),
                trailing: IconButton(
                  onPressed: () async {
                    Provider.of<AppModel>(context, listen: false)
                        .updateCodeList(code, homeWidget: true);
                  },
                  icon: Icon(
                    Icons.widgets,
                    color: (code['home_widget'] ?? false)
                        ? textColor
                        : Colors.grey,
                  ),
                ),
                title: Text(
                  '${code['name']}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  DateFormat('yyyy-MM-dd hh:mm aaa').format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(code['timestamp']) * 1000,
                    ),
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return CodeScreen(
                        code: code,
                      );
                    }),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
