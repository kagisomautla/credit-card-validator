class MyCreditCardModel {
  final String? cardNumber;
  final String? cardHolder;
  final String? expDate;
  final String? issuingCountry;

  MyCreditCardModel({
    this.cardHolder,
    this.cardNumber,
    this.expDate,
    this.issuingCountry,
  });

  Map<String, dynamic> toJson() {
    return {
      "card_holder": cardHolder,
      "card_number": cardNumber,
      "expiration_date": expDate,
      "issuing_country": issuingCountry,
    };
  }
}
