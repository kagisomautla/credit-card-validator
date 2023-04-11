import 'package:awesome_card/awesome_card.dart';
import 'package:credit_card_validator/Models/credit_card_model.dart';
import 'package:credit_card_validator/controls/pop_up.dart';
import 'package:credit_card_validator/controls/text.dart';
import 'package:credit_card_validator/local%20storage/fetch.dart';
import 'package:credit_card_validator/local%20storage/send.dart';
import 'package:credit_card_validator/providers/credit_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreditCardsScreen extends StatefulWidget {
  const CreditCardsScreen({super.key});

  @override
  State<CreditCardsScreen> createState() => _CreditCardsScreenState();
}

class _CreditCardsScreenState extends State<CreditCardsScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool showIssuingCountryError = false;
  String? issuingCountry;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    List<dynamic> decodedJson = await fetchCreditCards();
    CreditCardsProvider creditCardsProvider = Provider.of<CreditCardsProvider>(context, listen: false);

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
  }

  @override
  Widget build(BuildContext context) {
    CreditCardsProvider creditCardsProvider = Provider.of<CreditCardsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios),
        ),
        title: TextControl(
          text: 'Credit Cards',
          isBold: true,
          color: Colors.white,
        ),
        elevation: 2.0,
      ),
      body: creditCardsProvider.creditCards.isEmpty
          ? Center(
              child: TextControl(text: 'There are no stored credit cards.'),
            )
          : SingleChildScrollView(
              child: Column(
                children: creditCardsProvider.creditCards.map((e) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CreditCard(
                              cardNumber: e.cardNumber,
                              cardExpiry: e.expDate,
                              cardHolderName: e.cardHolder,
                              bankName: 'Axis Bank',
                              showBackSide: false,
                              frontBackground: CardBackgrounds.black,
                              backBackground: CardBackgrounds.white,
                              showShadow: true,
                              // mask: getCardTyp
                              //eMask(cardType: CardType.americanExpress),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              popupControl(
                                context: context,
                                message: 'Are you sure?',
                                title: 'Remove Credit Card',
                                onConfirm: () {
                                  setState(() {
                                    creditCardsProvider.creditCards.remove(e);
                                    storeCreditCard(value: creditCardsProvider.creditCards);
                                    init();
                                    Navigator.pop(context);
                                  });
                                },
                              );
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }
}
