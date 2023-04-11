import 'package:credit_card_validator/controls/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerControl extends StatelessWidget {
  final Color? backgroundColor;

  DrawerControl({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    List<DrawerItems> drawerItems = [
      DrawerItems(
        icon: Icon(
          FontAwesomeIcons.mapLocation,
          color: Colors.blue,
          size: 30,
        ),
        itemName: TextControl(
          color: backgroundColor,
          text: 'Banned Countries',
        ),
        route: '/banned-countries',
      ),
      DrawerItems(
        icon: Icon(
          FontAwesomeIcons.creditCard,
          color: Colors.blue,
          size: 30,
        ),
        itemName: TextControl(
          color: backgroundColor,
          text: 'My Credit Cards',
        ),
        route: '/credit-cards',
      ),
    ];
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.blue,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: TextControl(
                          text: 'Close',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: backgroundColor,
                child: Column(
                  children: drawerItems.map((item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, item.route);
                      },
                      child: Card(
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          leading: item.icon,
                          title: item.itemName,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItems {
  final Icon icon;
  final TextControl itemName;
  final String route;

  DrawerItems({
    required this.icon,
    required this.itemName,
    required this.route,
  });
}
