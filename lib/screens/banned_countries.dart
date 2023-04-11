import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:credit_card_validator/Models/countries_model.dart';
import 'package:credit_card_validator/controls/text.dart';
import 'package:credit_card_validator/local%20storage/delete.dart';
import 'package:credit_card_validator/local%20storage/fetch.dart';
import 'package:credit_card_validator/local%20storage/send.dart';
import 'package:credit_card_validator/providers/countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class BannedCountries extends StatefulWidget {
  const BannedCountries({super.key});

  @override
  State<BannedCountries> createState() => _BannedCountriesState();
}

class _BannedCountriesState extends State<BannedCountries> {
  List<String> _excludedCountries = [];
  List<CountriesModel> bannedCountries = [];
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    List<dynamic> decodedJson = await fetchBannedCountries();
    CountriesProvider countriesProvider = Provider.of<CountriesProvider>(context, listen: false);

    setState(() {
      loading = true;
    });

    if (decodedJson.isNotEmpty) {
      setState(() {
        _excludedCountries = [];
        bannedCountries = decodedJson.map((e) => CountriesModel(country: e['country'], countryCode: e["country_code"])).toList();

        for (var element in bannedCountries) {
          _excludedCountries.add(element.countryCode!);
        }

        countriesProvider.bannedCountries = _excludedCountries;
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    CountriesProvider countriesProvider = Provider.of<CountriesProvider>(context, listen: false);
    return loading
        ? CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios),
              ),
              title: TextControl(
                text: 'Banned Countries',
                isBold: true,
                color: Colors.white,
              ),
              elevation: 2.0,
            ),
            bottomNavigationBar: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      showWorldWide: true,
                      countryListTheme: CountryListThemeData(
                        flagSize: 25,
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                        bottomSheetHeight: MediaQuery.of(context).size.height / 1.1, // Optional. Country list modal height
                        //Optional. Sets the border radius for the bottomsheet.
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        //Optional. Styles the search field.
                        inputDecoration: InputDecoration(
                          labelText: 'Search',
                          hintText: 'Start typing to search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF8C98A8).withOpacity(0.2),
                            ),
                          ),
                        ),
                      ),
                      exclude: _excludedCountries,
                      onSelect: (Country country) {
                        if (!bannedCountries.contains(country.name)) {
                          setState(() {
                            bannedCountries.add(
                              CountriesModel(
                                countryCode: country.countryCode,
                                country: country.name,
                              ),
                            );
                          });

                          storeBannedCountries(value: bannedCountries);
                          init();
                        }
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextControl(
                          text: 'Add Banned Country',
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: bannedCountries.isEmpty
                ? Center(
                    child: TextControl(text: 'There are no banned countries.'),
                  )
                : SingleChildScrollView(
                    child: Column(
                        children: bannedCountries.map((item) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.pin_drop,
                            color: Colors.black,
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              bannedCountries.remove(item);
                              storeBannedCountries(value: bannedCountries);
                              init();
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.black,
                            ),
                          ),
                          title: TextControl(
                            text: item.country,
                            size: TextProps.md,
                          ),
                        ),
                      );
                    }).toList()),
                  ),
          );
  }
}
