import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ibeacon.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ZoznamKalibracii extends StatefulWidget {
  const ZoznamKalibracii({super.key});

  @override
  State<ZoznamKalibracii> createState() => _ZoznamKalibraciiState();
}

class _ZoznamKalibraciiState extends State<ZoznamKalibracii> {
  List<Cip> cipy = [];
  late String? urlAdresa;
  String csrfToken = '';

  @override
  void initState() {
    super.initState();
    getChips();
  }

  Future<void> getChips() async {
    final prefs = await SharedPreferences.getInstance();
    String? csrfTokenTemp = prefs.getString('csrfToken');
    if (csrfTokenTemp != null) {
      csrfToken = csrfTokenTemp;
      urlAdresa = prefs.getString('urlAddress');
      var connectivityResult = await (Connectivity().checkConnectivity());
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
          List<Cip> cipList = cipListJson
              .where((cipJson) => cipJson != null)
              .map((cipJson) => Cip.fromJson(cipJson))
              .toList();
          setState(() {
            cipy = cipList;
          });
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
                          'Žiadne pripojenie k internetu',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Výber kalibrovaného čipu'),
        ),
        body: cipy.isNotEmpty
            ? ListView.builder(
                itemCount: cipy.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${cipy[index].pomenovanie_}, ${cipy[index].macAddress_}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailScreen(cip: cipy[index])),
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
  List<urobenaKalibracia> kalibracie = [];
  late String? urlAdresa;
  String csrfToken = '';

  @override
  void initState() {
    super.initState();
    getCalibratons();
  }

  Future<void> getCalibratons() async {
    final prefs = await SharedPreferences.getInstance();
    String? csrfTokenTemp = prefs.getString('csrfToken');
    if (csrfTokenTemp != null) {
      csrfToken = csrfTokenTemp;
      urlAdresa = prefs.getString('urlAddress');
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult != ConnectivityResult.none) {
        http.Response response;

        try {
          response = await http.get(
            Uri.parse(
                '$urlAdresa/api/get_calibration_list/?macAddress=${widget.cip.macAddress_}'),
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
        } on FormatException catch (error) {
          print('Error parsing JSON: $error');
          response = http.Response('', 400);
        } catch (error) {
          print('Došlo k chybe: $error');
          response = http.Response('', 400);
        }

        if (response.body.isNotEmpty) {
          List<dynamic> calibrationListJson = jsonDecode(response.body);
          print(calibrationListJson);
          List<urobenaKalibracia> calibrationList = calibrationListJson
              .where((calibrationJson) => calibrationJson != null)
              .map((calibrationJson) =>
                  urobenaKalibracia.fromJson(calibrationJson))
              .toList();
          setState(() {
            kalibracie = calibrationList;
          });
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
                    Icons.warning,
                    color: Colors.white,
                    size: 50,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Žiadne pripojenie k internetu.',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cip.pomenovanie_),
      ),
      body: kalibracie.isNotEmpty
          ? ListView.builder(
              itemCount: kalibracie.length,
              itemBuilder: (context, index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: ListTile(
                    title: Text('čas kalibrácie: ' +
                        kalibracie[index].cas_od_.toIso8601String() +
                        ', pozícia: ' +
                        kalibracie[index].pozicia_),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async {
                        try {
                          final response = await http.delete(
                              Uri.parse(
                                  '$urlAdresa/api/delete_calibration/?id=${kalibracie[index].id_}'),
                              headers: {'Cookie': csrfToken});

                          if (response.statusCode >= 200 &&
                              response.statusCode < 300) {
                            setState(() {
                              kalibracie.removeAt(index);
                            });
                          } else {
                            print(
                                'Error deleting calibration: ${response.statusCode}, ${response.body}');
                            // Optionally show a user-friendly error message
                          }
                        } catch (error) {
                          print(
                              'Error occurred while deleting calibration: $error');
                          // Optionally show a user-friendly error message
                        }
                      },
                    ),
                  ],
                );
              },
            )
          : Center(
              child: Text('Žiadna kalibrácia'),
            ),
    );
  }
}

class urobenaKalibracia {
  late String pozicia_;
  late int id_;
  late String macAdress_;
  late DateTime cas_od_;
  late DateTime cas_do_;

  urobenaKalibracia(String pozicia, int id, String macAdress, DateTime cas_od,
      DateTime cas_do) {
    pozicia_ = pozicia;
    id_ = id;
    macAdress_ = macAdress;
    cas_od_ = cas_od;
    cas_do_ = cas_do;
  }

  urobenaKalibracia.fromJson(Map<String, dynamic> json) {
    pozicia_ = json['position'];
    id_ = json['id'];
    macAdress_ = json['macAddress'];
    cas_od_ = DateTime.parse(json['datetime_from']);
    cas_do_ = DateTime.parse(json['datetime_to']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.pozicia_;
    data['id'] = this.id_;
    data['macAddress'] = this.macAdress_;
    data['datetime_from'] = this.cas_od_.toIso8601String();
    data['datetime_to'] = this.cas_do_.toIso8601String();
    return data;
  }
}
