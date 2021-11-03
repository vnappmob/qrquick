import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../globals.dart' as globals;
import '../../models/app_model.dart';
import '../../models/scan_model.dart';
import '../../views/all_widgets/card_view.dart';
import 'scan_screen.dart';

final platformChannel =
    const MethodChannel('com.vnappmob.qrquick/UserDefaultsChannel');
var uuid = Uuid();

class CodeScreen extends StatefulWidget {
  CodeScreen({this.code});
  final dynamic code;

  @override
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  late dynamic code;
  late TextEditingController _nameController;
  late TextEditingController _contentController;
  String codeName = '';
  String codeContent = '';

  @override
  void initState() {
    super.initState();
    if (widget.code == null) {
      code = {
        'name': '',
        'content': '',
        'uuid': '',
        'timestamp': '',
        'home_widget': false
      };
    } else {
      code = widget.code;
      codeName = widget.code['name'] ?? '';
      codeContent = widget.code['content'] ?? '';
    }
    _nameController = TextEditingController();
    _contentController = TextEditingController();

    _nameController.text = codeName;
    _contentController.text = codeContent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void addNewCode() {
    var _uuid = uuid.v1();
    code['uuid'] = _uuid;
    code['timestamp'] = '${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    if (codeName.length == 0) {
      code['name'] = code['uuid'].substring(0, code['uuid'].indexOf('-'));
    } else {
      code['name'] = codeName;
    }
    code['content'] = codeContent;
    Provider.of<AppModel>(context, listen: false)
        .addCodeList(code)
        .then((value) {
      Navigator.pop(context);
    });
  }

  void updateCode() {
    if (codeName.length == 0) {
      code['name'] = code['uuid'].substring(0, code['uuid'].indexOf('-'));
    } else {
      code['name'] = codeName;
    }
    code['content'] = codeContent;
    Provider.of<AppModel>(context, listen: false)
        .updateCodeList(code)
        .then((value) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.code == null
                ? AppLocalizations.of(context)!.add_new_code
                : widget.code['name'],
            style: TextStyle(color: textColor),
          ),
          backgroundColor: globals.appThemeDict[appTheme]['colors'][0],
          iconTheme: IconThemeData(color: textColor),
          actions: [
            if (widget.code == null) ...[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => addNewCode(),
              ),
            ] else ...[
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: TextStyle(
                    color: textColor,
                  ),
                ),
                onPressed: () => updateCode(),
              ),
            ]
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
                        controller: _nameController,
                        cursorColor: textColor,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.6),
                          ),
                          hintText: AppLocalizations.of(context)!.name,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            codeName = value;
                          });
                        },
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
                          hintText: AppLocalizations.of(context)!.code_content,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            codeContent = value;
                          });
                        },
                      ),
                      Flex(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: widget.code == null
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.end,
                        direction: widget.code == null
                            ? Axis.vertical
                            : Axis.horizontal,
                        children: [
                          if (widget.code == null) ...[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                label: Text(AppLocalizations.of(context)!
                                    .choose_from_photo_lib),
                                icon: Icon(Icons.photo_album),
                                onPressed: pickPhoto,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                label: Text(AppLocalizations.of(context)!
                                    .scan_from_camera),
                                icon: Icon(Icons.qr_code_scanner),
                                onPressed: scanCamera,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                label: Text(AppLocalizations.of(context)!
                                    .paste_from_clipboard),
                                icon: Icon(Icons.paste),
                                onPressed: pasteClipboard,
                              ),
                            ),
                          ] else ...[
                            IconButton(
                              onPressed: pickPhoto,
                              icon: Icon(
                                Icons.photo_album,
                                color: textColor,
                              ),
                            ),
                            IconButton(
                              onPressed: scanCamera,
                              icon: Icon(
                                Icons.qr_code_scanner,
                                color: textColor,
                              ),
                            ),
                            IconButton(
                              onPressed: pasteClipboard,
                              icon: Icon(
                                Icons.paste,
                                color: textColor,
                              ),
                            ),
                          ]
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
                        child: QrImage(
                          data: codeContent,
                          version: QrVersions.auto,
                          size: MediaQuery.of(context).size.width * 0.9,
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
    );
  }

  void pasteClipboard() async {
    ClipboardData? clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    _contentController.text = clipboard?.text ?? '';

    setState(() {
      codeContent = _contentController.text;
    });
  }

  void pickPhoto() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      return;
    }

    final fileContent = await platformChannel.invokeMethod('imageScan', {
      'file_path': pickedFile.path,
    });

    _contentController.text = fileContent ?? 'Not good code';
    setState(() {
      codeContent = _contentController.text;
    });
  }

  void scanCamera() async {
    await Provider.of<ScanModel>(context, listen: false).updateScanContent("");
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ScanScreen();
      },
    ).then((value) {
      _contentController.text = context.read<ScanModel>().scanContent;
      setState(() {
        codeContent = _contentController.text;
      });
    });
  }
}
