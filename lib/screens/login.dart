import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          backgroundColor: GFColors.LIGHT,
          body: Padding(
            padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/images/gflogo.png',
                  width: width * 0.25,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: TextField(
                    onChanged: (text) {
                      print(text);
                      setState(() {
                        user.username = text;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Username'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        user.password = text;
                      });
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        user.url = text;
                      });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Website Url'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GFButton(
                  onPressed: () => submit(context),
                  text: 'login',
                  color: GFColors.DARK,
                ),
              ],
            ),
          )),
    );
  }

  void submit(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', 'xyz');
    Navigator.pop(context);
  }
}
