import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

Future<dynamic> fetchBannedCountries() async {
  String? data = await storage.read(key: 'banned_countries');
  List<dynamic> decodedJson = [];

  if (data != null) {
    decodedJson = json.decode(data);
  }

  return decodedJson;
}

Future<dynamic> fetchCreditCards() async {
  String? data = await storage.read(key: 'credit_cards');
  List<dynamic> decodedJson = [];

  if (data != null) {
    decodedJson = json.decode(data);
  }

  return decodedJson;
}
