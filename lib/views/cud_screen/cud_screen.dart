import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrquick/views/cud_screen/scan_screen.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../models/scan_model.dart';
import '../../views/all_widgets/card_view.dart';

var uuid = Uuid();

class CUDScreen extends StatefulWidget {
  @override
  _CUDScreenState createState() => _CUDScreenState();
}

class _CUDScreenState extends State<CUDScreen> {
  late TextEditingController _nameController;
  late TextEditingController _contentController;
  var contentFocusNode = FocusNode();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contentController = TextEditingController();
    contentFocusNode.addListener(() {
      if (!contentFocusNode.hasFocus) {
        Provider.of<ScanModel>(context, listen: false)
            .updateContent(_contentController.text);
      }
    });
  }

  void addNewCode(uuid, name, content) {
    var code = {
      'uuid': uuid,
      'name': name,
      'content': content,
      'timestamp': '${DateTime.now().millisecondsSinceEpoch ~/ 1000}'
    };
    Provider.of<AppModel>(context, listen: false).addCode(code).then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    var content = context.select((ScanModel _) => _.content);
    _contentController.text = content;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.add,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: globals.appThemeDict[appTheme]['colors'][0],
          iconTheme: IconThemeData(color: textColor),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                var _uuid = uuid.v1();
                var _name = _nameController.text;
                if (_name.length == 0) {
                  _name = _uuid.substring(0, _uuid.indexOf('-'));
                }
                addNewCode(_uuid, _name, content);
              },
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
                  // headTitle: Text('QR Code content'),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        cursorColor: textColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.6),
                          ),
                          hintText: 'Name',
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
                        controller: _contentController,
                        cursorColor: textColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.6),
                          ),
                          hintText: 'Code content',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        focusNode: contentFocusNode,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              label: Text('Choose from photo library'),
                              icon: Icon(Icons.photo_album),
                              onPressed: () async {
                                final pickedFile =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile == null) {
                                  return;
                                }
                                final content = await FlutterQrReader.imgScan(
                                  pickedFile.path,
                                );
                                Provider.of<ScanModel>(context, listen: false)
                                    .updateContent(content);
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              label: Text('Scan from camera'),
                              icon: Icon(Icons.qr_code_scanner),
                              onPressed: () async {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ScanScreen();
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              label: Text('Paste from clipboard'),
                              icon: Icon(Icons.paste),
                              onPressed: () async {
                                ClipboardData? data = await Clipboard.getData(
                                    Clipboard.kTextPlain);
                                Provider.of<ScanModel>(context, listen: false)
                                    .updateContent(data?.text ?? '');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CardView(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Consumer<ScanModel>(builder: (_, data, __) {
                          return QrImage(
                            data: data.content,
                            version: QrVersions.auto,
                            size: MediaQuery.of(context).size.width * 0.9,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
