import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:openemr/interface/splashScreen.dart';
import 'package:openemr/library/auth.dart';
import 'package:openemr/data/database_helper.dart';
import 'package:openemr/models/user.dart';
import 'package:openemr/presenter/login_presenter.dart';
import 'package:openemr/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {

  bool _isLoading = false, _savePassword = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _username, _password, _url;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username.trim(), _password.trim(), _url, _savePassword);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(context).pushReplacementNamed("/home");
  }

  var _value = "en";

  DropdownButton _normalDown() => DropdownButton<String>(
        underline: Container(
          height: 2,
          color: Theme.of(context).textSelectionColor,
        ),
        items: [
          DropdownMenuItem(
            value: "en",
            child: Text(
              "English",
            ),
          ),
          DropdownMenuItem(
            value: "ar",
            child: Text(
              "Arabic",
            ),
          ),
        ],
        onChanged: (value) {
          MyApp.setLocale(context, Locale(value));
          setState(() {
            _value = value;
          });
        },
        value: _value,
      );

  @override
  Widget build(BuildContext context) {
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text(MyLocalizations.of(context, 'LOGIN')),
      color: Theme.of(context).buttonColor,
    );

    Column generateLoginForm(name, pwd, url, saveF) {
      return Column(children: <Widget>[
        new Image.asset("assets/images/logo.png", fit: BoxFit.cover),
        new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new TextFormField(
                initialValue: name,
                onSaved: (val) => _username = val,
                decoration: new InputDecoration(
                    labelText: MyLocalizations.of(context, 'Username')),
              ),
              new TextFormField(
                initialValue: pwd,
                onSaved: (val) => _password = val,
                decoration: new InputDecoration(
                    labelText: MyLocalizations.of(context, 'Password')),
                obscureText: true,
              ),
              new TextFormField(
                initialValue: url,
                onSaved: (val) => _url = val,
                decoration: new InputDecoration(
                    labelText: MyLocalizations.of(context, 'URL'),
                    hintText: "http://example.com"),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 45.0,
                    width: 24.0,
                    child: Checkbox(
                      value: saveF,
                      onChanged: (newValue) {
                        setState(() {
                          _savePassword = newValue;
                        });
                      },
                    ),
                  ),
                  Text(" Save Credentials")
                ],
              ),
            ],
          ),
        ),
        _normalDown(),
        _isLoading ? new CircularProgressIndicator() : loginBtn,
      ]);
    }

    Future<Map<String, dynamic>> _getUser() async {
      var db = new DatabaseHelper();
      var res = await db.getUser();
      return res;
    }

    return new GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            appBar: null,
            key: scaffoldKey,
            body: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SingleChildScrollView(
                    child: FutureBuilder<Map<String, dynamic>>(
                        future: _getUser(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          if (snapshot.hasData) {
                            var d = snapshot.data;
                            return generateLoginForm(
                                d["username"], d["password"], d["baseUrl"], _savePassword);
                          }
                          return SplashScreen();
                        })),
                decoration: new BoxDecoration(
                    color: Colors.teal.shade200.withOpacity(0.5)),
              ),
            )));
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
