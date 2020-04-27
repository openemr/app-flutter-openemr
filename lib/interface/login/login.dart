import 'dart:ui';

import 'package:flutter/material.dart';
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
  BuildContext _ctx;

  bool _isLoading = false;
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
      _presenter.doLogin(_username, _password, _url);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }

  var _value = "en";
  static const ar_dropdown = 4 / 1;
  static const ar_btn = 15 / 2;
  DropdownButton _normalDown() => DropdownButton<String>(
        underline: Container(
          height: 2,
          color: Theme.of(context).textSelectionColor,
        ),
        items: [
          DropdownMenuItem(
            value: "en",
            child: AspectRatio(
              aspectRatio: ar_dropdown,
              child: Text(
                "English",
              ),
            ),
          ),
          DropdownMenuItem(
            value: "ar",
            child: AspectRatio(
              aspectRatio: ar_dropdown,
              child: Text(
                "Arabic",
              ),
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
    _ctx = context;
    var loginBtn = AspectRatio(
      aspectRatio: ar_btn,
      child: new RaisedButton(
        onPressed: _submit,
        child: new Text(MyLocalizations.of(context, 'LOGIN')),
        color: Theme.of(context).buttonColor,
      ),
    );
    var loginForm = <Widget>[
      new Image.asset("assets/images/logo.png", fit: BoxFit.cover),
      new Form(
        key: formKey,
        child: new Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                onSaved: (val) => _username = val,
                decoration: new InputDecoration(
                  labelText: MyLocalizations.of(context, 'Username'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                onSaved: (val) => _password = val,
                decoration: new InputDecoration(
                  labelText: MyLocalizations.of(context, 'Password'),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new TextFormField(
                onSaved: (val) => _url = val,
                decoration: new InputDecoration(
                  labelText: MyLocalizations.of(context, 'URL'),
                  hintText: "http://example.com",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            _normalDown(),
            SizedBox(
              height: 15,
            )
          ],
        ),
      ),
      _isLoading ? new CircularProgressIndicator() : loginBtn
    ];

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: loginForm,
        ),
      ),
    );
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
