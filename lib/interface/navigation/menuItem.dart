import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem extends StatelessWidget {
  final String route, name;
  final FaIcon icon;

  const MenuItem(
    this.icon, {
    this.route,
    this.name,
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(route);
          },
          child: icon,
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
