import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../globals.dart' as globals;
import '../../../models/app_model.dart';
import '../../love_screen/love_screen.dart';

class AboutView extends StatefulWidget {
  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late PackageInfo _packageInfo;

  @override
  void initState() {
    super.initState();
    loadPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadPackageInfo() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _packageInfo = packageInfo;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var appTheme = context.select((AppModel _) => _.appTheme);
    var textColor = globals.appThemeDict[appTheme]['text'] ?? Colors.white;
    return Column(
      children: [
        Container(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: globals.appLegalese,
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  const mailUrl = 'mailto:hi@vnappmob.com';
                  const webUrl = 'https://app.vnappmob.com';
                  if (await canLaunch(mailUrl)) {
                    await launch(mailUrl);
                  } else if (await canLaunch(webUrl)) {
                    await launch(webUrl);
                  }
                },
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Divider(
          height: 1,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.book,
            color: textColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.getting_started,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            Provider.of<AppModel>(context, listen: false)
                .updateAppTutorial(true);
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        Divider(
          height: 1,
          indent: 60,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.gavel,
            color: textColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.license,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: '${_packageInfo.appName}',
              applicationVersion:
                  '${_packageInfo.version}+${_packageInfo.buildNumber}',
              applicationLegalese: globals.appLegalese,
            );
          },
        ),
        Divider(
          height: 1,
          indent: 60,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.share,
            color: textColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.share_app,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            if (Platform.isIOS) {
              Share.share(
                globals.appStoreUrl,
                subject: globals.appShareSubject,
              );
            } else if (Platform.isAndroid) {
              Share.share(
                globals.googlePlayUrl,
                subject: globals.appShareSubject,
              );
            }
          },
        ),
        Divider(
          height: 1,
          indent: 60,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.feedback,
            color: textColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.feedback,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            LaunchReview.launch(
              androidAppId: globals.appIdentifier,
              iOSAppId: globals.appStoreIdentifier,
            );
          },
        ),
        Divider(
          height: 1,
          indent: 60,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.support,
            color: textColor,
          ),
          title: Text(
            AppLocalizations.of(context)!.faq_support,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () async {
            if (await canLaunch(globals.appSupportUrl)) {
              await launch(globals.appSupportUrl);
            }
          },
        ),
        Divider(
          height: 1,
          indent: 60,
          color: textColor,
        ),
        ListTile(
          leading: Icon(
            Icons.favorite,
            color: Colors.pink,
          ),
          title: Text(
            AppLocalizations.of(context)!.sponsor,
            style: TextStyle(color: textColor),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoveScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
