import 'dart:async';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ibeacon.dart';
import 'vybrany_cip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'dart:io';

class Registracia extends StatefulWidget {
  @override
  _RegistraciaState createState() => _RegistraciaState();
}

class _RegistraciaState extends State<Registracia> {
  final regions = <Region>[];
  List<RangingResult> beacons = [];
  List<Beacon> beaconListView = [];
  late StreamSubscription<RangingResult> _streamRanging;

  @override
  void initState() {
    super.initState();
    initBeaconScan();
  }

  @override
  void dispose() {
    _streamRanging.cancel();
    super.dispose();
  }

  Future<void> initBeaconScan() async {
    await Permission.bluetooth.request();
    await Permission.location.request();
    await Permission.bluetoothScan.request(); // <-- Add this line
    await Permission.bluetoothConnect.request();

    if (await Permission.bluetooth.isGranted &&
        await Permission.location.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) {
      // <-- Add this check
      await flutterBeacon.initializeScanning;

      if (Platform.isIOS) {
        regions.add(Region(
            identifier: 'Apple Airlocate',
            proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
      } else {
        regions.add(Region(identifier: 'Gigaset'));
      }
      _streamRanging =
          flutterBeacon.ranging(regions).listen((RangingResult result) {
        print(result.beacons);

        if (result.beacons.isNotEmpty) {
          setState(() {
            // Prejdite cez všetky beacons v result
            for (var currentBeacon in result.beacons) {
              // Nájdite existujúci výsledok pre daný macAddress

              final existingResultIndex = beaconListView.indexWhere((beacon) {
                if (beacon.macAddress == currentBeacon.macAddress) {
                  return true; // Vráti index prvého zhodného beaconu
                } else {
                  return false; // Vráti -1, ak sa žiadny zhodný beacon nenašiel
                }
              });

              if (existingResultIndex >= 0) {
                // Ak existuje, aktualizujte ho s novým výsledkom
                beaconListView.removeAt(existingResultIndex);
                beaconListView.add(Beacon(
                    proximityUUID: currentBeacon.proximityUUID,
                    major: currentBeacon.major,
                    minor: currentBeacon.minor,
                    accuracy: currentBeacon.accuracy,
                    macAddress: currentBeacon.macAddress,
                    rssi: currentBeacon.rssi));
              } else {
                // Ak neexistuje, pridajte nový výsledok do zoznamu
                // beacons.add(currentBeacon.toJson);

                beaconListView.add(Beacon(
                    proximityUUID: currentBeacon.proximityUUID,
                    major: currentBeacon.major,
                    minor: currentBeacon.minor,
                    accuracy: currentBeacon.accuracy,
                    macAddress: currentBeacon.macAddress,
                    rssi: currentBeacon.rssi));
              }

              // Zoradte zoznam podľa RSSI
              beaconListView.sort((b, a) => a.rssi.compareTo(b.rssi));
            }
          });
        }
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dostupné zariadenia'),
      ),
      body: ListView.builder(
        itemCount: beaconListView.length,
        itemBuilder: (context, index) {
          final beacon = beaconListView[index];

          return FutureBuilder<String>(
            future: _getSavedBeaconName(beacon.macAddress!),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListTile(
                  title: Text(
                    'MAC: ${beacon.macAddress}, RSSI: ${beacon.rssi}, name: ',
                    style: const TextStyle(fontSize: 20),
                  ),
                );
              } else {
                final String name = snapshot.data ?? '';
                final bool isSaved = name.isNotEmpty;
                return ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'MAC: ${beacon.macAddress}, RSSI: ${beacon.rssi}, name: '),
                        TextSpan(
                          text: name.isNotEmpty ? name : 'NONE',
                          style: TextStyle(
                            color: isSaved ? Colors.green : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // trailing: isSaved
                  //     ? Icon(Icons.check_circle, color: Colors.green)
                  //     : Icon(Icons.check_circle, color: Colors.red),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BeaconDetailPage(beacon: beacon)),
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  Future<String> _getSavedBeaconName(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final String savedJson = prefs.getString(macAddress) ?? '';
    if (savedJson.isNotEmpty) {
      final Cip savedCip = Cip.fromJson(jsonDecode(savedJson));
      return savedCip.pomenovanie_;
    }
    return '';
  }
}
