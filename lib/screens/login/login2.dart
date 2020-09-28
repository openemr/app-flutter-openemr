import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/screens/register/register.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFirebaseScreen extends StatefulWidget {
  @override
  _LoginFirebaseScreenState createState() => _LoginFirebaseScreenState();
}

class _LoginFirebaseScreenState extends State<LoginFirebaseScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;
  bool _isLoading = false;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _toggleLoadingStatus() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

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
          key: scaffoldKey,
          backgroundColor: GFColors.LIGHT,
          body: Padding(
            padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Image.asset(
                        'lib/assets/images/firebase.png',
                        width: width * 0.25,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? customListLoadingShimmer(context,
                              loadingMessage: 'Authenticating', listLength: 2)
                          : Column(
                              children: [
                                SizedBox(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _email = val,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'E-mail'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _password = val,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GFButton(
                                  onPressed: () => handleSignIn(context),
                                  text: 'login',
                                  color: GFColors.DARK,
                                ),
                                GFButton(
                                  onPressed: () => handleRegister(context),
                                  text: 'Register',
                                  color: GFColors.DARK,
                                  type: GFButtonType.outline2x,
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void handleSignIn(context) async {
    FirebaseUser user;
    String errorMessage;
    final form = formKey.currentState;
    _toggleLoadingStatus();
    if (form.validate()) {
      form.save();
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        user = result.user;
      } catch (error) {
        switch (error.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Your password is wrong.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = error.code == null
                ? "An undefined Error happened."
                : error.code;
        }
      }
    }
    _toggleLoadingStatus();
    if (errorMessage != null) {
      _showSnackBar(errorMessage);
    } else {
      if (!user.isEmailVerified) {
        _showSnackBar("Email not verified");
        await _auth.signOut();
      } else {
        Navigator.pop(context);
      }
    }
  }

  void handleRegister(context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => RegisterFirebaseScreen()),
    );
  }
}
