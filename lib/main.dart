import 'dart:async';

import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/material.dart';
// import 'package:install_referrer/install_referrer.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _referrerDetails = '';
  StreamSubscription? _sub;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }


  @override
  void initState(){
    // initReferrerDetails();
    super.initState();
    _initUniLinks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     //
      //     // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
      //     // action in the IDE, or press "p" in the console), to see the
      //     // wireframe for each widget.
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'Referer Data:',
      //       ),
      //       Text(
      //         _referrerDetails,
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //     ],
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            Text(_referrerDetails,style: TextStyle(fontSize: 20,
                fontStyle: FontStyle.normal,fontWeight: FontWeight.bold)),
            /*FutureBuilder(
              future: InstallReferrer.app,
              builder: (BuildContext context,
                  AsyncSnapshot<InstallationApp> result) {
                if (!result.hasData) {
                  return const CircularProgressIndicator.adaptive();
                } else if (result.hasError) {
                  return const Text('Unable to detect your referrer');
                } else {
                  return Text(
                    'Package name:\n${result.data!.packageName ?? 'Unknown'}\n'
                        'Referrer:\n${referrerToReadableString(result.data!.referrer)}',
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            InstallReferrerDetectorBuilder(
              builder: (BuildContext context, InstallationApp? app) {
                if (app == null) {
                  return const CircularProgressIndicator.adaptive();
                } else {
                  return Text(
                    'Package name:\n${app.packageName ?? 'Unknown'}\n'
                        'Referrer:\n${referrerToReadableString(app.referrer)}',
                    textAlign: TextAlign.center,
                  );
                }
              },
            ),
            InstallReferrerDetectorListener(
              child: const Text('Listener'),
              onReferrerAvailable: (InstallationApp? app) {
                // ignore: avoid_print
                print(app?.referrer);
              },
            ),*/
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (),
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // String referrerToReadableString(InstallationAppReferrer referrer) {
  //   switch (referrer) {
  //     case InstallationAppReferrer.iosAppStore:
  //       return "Apple - App Store";
  //     case InstallationAppReferrer.iosTestFlight:
  //       return "Apple - Test Flight";
  //     case InstallationAppReferrer.iosDebug:
  //       return "Apple - Debug";
  //     case InstallationAppReferrer.androidGooglePlay:
  //       return "Android - Google Play";
  //     case InstallationAppReferrer.androidAmazonAppStore:
  //       return "Android - Amazon App Store";
  //     case InstallationAppReferrer.androidHuaweiAppGallery:
  //       return "Android - Huawei App Gallery";
  //     case InstallationAppReferrer.androidOppoAppMarket:
  //       return "Android - Oppo App Market";
  //     case InstallationAppReferrer.androidSamsungAppShop:
  //       return "Android - Samsung App Shop";
  //     case InstallationAppReferrer.androidVivoAppStore:
  //       return "Android - Vivo App Store";
  //     case InstallationAppReferrer.androidXiaomiAppStore:
  //       return "Android - Xiaomi App Store";
  //     case InstallationAppReferrer.androidManually:
  //       return "Android - Manual installation";
  //     case InstallationAppReferrer.androidDebug:
  //       return "Android - Debug";
  //   }
  // }
  //
  // Future<void> initReferrerDetails() async {
  //   String referrerDetailsString;
  //   try {
  //     ReferrerDetails referrerDetails = await AndroidPlayInstallReferrer.installReferrer;
  //
  //     referrerDetailsString = referrerDetails.installReferrer?? "";
  //     print("Referer : $referrerDetailsString");
  //   } catch (e) {
  //     referrerDetailsString = 'Failed to get referrer details: $e';
  //     print("Referer : $referrerDetailsString");
  //   }
  //
  //   setState(() {
  //     _referrerDetails = referrerDetailsString;
  //   });
  // }

  Future<void> _initUniLinks() async {
    try {
      // For app launch from terminated state
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleIncomingLink(initialUri);
      }
      // For app in background
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          _handleIncomingLink(uri);
        }
      });
    } catch (e) {
      print('Error parsing link: $e');
    }
  }
  void _handleIncomingLink(Uri uri) {
    final id = uri.queryParameters['id'];
    final ref = uri.queryParameters['ref'];
    print('ID: $id | Ref: $ref');
    setState(() {
      _referrerDetails = '\n ID: $id';
    });

  }



}
