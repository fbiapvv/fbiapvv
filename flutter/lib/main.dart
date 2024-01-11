import 'package:flutter/material.dart';
import 'package:ibeacon/screens/registracia.dart';
import 'package:ibeacon/screens/kalibracia.dart';
import 'package:ibeacon/screens/zoznam_kalibracii.dart';
import 'package:ibeacon/screens/home.dart';

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/registracia': (context) => Registracia(),
        '/kalibracia': (context) => Kalibracia(),
        '/zoznam_kalibracii': (context) => ZoznamKalibracii(),
      },
    ));
  });
}
