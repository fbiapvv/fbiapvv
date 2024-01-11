import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? neulozeneCipy = [];

  @override
  initState() {
    super.initState();
    _requestLocationPermission(context);
    _neulozeneCipy();
    nastavUrlAdresu();
    nastavCSRFToken();
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      print('Location access permission granted');
    } else {
      print('Location access permission denied');
    }
  }

  Future<void> _neulozeneCipy() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    if (keys.contains('neulozeneCipy')) {
      neulozeneCipy = prefs.getStringList('neulozeneCipy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            nastavCSRFToken();
            _showSettingsDialog(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              height: 100,
              child: ElevatedButton(
                child: const Text(
                  'Registrácia čipov',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  _requestLocationPermission(context);
                  Navigator.pushNamed(context, '/registracia')
                      .then((value) => null);
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              height: 100,
              child: ElevatedButton(
                child: const Text(
                  'Kalibrácia čipov',
                  style: TextStyle(fontSize: 25),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/kalibracia');
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              width: 300,
              height: 100,
              child: ElevatedButton(
                child: const Text(
                  'Zoznam vykonaných kalibrácií',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/zoznam_kalibracii');
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: neulozeneCipy!.isEmpty
          ? FloatingActionButton(
              onPressed: () {
                print('Ziadne neulozene cipy');
              },
              child: const Icon(Icons.refresh),
            )
          : FloatingActionButton(
              onPressed: () {
                _ulozNaServer();
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.refresh),
            ),
    );
  }

  Future<void> _ulozNaServer() async {
    final prefs = await SharedPreferences.getInstance();
    var connectivityResult = await (Connectivity().checkConnectivity());
    String? urlAdresa = prefs.getString('urlAddress');
    String? tempCsrfToken = prefs.getString('csrfToken');
    if (tempCsrfToken != null) {
      if (connectivityResult != ConnectivityResult.none) {
        for (int i = 0; i < neulozeneCipy!.length; i++) {
          http.Response request;

          try {
            request = await http.post(
              Uri.parse('$urlAdresa/api/create_chip_flutter/'),
              headers: {
                'Content-Type': 'application/json',
                'charset': 'UTF-8',
                'Cookie': tempCsrfToken
              },
              body: neulozeneCipy![i],
            );
            print(request.statusCode);
            if (request.statusCode > 204) {
              throw Exception(
                  'Server vrátil chybový status kód: ${request.statusCode}');
            }
          } catch (error) {
            print('Došlo k chybe: $error');
            request = http.Response('', 400);
          }

          if (request.statusCode <= 204) {
            setState(() {
              neulozeneCipy!.removeAt(i);
            });
            List<String>? neulozene = prefs.getStringList('neulozeneCipy');
            neulozene = neulozeneCipy;
            prefs.setStringList('neulozeneCipy', neulozene!);
          }
        }
        if (neulozeneCipy!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_box,
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Uložené.',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            'Čipy sa uložili na server!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Container(
              padding: const EdgeInsets.all(16),
              height: 150,
              decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: const Row(
                children: [
                  Icon(
                    Icons.report_problem,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cip sa nenahral na server.',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          'Overte či máte pripojenie na internet.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ));
      }
    } else {
      print('csrfToken je null');
    }
  }

  Future<void> _showSettingsDialog(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String urlAddress =
        prefs.getString('urlAddress') ?? 'http://192.168.31.200:8080';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nastavenia'),
          content: SingleChildScrollView(
            // Pridanie tohto widgetu
            child: Column(
              children: <Widget>[
                Text('Aktuálna URL adresa je $urlAddress'),
                TextField(
                  onChanged: (value) {
                    urlAddress = value;
                  },
                  decoration:
                      InputDecoration(hintText: "Zadajte novú URL adresu"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  child: Text('Default'),
                  onPressed: () {
                    urlAddress = 'http://192.168.31.200:8080';
                    prefs.setString('urlAddress', urlAddress);
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Uložiť'),
                  onPressed: () {
                    prefs.setString('urlAddress', urlAddress);
                    nastavCSRFToken();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> nastavUrlAdresu() async {
    final prefs = await SharedPreferences.getInstance();
    String urlAddress =
        prefs.getString('urlAddress') ?? 'http://192.168.31.200:8080';
    prefs.setString('urlAddress', urlAddress);
  }

  Future<void> nastavCSRFToken() async {
    final prefs = await SharedPreferences.getInstance();
    String csrfToken = prefs.getString('csrfToken') ?? '';
    String? urlAdresa = prefs.getString('urlAddress');

    if (csrfToken.isEmpty) {
      http.Response
          response; // Deklarujeme response tu, aby bolo prístupné v celom bloku

      try {
        response = await http.get(
          Uri.parse('$urlAdresa/api/get_csrf_token/'),
        );

        if (response.statusCode != 200) {
          throw Exception(
              'Server vrátil chybový status kód: ${response.statusCode}');
        }
      } catch (error) {
        print('Došlo k chybe: $error');

        // Ak došlo k chybe, vytvorte falošnú odpoveď s prázdnum telom
        response =
            http.Response('', 400); // 400 je status kód pre "Bad Request"
      }

      if (response.body.isNotEmpty) {
        try {
          var data = jsonDecode(response.body);
          csrfToken = data['csrf_token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('csrfToken', csrfToken);
        } catch (err) {
          print('Chyba pri získavaní csrfTokenu: $err');
        }
      }
    }
  }
}
