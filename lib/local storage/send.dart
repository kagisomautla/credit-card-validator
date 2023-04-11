import 'dart:convert';
import 'package:credit_card_validator/Models/countries_model.dart';
import 'package:credit_card_validator/Models/credit_card_model.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

storeBannedCountries({required List<CountriesModel> value}) async {
  await storage.write(key: 'banned_countries', value: jsonEncode(value));
}

storeCreditCard({required List<MyCreditCardModel> value}) async {
  await storage.write(key: 'credit_cards', value: jsonEncode(value));
}
