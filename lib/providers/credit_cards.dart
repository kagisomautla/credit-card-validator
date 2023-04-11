import 'package:credit_card_validator/Models/credit_card_model.dart';
import 'package:flutter/material.dart';

class CreditCardsProvider with ChangeNotifier {
  List<MyCreditCardModel> _creditCards = [];
  List<MyCreditCardModel> get creditCards => _creditCards;
  set creditCards(List<MyCreditCardModel> newVal) {
    _creditCards = newVal;
    notifyListeners();
  }
}
