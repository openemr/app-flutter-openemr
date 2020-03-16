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
    if(state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/home");
  }
  var _value = "en";
  DropdownButton _normalDown() => DropdownButton<String>(
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
    _ctx = context;
    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text(MyLocalizations.of(context, 'LOGIN')),
      color: Colors.primaries[0],
    );
    var loginForm = new Column(
      children: <Widget>[
        new Image.asset("assets/images/logo.png", fit: BoxFit.cover),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 10
                        ? "Username must have atleast 12 chars"
                        : null;
                  },
                  decoration: new InputDecoration(
                      labelText: MyLocalizations.of(context, 'Username')),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(
                      labelText: MyLocalizations.of(context, 'Password')),
                  obscureText: true,
                  validator: (val) {
                    return val.length < 10
                        ? "Password must have atleast 12 chars"
                        : null;
                  },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _url = val,
                  decoration: new InputDecoration(
                      labelText: MyLocalizations.of(context, 'URL')),
                ),
              ),
              _normalDown()
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/images/bg.png"), fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: loginForm,
                height: 490.0,
                width: 400.0,
                padding: EdgeInsets.all(16.0),
                decoration: new BoxDecoration(
                    color: Colors.teal.shade200.withOpacity(0.5)),
              ),
            ),
          ),
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
