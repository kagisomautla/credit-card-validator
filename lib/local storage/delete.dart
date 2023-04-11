import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

deleteBannedCountries() async {
  await storage.delete(key: 'banned_countries');
}

deleteCreditCards() async {
  await storage.delete(key: 'credit_cards');
}

deleteAll() async {
  await storage.deleteAll();
}
