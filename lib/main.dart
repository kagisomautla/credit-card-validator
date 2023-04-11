import 'package:credit_card_validator/providers/countries.dart';
import 'package:credit_card_validator/providers/credit_cards.dart';
import 'package:credit_card_validator/screens/banned_countries.dart';
import 'package:credit_card_validator/screens/credit_cards.dart';
import 'package:credit_card_validator/screens/home.dart';
import 'package:credit_card_validator/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(const RankInteractiveCreditCardApp());
}

class RankInteractiveCreditCardApp extends StatelessWidget {
  const RankInteractiveCreditCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CountriesProvider>(create: (_) => CountriesProvider()),
        ChangeNotifierProvider<CreditCardsProvider>(create: (_) => CreditCardsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => LandingScreen(),
          '/home': (BuildContext context) => HomeScreen(),
          '/banned-countries': (BuildContext context) => BannedCountries(),
          '/credit-cards': (BuildContext context) => CreditCardsScreen(),
        },
      ),
    );
  }
}
