import 'package:flutter/material.dart';

class CountriesProvider with ChangeNotifier {
  List<String> _bannedCountries = [];
  List<String> get bannedCountries => _bannedCountries;
  set bannedCountries(List<String> newVal) {
    _bannedCountries = newVal;
    notifyListeners();
  }
}
