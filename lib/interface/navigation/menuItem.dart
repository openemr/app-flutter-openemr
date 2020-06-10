import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openemr/data/database_helper.dart';

class MenuItem extends StatelessWidget {
  final String route;
  final IconData icon;
  final action;

  const MenuItem(
      {Key key, this.icon, this.route = "/comingSoon", this.action = "route"})
      : super(key: key);

  routePage(context) {
    Navigator.of(context).pushNamed(route);
  }

  handleLogout(context) async {
    var db = new DatabaseHelper();
    await db.logoutUser();
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/login",
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            if (action == "route") {
              routePage(context);
            } else if (action == "logout") {
              handleLogout(context);
            }
          },
          child: FaIcon(
            icon,
            color: Colors.white,
            size: 60.0,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
