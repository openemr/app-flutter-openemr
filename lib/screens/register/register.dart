import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/screens/login/login2.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterFirebaseScreen extends StatefulWidget {
  @override
  _RegisterFirebaseScreenState createState() => _RegisterFirebaseScreenState();
}

class _RegisterFirebaseScreenState extends State<RegisterFirebaseScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  User user;
  bool _isLoading = false;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password, _name, _userid;

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
                              loadingMessage: 'Authenticating', listLength: 4)
                          : Column(
                              children: [
                                SizedBox(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _name = val,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Full Name'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Username can\'t be blank';
                                      }
                                      return null;
                                    },
                                    onSaved: (val) => _userid = val,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Username'),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                  onPressed: () => handleRegister(context),
                                  text: 'Register',
                                  color: GFColors.DARK,
                                ),
                                GFButton(
                                  onPressed: () => handleSignIn(context),
                                  text: 'login',
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => LoginFirebaseScreen()),
    );
  }

  void handleRegister(context) async {
    FirebaseUser user;
    String errorMessage;
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _toggleLoadingStatus();
      QuerySnapshot ref = await _store
          .collection('username')
          .where("id", isEqualTo: _userid)
          .snapshots()
          .first;
      if (ref.documentChanges.isNotEmpty) {
        _toggleLoadingStatus();
        _showSnackBar("Username already exist");
        return null;
      }
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        user = result.user;
      } catch (error) {
        switch (error.code) {
          case "ERROR_WEAK_PASSWORD":
            errorMessage = "Your password appears to be weak.";
            break;
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "ERROR_EMAIL_ALREADY_IN_USE":
            errorMessage = "User with this email already exist.";
            break;
          default:
            errorMessage = error.code == null
                ? "An undefined Error happened."
                : error.code;
        }
      }
    }
    if (errorMessage != null) {
      _toggleLoadingStatus();
      _showSnackBar(errorMessage);
      return null;
    }
    await _store
        .collection('username')
        .document(user.uid)
        .setData({"id": _userid, "name": _name});
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = _name;
      await user.updateProfile(updateInfo);
    } catch (error) {
      switch (error.code) {
        case "ERROR_USER_DISABLED":
          errorMessage = "Your acount has been disabled";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "Account not found";
          break;
        default:
          errorMessage =
              error.code == null ? "An undefined Error happened." : error.code;
      }
    }
    if (errorMessage != null) {
      _toggleLoadingStatus();
      _showSnackBar(errorMessage);
      return null;
    }
    await user.sendEmailVerification();
    await _auth.signOut();
    _toggleLoadingStatus();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => LoginFirebaseScreen(
              snackBarMessage:
                  'A verification link has been sent to your e-mail account')),
    );
  }
}
