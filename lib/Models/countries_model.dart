class CountriesModel {
  final String? country;
  final String? countryCode;

  CountriesModel({this.country, this.countryCode});

  Map<String, dynamic> toJson() {
    return {
      "country_code": countryCode,
      "country": country,
    };
  }

  CountriesModel.fromJson(Map<String, dynamic> json)
      : country = json["country"] ?? "",
        countryCode = json["country_code"] ?? "";
}
