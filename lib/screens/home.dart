import 'dart:io';
import 'dart:math' as math;
import 'package:country_picker/country_picker.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:credit_card_validator/Models/credit_card_model.dart';
import 'package:credit_card_validator/controls/button.dart';
import 'package:credit_card_validator/controls/dismiss_keyboard.dart';
import 'package:credit_card_validator/controls/drawer.dart';
import 'package:credit_card_validator/controls/input.dart';
import 'package:credit_card_validator/controls/snack_bar.dart';
import 'package:credit_card_validator/controls/text.dart';
import 'package:credit_card_validator/local%20storage/fetch.dart';
import 'package:credit_card_validator/local%20storage/send.dart';
import 'package:credit_card_validator/providers/countries.dart';
import 'package:credit_card_validator/providers/credit_cards.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:provider/provider.dart';
import '../utils/functions.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String cardNumber = '';
  String cardHolderName = '';
  String expiryDate = '';
  String cvv = '';
  bool showBack = false;
  CardType? cardType;
  bool showIssuingCountryError = false;
  String? issuingCountry;
  late FocusNode _focusNode;
  TextEditingController cardNumberCtrl = TextEditingController();
  TextEditingController expiryFieldCtrl = TextEditingController();
  TextEditingController issuingCountryCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  init() async {
    CountriesProvider countriesProvider = Provider.of<CountriesProvider>(context, listen: false);
    List<dynamic> decodedJson = await fetchBannedCountries();
    for (var element in decodedJson) {
      countriesProvider.bannedCountries.add(element["country_code"]);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _scanCard() async {
    try {
      CardDetails? cardDetails = await CardScanner.scanCard();

      setState(() {
        cardHolderName = cardDetails?.cardHolderName ?? '';
        cardNumber = cardDetails?.cardNumber ?? '';
        expiryDate = cardDetails?.expiryDate ?? '';
        cardNumberCtrl.text = cardDetails?.cardNumber ?? '';
        expiryFieldCtrl.text = cardDetails?.expiryDate ?? '';
      });
    } catch (e) {
      print('error: $e');
    }
  }

  _onValidate() async {
    bool found = false;
    final formState = _formKey.currentState;

    if (formState != null && formState.validate()) {
      CreditCardsProvider creditCardsProvider = Provider.of<CreditCardsProvider>(context, listen: false);
      MyCreditCardModel myCreditCard = MyCreditCardModel(
        cardHolder: cardHolderName,
        cardNumber: cardNumber,
        expDate: expiryDate,
        issuingCountry: issuingCountry,
      );
      List decodedJson = await fetchCreditCards();

      if (issuingCountry == null) {
        setState(() {
          showIssuingCountryError = true;
        });
        return;
      } else {
        setState(() {
          showIssuingCountryError = false;
        });
      }

      if (decodedJson.isNotEmpty) {
        creditCardsProvider.creditCards = decodedJson
            .map(
              (e) => MyCreditCardModel(
                cardHolder: e['card_holder'],
                cardNumber: e['card_number'],
                expDate: e['expiration_date'],
                issuingCountry: e['issuing_country'],
              ),
            )
            .toList();
      }

      if (creditCardsProvider.creditCards.isNotEmpty) {
        for (var card in creditCardsProvider.creditCards) {
          if (card.cardNumber == myCreditCard.cardNumber) {
            setState(() {
              found = true;
            });
          }
        }
      }

      if (found) {
        snackBarControl(context: context, message: 'Credit card already exists!');
      } else {
        setState(() {
          creditCardsProvider.creditCards.add(myCreditCard);
          storeCreditCard(value: creditCardsProvider.creditCards);
        });

        snackBarControl(context: context, message: 'Credit card validated and stored.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CountriesProvider countriesProvider = Provider.of<CountriesProvider>(context, listen: false);
    return Scaffold(
      drawer: DrawerControl(),
      appBar: AppBar(
        title: TextControl(
          text: 'Payments',
          isBold: true,
          color: Colors.white,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _scanCard();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Center(
                child: TextControl(
                  text: 'Scan Card',
                  isBold: true,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: DismissKeyboardControl(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              CreditCard(
                cardNumber: cardNumber,
                cardExpiry: expiryDate,
                cardHolderName: cardHolderName,
                cvv: cvv,
                bankName: 'Axis Bank',
                showBackSide: showBack,
                frontBackground: CardBackgrounds.black,
                backBackground: CardBackgrounds.white,
                showShadow: true,
                cardType: cardType,
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InputControl(
                        title: 'Card Holder Name',
                        required: true,
                        initialValue: cardHolderName,
                        enabled: true,
                        placeholder: 'Please enter card holder name',
                        onChanged: (value) {
                          setState(() {
                            cardHolderName = value;
                          });
                          print(value);
                        },
                        validator: (value) {
                          if (cardHolderName.isEmpty) {
                            return 'Card holder name is required.';
                          }
                          bool isValid = isAlphabetic(cardHolderName);
                          print(isValid);

                          if (!isValid) {
                            return 'Holder name should not contain any numeric value.';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputControl(
                        title: 'Card Number',
                        required: true,
                        initialValue: cardNumberCtrl.text,
                        enabled: true,
                        placeholder: 'Please enter card number',
                        onInitialized: (controller) {
                          cardNumberCtrl = controller;
                        },
                        onChanged: (value) {
                          final newCardNumber = value.trim();
                          var newStr = '';
                          final step = 4;

                          for (var i = 0; i < newCardNumber.length; i += step) {
                            newStr += newCardNumber.substring(i, math.min(i + step, newCardNumber.length));
                            if (i + step < newCardNumber.length) newStr += ' ';
                          }

                          setState(() {
                            cardNumber = newStr;
                          });

                          detectCCType(value);
                        },
                        maxLength: 16,
                        validator: (value) {
                          bool isValid = isNumeric(cardNumberCtrl.text);

                          if (value == null || value.isEmpty) {
                            return 'Card number is required.';
                          }
                          if (isValid == false) {
                            return 'Card number should not contain non-numeric values.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InputControl(
                        title: 'CVV',
                        onInitialized: (controller) {
                          expiryFieldCtrl = controller;
                        },
                        maxLength: 5,
                        onChanged: (value) {
                          var newDateValue = value.trim();
                          final isPressingBackspace = expiryDate.length > newDateValue.length;
                          final containsSlash = newDateValue.contains('/');

                          if (newDateValue.length >= 2 && !containsSlash && !isPressingBackspace) {
                            newDateValue = newDateValue.substring(0, 2) + '/' + newDateValue.substring(2);
                          }
                          setState(() {
                            expiryFieldCtrl.text = newDateValue;
                            expiryFieldCtrl.selection = TextSelection.fromPosition(TextPosition(offset: newDateValue.length));
                            expiryDate = newDateValue;
                          });
                        },
                        validator: (value) {
                          if (expiryFieldCtrl.text.isEmpty) {
                            return 'CVV is required.';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            showWorldWide: true,
                            exclude: countriesProvider.bannedCountries,
                            countryListTheme: CountryListThemeData(
                              flagSize: 25,
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                              bottomSheetHeight: MediaQuery.of(context).size.height / 1.1,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
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
                            onSelect: (Country country) {
                              setState(() {
                                issuingCountry = country.displayName;
                                showIssuingCountryError = false;
                                issuingCountryCtrl.text = country.displayName;
                              });
                            },
                          );
                        },
                        child: InputControl(
                          title: 'Tap to select issuing country.',
                          enabled: false,
                          required: true,
                          initialValue: expiryFieldCtrl.text,
                          onInitialized: (controller) {
                            issuingCountryCtrl = controller;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      showIssuingCountryError == true
                          ? Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: TextControl(
                                    text: 'Please select an issuing country',
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      ButtonControl(title: 'Validate and Store', backgroundColor: Colors.black, onTap: _onValidate),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
