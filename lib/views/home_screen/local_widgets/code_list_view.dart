import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qrquick/models/app_model.dart';
import 'package:qrquick/globals.dart' as globals;
import 'package:qrquick/views/all_widgets/account_logo.dart';

class CodeListView extends StatefulWidget {
  CodeListView({
    Key? key,
    required this.codeList,
  }) : super(key: key);
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
                    title: const Text("Remove Confirmation"),
                    content: const Text(
                      "Are you sure you want to remove this account?",
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete")),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text("Cancel"),
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
                    .updateCode(code, remove: true);
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
                title: Text(
                  '${code['name']}',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                subtitle: Text(
                  '${code['timestamp']}',
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                onTap: () async {},
              ),
            ),
          );
        }),
      ),
    );
  }
}
