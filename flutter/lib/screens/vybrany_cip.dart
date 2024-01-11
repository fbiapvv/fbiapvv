import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:ibeacon/ibeacon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class BeaconDetailPage extends StatefulWidget {
  final Beacon beacon;

  const BeaconDetailPage({super.key, required this.beacon});

  @override
  State<BeaconDetailPage> createState() => _BeaconDetailPageState();
}

class _BeaconDetailPageState extends State<BeaconDetailPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    kontrola();
  }

  void _saveCipToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var connectivityResult = await (Connectivity().checkConnectivity());
      // Create Cip object
      var cip = Cip(
        widget.beacon.proximityUUID,
        widget.beacon.major,
        widget.beacon.minor,
        widget.beacon.rssi,
        widget.beacon.accuracy,
        widget.beacon.proximity,
        widget.beacon.txPower,
        widget.beacon.macAddress,
        _controller.text.trim(),
      );

      // Convert Cip object to JSON
      String cipJson = jsonEncode(cip.toJson());

      // Save Cip object to local storage with macAddress as key
      prefs.setString(widget.beacon.macAddress!, cipJson);

      //ak sa csrfToken rovná null tak sa urobí print kde sa pise ze csrfToken je null
      String? urlAdresa = prefs.getString('urlAddress');
      String? csrfToken = prefs.getString('csrfToken');
      if (csrfToken != null) {
        if (connectivityResult != ConnectivityResult.none) {
          http.Response request;
          try {
            request = await http.post(
              Uri.parse('$urlAdresa/api/create_chip_flutter/'),
              headers: {
                'Content-Type': 'application/json',
                'charset': 'UTF-8',
                'Cookie': csrfToken
              },
              body: jsonEncode(cip.toJson()),
            );
            print(request.statusCode);
            if (request.statusCode != 200) {
              throw Exception(
                  'Server vrátil chybový status kód: ${request.statusCode}');
            }
          } catch (error) {
            print('Došlo k chybe: $error');
            request = http.Response('', 400);
          }

          if (request.statusCode > 204) {
            Set<String> keys = prefs.getKeys();
            if (keys.contains('neulozeneCipy')) {
              List<String>? neulozeneCipy = prefs.getStringList('neulozenCipy');
              neulozeneCipy!.add(cipJson);
              prefs.setStringList('neulozeneCipy', neulozeneCipy);
            } else {
              List<String> stringList = [];
              stringList.add(cipJson);
              prefs.setStringList('neulozeneCipy', stringList);
            }
          } else {
            Navigator.of(context).pop();
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
                              'Uložené',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Text(
                              'Cip sa uložil na server.',
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
          Navigator.of(context).pop();
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
                            'Cip bol ulozený v mobile, v uvodnej obrazovke stlačte tlačidlo refresh pre opätovné poslanie.',
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
    } catch (error) {
      print('Error v _saveCipToLocal metode: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Detaily cipu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nazov cipu:",
                border: OutlineInputBorder(),
              ),
            ),
            Text(
              'MAC Address: ${widget.beacon.macAddress}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'RSSI: ${widget.beacon.rssi}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'proximityUUID: ${widget.beacon.proximityUUID}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'major: ${widget.beacon.major}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'minor: ${widget.beacon.minor}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'accuracy: ${widget.beacon.accuracy}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'proximity: ${widget.beacon.proximity}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'txPower: ${widget.beacon.txPower}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('OK'),
        backgroundColor: Colors.green,
        onPressed: () {
          _saveCipToLocal();
          // Send the basic data of the record
        },
      ),
    );
  }

  //tato funkcia sluzi na to ze ked uz cip ma pomenovanie tak nech sa text objaví v textfield
  Future<void> kontrola() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(widget.beacon.macAddress!)) {
        String? jsonString = prefs.getString(widget.beacon.macAddress!);
        var cipJson = jsonDecode(jsonString!);
        Cip cip = Cip.fromJson(cipJson);
        setState(() {
          _controller.text = cip.pomenovanie_;
        });
      }
    } catch (error) {
      print('Error v kontrola metode: $error');
    }
  }
}
