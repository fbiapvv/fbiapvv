import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:ibeacon/ibeacon.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kalibracia extends StatefulWidget {
  const Kalibracia({Key? key}) : super(key: key);

  @override
  State<Kalibracia> createState() => _KalibraciaState();
}

class _KalibraciaState extends State<Kalibracia> {
  List<Cip> cipy = [];
  late String? urlAdresa;
  List<RangingResult> beacons = [];
  String csrfToken = '';
  StreamSubscription<RangingResult>? _streamRanging;

  @override
  void initState() {
    super.initState();
    initBeaconScan();
    getChips(); // Get the list of cipy
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
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
      final regions = <Region>[];
      if (Platform.isIOS) {
        regions.add(Region(
            identifier: 'Apple Airlocate',
            proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));
      } else {
        regions.add(Region(identifier: 'com.beacon'));
      }

      _streamRanging =
          flutterBeacon.ranging(regions).listen((RangingResult result) {
        if (result.beacons.isNotEmpty) {
          setState(() {
            beacons.add(result);
          });
        }
      });
    }
  }

  Future<void> getChips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var connectivityResult = await (Connectivity().checkConnectivity());
      String? csrfTokenTemp = prefs.getString('csrfToken');
      if (csrfTokenTemp != null) {
        csrfToken = csrfTokenTemp;
        urlAdresa = prefs.getString('urlAddress');
        if (connectivityResult != ConnectivityResult.none) {
          http.Response response;
          try {
            response = await http.get(
              Uri.parse('$urlAdresa/api/get_chip_list/?info=get_all_chips'),
              headers: {
                'Content-Type': 'application/json',
                'charset': 'UTF-8',
                'Cookie': csrfToken
              },
            );
            print(response.statusCode);
            if (response.statusCode != 200) {
              throw Exception(
                  'Server vrátil chybový status kód: ${response.statusCode}');
            }
          } catch (error) {
            print('Došlo k chybe: $error');
            response = http.Response('', 400);
          }

          if (response.body.isNotEmpty) {
            List<dynamic> cipListJson = jsonDecode(response.body);
            print(cipListJson);
            List<Cip> cipList = cipListJson
                .where((cipJson) => cipJson != null)
                .map((cipJson) => Cip.fromJson(cipJson))
                .toList();
            setState(() {
              cipy = cipList;
            });
          }
        } else {
          // Handle case when there's no internet connection
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
                      Icons.warning,
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
                            'Žiadne pripojenie k internetu.',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Text(
                            'Skontrolujte či máte pripojenie k internetu.',
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
      print('Neočakávaný error v getChips: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter cipy based on nearby beacons
    List<Cip> nearbyCipy = cipy.where((cip) {
      return beacons.any((result) =>
          result.beacons.any((beacon) => beacon.macAddress == cip.macAddress_));
    }).toList();
    nearbyCipy.sort((a, b) => a.pomenovanie_.compareTo(b.pomenovanie_));
    return Scaffold(
        appBar: AppBar(
          title: Text('Kalibrácia'),
        ),
        body: nearbyCipy.isNotEmpty
            ? ListView.builder(
                itemCount: nearbyCipy.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${nearbyCipy[index].pomenovanie_}, ${nearbyCipy[index].macAddress_}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(cip: nearbyCipy[index])),
                      );
                    },
                  );
                },
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class DetailScreen extends StatefulWidget {
  final Cip cip;

  DetailScreen({Key? key, required this.cip}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<String> positions = [];
  String? selectedPosition;
  late DateTime cas_start;
  Timer? timer;
  late String? urlAdresa;
  late Stream<String> _stream;
  bool allCountersValid = false;
  late Stream<int> _timerStream;
  StreamSubscription<int>? _timerSubscription;
  Duration elapsedTime = Duration(seconds: 0);
  bool startIsTriggered = false;
  String csrfToken = '';

  @override
  void initState() {
    super.initState();
    getToken();
    _stream = Stream.empty();
    _timerStream = Stream.empty();
    getPositions();
  }

  @override
  void dispose() {
    zrusKalibraciu();
    _timerSubscription?.cancel();
    super.dispose();
  }

  Future<void> zrusKalibraciu() async {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
      http.Response response;
      try {
        response = await http.post(
          Uri.parse('$urlAdresa/api/cancel_calibration/'),
          headers: {'Cookie': csrfToken},
        );

        if (response.statusCode != 200) {
          throw Exception(
              'Server vrátil chybový status kód: ${response.statusCode}');
        }
      } catch (error) {
        print('Došlo k chybe: $error');
        response = http.Response('', 400);
      }

      print(response.statusCode);
    }
  }

  Future<void> getPositions() async {
    final prefs = await SharedPreferences.getInstance();
    urlAdresa = prefs.getString('urlAddress');
    // Replace with your actual GET request
    final response = await http.get(
        Uri.parse(
            '$urlAdresa/api/get_position_list/?info=get_positions&macAddress=${widget.cip.macAddress_}'),
        headers: {'Cookie': csrfToken});
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> positionListJson = jsonDecode(response.body);
      print(jsonDecode(response.body));
      // Extract the string field from each JSON object and add it to the positions list
      setState(() {
        positions = positionListJson
            .map((positionJson) => positionJson['name'])
            .cast<String>()
            .toList();
        selectedPosition =
            positions[0]; // Initialize selectedPosition with the first position
      });
    } else {
      throw Exception('Failed to load positions');
    }
  }

  Color textColorBasedOnCount(int count) {
    if (count > 0 && count < 5) {
      return Color.fromARGB(255, 195, 119, 4);
    } else if (count >= 5) {
      return Color.fromARGB(255, 39, 173, 43);
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cip.pomenovanie_),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Detaily pre cip ${widget.cip.pomenovanie_}'),
              Text('MAC_Adresa: ${widget.cip.macAddress_}'),
              const Divider(
                color: Colors.black,
                height: 25,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pozícia: ',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: selectedPosition,
                    icon: Icon(Icons.arrow_downward),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPosition = newValue;
                      });
                    },
                    items:
                        positions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        if (!startIsTriggered) {
                          start_kalibracie();
                          startIsTriggered = true;
                        }
                      },
                      child: Text(
                        'START',
                        style: TextStyle(fontSize: 20),
                      ))),
              SizedBox(
                height: 25,
              ),
              Container(
                  width: 300,
                  height: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        if (allCountersValid) {
                          if (startIsTriggered) {
                            stop_kalibracie(context);
                            startIsTriggered = false;
                          }
                        } else if (!allCountersValid) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Niektoré vysielače nemajú aspoň 5 prijatí.",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  content: const Text(
                                      "Naozaj si prajete zastaviť kalibráciu?",
                                      textAlign: TextAlign.center),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          child: const Text("Nie"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            "Ano",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            if (startIsTriggered) {
                                              stop_kalibracie(context);
                                              startIsTriggered = false;
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                      child: Text(
                        'STOP',
                        style: TextStyle(fontSize: 20),
                      ))),
              SizedBox(
                height: 15,
              ),
              Text(
                'Trvanie kalibrácie: ${elapsedTime.inSeconds} sekúnd',
                style: TextStyle(
                  color:
                      timer?.isActive ?? false ? Colors.orange : Colors.black,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder<String>(
                stream: _stream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    var data = jsonDecode(snapshot.data!)['reader_counters'];
                    allCountersValid = data.every((counter) =>
                        counter['reader_count'] == 0 ||
                        counter['reader_count'] > 4);
                    return SingleChildScrollView(
                      child: Table(
                        border: TableBorder.all(),
                        children: [
                          TableRow(children: [
                            Text('Raspberry', textAlign: TextAlign.center),
                            Text('Počet', textAlign: TextAlign.center),
                            Text('Raspberry', textAlign: TextAlign.center),
                            Text('Počet', textAlign: TextAlign.center),
                          ]),
                          for (var i = 0; i < 8; i++)
                            TableRow(
                              children: [
                                Text(
                                  data[i]['reader_name'],
                                  style: TextStyle(
                                      color: textColorBasedOnCount(
                                          data[i]['reader_count'])),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  data[i]['reader_count'].toString(),
                                  style: TextStyle(
                                      color: textColorBasedOnCount(
                                          data[i]['reader_count'])),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  data[i + 8]['reader_name'],
                                  style: TextStyle(
                                      color: textColorBasedOnCount(
                                          data[i + 8]['reader_count'])),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  data[i + 8]['reader_count'].toString(),
                                  style: TextStyle(
                                      color: textColorBasedOnCount(
                                          data[i + 8]['reader_count'])),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Chyba: ${snapshot.error}');
                  } else {
                    return Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          Text('Raspberry', textAlign: TextAlign.center),
                          Text('Počet', textAlign: TextAlign.center),
                          Text('Raspberry', textAlign: TextAlign.center),
                          Text('Počet', textAlign: TextAlign.center),
                        ]),
                        for (var i = 1; i <= 8; i++)
                          TableRow(children: [
                            Text('názov', textAlign: TextAlign.center),
                            Text('0', textAlign: TextAlign.center),
                            Text('názov', textAlign: TextAlign.center),
                            Text('0', textAlign: TextAlign.center),
                          ]),
                      ],
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void start_kalibracie() {
    try {
      _timerStream = Stream.periodic(Duration(seconds: 1), (count) => count);
      _timerSubscription = _timerStream.listen((event) {
        setState(() {
          elapsedTime = Duration(seconds: event);
        });
      });
      cas_start = DateTime.now();
      print(cas_start);
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => makeRequest());
    } catch (error) {
      print('Neočakávaný error v start_kalibracie: $error');
    }
  }

  Future<void> stop_kalibracie(BuildContext context) async {
    // Zobrazenie čakacieho koliečka pred začatím operácie
    showDialog(
      context: context,
      barrierDismissible: false, // prevent user from closing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Čakajte prosím...'),
            ],
          ),
        );
      },
    );

    try {
      timer?.cancel();
      _timerSubscription?.cancel();
      final stop_kalibracie = {
        'macAddress': widget.cip.macAddress_,
        'pozicia': selectedPosition,
        'cas_start': cas_start.toIso8601String(),
        'cas_stop': DateTime.now().toIso8601String()
      };
      http.Response response;
      try {
        response = await http.post(
          Uri.parse('$urlAdresa/api/create_calibration_flutter/'),
          headers: {'Content-Type': 'application/json', 'Cookie': csrfToken},
          body: jsonEncode(stop_kalibracie),
        );
        if (response.statusCode != 200) {
          throw Exception(
              'Server vrátil chybový status kód: ${response.statusCode}');
        }
      } catch (error) {
        print('Došlo k chybe: $error');
        response = http.Response('', 400);
      }
      getPositions();
      print(response.statusCode);
      print(response.body);
    } catch (error) {
      print('Neočakávaný error v stop_kalibracie: $error');
    } finally {
      Navigator.pop(context); // Skryje čakacie koliečko po dokončení operácie
    }

    setState(() {});
  }

  Future<void> makeRequest() async {
    print('cas_start');
    print(cas_start.toIso8601String());
    print('cas_teraz');
    print(DateTime.now().toIso8601String());
    http.Response response;
    try {
      response = await http.get(
          Uri.parse(
              '$urlAdresa/api/ongoing_calibration/?macAddress=${widget.cip.macAddress_}&cas_start=${cas_start.toIso8601String()}&cas_teraz=${DateTime.now().toIso8601String()}'),
          headers: {'Cookie': csrfToken});
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception(
            'Server vrátil chybový status kód: ${response.statusCode}');
      }
    } catch (error) {
      print('Došlo k chybe: $error');
      response = http.Response('', 400);
    }

    setState(() {
      _stream = Stream.periodic(Duration(seconds: 1), (count) {
        return response.body;
      });
    });
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    csrfToken = prefs.getString('csrfToken')!;
  }
}
