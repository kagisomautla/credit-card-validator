import 'package:awesome_card/awesome_card.dart';

Map<CardType, Set<List<String>>> cardNumPatterns = <CardType, Set<List<String>>>{
  CardType.visa: <List<String>>{
    ['4'],
  },
  CardType.americanExpress: <List<String>>{
    ['34'],
    ['37'],
  },
  CardType.discover: <List<String>>{
    ['6011'],
    ['622126', '622925'], // China UnionPay co-branded
    ['644', '649'],
    ['65']
  },
  CardType.masterCard: <List<String>>{
    ['51', '55'],
    ['2221', '2229'],
    ['223', '229'],
    ['23', '26'],
    ['270', '271'],
    ['2720'],
  },
  CardType.elo: <List<String>>{
    ['401178'],
    ['401179'],
    ['438935'],
    ['457631'],
    ['457632'],
    ['431274'],
    ['451416'],
    ['457393'],
    ['504175'],
    ['506699', '506778'],
    ['509000', '509999'],
    ['627780'],
    ['636297'],
    ['636368'],
    ['650031', '650033'],
    ['650035', '650051'],
    ['650405', '650439'],
    ['650485', '650538'],
    ['650541', '650598'],
    ['650700', '650718'],
    ['650720', '650727'],
    ['650901', '650978'],
    ['651652', '651679'],
    ['655000', '655019'],
    ['655021', '655058']
  },
};

CardType detectCCType(String cardNumber) {
  CardType cardType = CardType.other;

  if (cardNumber.isEmpty) {
    return cardType;
  }

  cardNumPatterns.forEach(
    (CardType type, Set<List<String>> patterns) {
      for (List<String> patternRange in patterns) {
        String ccPatternStr = cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
        final int rangeLen = patternRange[0].length;
        if (rangeLen < cardNumber.length) {
          ccPatternStr = ccPatternStr.substring(0, rangeLen);
        }

        if (patternRange.length > 1) {
          final int ccPrefixAsInt = int.parse(ccPatternStr);
          final int startPatternPrefixAsInt = int.parse(patternRange[0]);
          final int endPatternPrefixAsInt = int.parse(patternRange[1]);
          if (ccPrefixAsInt >= startPatternPrefixAsInt && ccPrefixAsInt <= endPatternPrefixAsInt) {
            cardType = type;
            break;
          }
        } else {
          if (ccPatternStr == patternRange[0]) {
            cardType = type;
            break;
          }
        }
      }
    },
  );

  return cardType;
}

bool isNumeric(String? str) {
  if (str == null || str.isEmpty) {
    return false;
  }
  final numericRegex = RegExp(r'^[0-9]+$');
  return numericRegex.hasMatch(str);
}

bool isAlphabetic(String input) {
  for (int i = 0; i < input.length; i++) {
    if (!input[i].contains(RegExp('[a-zA-Z\\s]'))) {
      return false;
    }
  }

  return true;
}
