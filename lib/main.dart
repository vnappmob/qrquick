import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:provider/provider.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'globals.dart' as globals;
import 'models/app_model.dart';
import 'models/language_model.dart';
import 'models/scan_model.dart';
import 'views/home_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootApp();
}

Future<void> bootApp() async {
  print('---fetchAppModel---');
  AppModel appModel = AppModel();
  await appModel.fetchSaved();

  print('---fetchLanguageModel---');
  LanguageModel languageModel = LanguageModel();
  await languageModel.fetchLocale();

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppModel>(create: (_) => appModel),
        ChangeNotifierProvider<LanguageModel>(create: (_) => languageModel),
        ChangeNotifierProvider<ScanModel>(create: (context) => ScanModel()),
      ],
      child: InitApp(),
    ),
  );
}

class InitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageModel>(builder: (_, data, child) {
      return MaterialApp(
        locale: data.appLocale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: 'QR Quick',
        theme: ThemeData(
          platform: TargetPlatform.iOS,
          primarySwatch: Colors.blueGrey,
        ),
        home: RateMyAppBuilder(
          builder: (context) {
            return MainPage();
          },
          rateMyApp: RateMyApp(
            preferencesPrefix: 'rateMyApp_',
            minDays: globals.PRODUCTION ? 1 : 0,
            minLaunches: globals.PRODUCTION ? 2 : 0,
            remindDays: globals.PRODUCTION ? 7 : 1,
            remindLaunches: globals.PRODUCTION ? 10 : 1,
            googlePlayIdentifier: globals.appIdentifier,
            appStoreIdentifier: globals.appStoreIdentifier,
          ),
          onInitialized: (context, rateMyApp) {
            if (rateMyApp.shouldOpenDialog) {
              rateMyApp.showRateDialog(context);
            }
          },
        ),
      );
    });
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool appTutorial = context.select((AppModel _) => _.appTutorial);
    return Scaffold(
      body: IndexedStack(
        index: appTutorial ? 0 : 1,
        children: [
          appTutorial ? Center(child: HomeScreen()) : Container(),
          appTutorial ? Container() : Center(child: HomeScreen()),
        ],
      ),
    );
  }
}
