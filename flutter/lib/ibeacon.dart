import 'package:flutter_beacon/flutter_beacon.dart';

class Cip {
  late String proximityUUID_;
  late int major_;
  late int minor_;
  late int rssi_;
  late double accuracy_;
  late Proximity proximity_;
  late int? txPower_;
  late String? macAddress_;
  late String pomenovanie_;

  Cip(String proximityUUID, int major, int minor, int rssi, double accuracy, Proximity proximity, int? txPower, String? macAddress, String pomenovanie) {
    proximityUUID_ = proximityUUID;
    major_ = major;
    minor_ = minor;
    rssi_ = rssi;
    accuracy_ = accuracy;
    proximity_ = proximity;
    txPower_ = txPower;
    macAddress_ = macAddress;
    pomenovanie_ = pomenovanie;
  }

  // Convert a Cip object into a Map<String, dynamic>
  Map<String, dynamic> toJson() => {
    'proximityUUID': proximityUUID_,
    'major': major_,
    'minor': minor_,
    'rssi': rssi_,
    'accuracy': accuracy_,
    'proximity': proximity_.toString(), // Convert enum to String
    'txPower': txPower_,
    'macAddress': macAddress_,
    'pomenovanie': pomenovanie_,
  };

  // Create a Cip object from a Map<String, dynamic>
  Cip.fromJson(Map<String, dynamic> json)
      : proximityUUID_ = json['proximityUUID'] ?? 'null',
        major_ = json['major'] != null ? int.parse(json['major'].toString()) : 0,
        minor_ = json['minor'] != null ? int.parse(json['minor'].toString()) : 0,
        rssi_ = json['rssi'] != null ? int.parse(json['rssi'].toString()) : 0,
        accuracy_ = json['accuracy'] != null ? double.parse(json['accuracy'].toString()) : 0.0,
        txPower_ = json['txPower'] != null ? int.parse(json['txPower'].toString()) : 0,
        proximity_ = json['proximity'] != null && Proximity.values.any((e) => e.toString() == json['proximity']) ? Proximity.values.firstWhere((e) => e.toString() == json['proximity']) : Proximity.unknown,
        macAddress_ = json['macAddress'] ?? 'null', // Use an empty string if null
        pomenovanie_ = json['pomenovanie'] ?? 'null';
}