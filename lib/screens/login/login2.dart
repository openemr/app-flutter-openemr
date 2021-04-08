import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:openemr/screens/login/create_account.dart';
import 'package:openemr/screens/register/register.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginFirebaseScreen extends StatefulWidget {
  final String snackBarMessage;

  LoginFirebaseScreen({this.snackBarMessage});

  @override
  _LoginFirebaseScreenState createState() => _LoginFirebaseScreenState();
}

class _LoginFirebaseScreenState extends State<LoginFirebaseScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRef = Firestore.instance.collection('username');
  User currentUserWithInfo;
  User user;
  bool _isLoading = false;

  final formKey = new GlobalKey<FormState>();
  String _email, _password;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (widget.snackBarMessage != null) {
        _showSnackBar(widget.snackBarMessage);
      }
    });
    super.initState();
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  void _toggleLoadingStatus(bool newLoadingState) {
    setState(() {
      _isLoading = newLoadingState;
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
                                Padding(
                                  padding: EdgeInsets.only(top: 25, bottom: 25),
                                  child: Text(
                                    "-------OR--------",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.grey),
                                  ),
                                ),
                                GoogleSignInButton(
                                  onPressed: () {
                                    _toggleLoadingStatus(true);
                                    signInWithGoogle();
                                  },
                                  textStyle: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                  darkMode: true,
                                ),
                                SizedBox(
                                  height: 25,
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
    final form = formKey.currentState;
    _toggleLoadingStatus(true);
    if (form.validate()) {
      form.save();
      try {
        AuthResult result = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        user = result.user;
      } catch (error) {
        if (error.message != null) {
          _showSnackBar(error.message);
        } else {
          _showSnackBar('An unexpected error occured!');
        }
        _toggleLoadingStatus(false);
        return null;
      }
    }
    _toggleLoadingStatus(false);
    if (!user.isEmailVerified) {
      _showSnackBar("Email not verified");
      await _auth.signOut();
    } else {
      Navigator.pop(context);
    }
  }

  void handleRegister(context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => RegisterFirebaseScreen()),
    );
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    handleGSignIn(googleSignInAccount);
  }

  handleGSignIn(GoogleSignInAccount googleSignInAccount) async {
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      try {
        await createUserInFirestore(user);
      } catch (err) {
        _showSnackBar(err);
        _toggleLoadingStatus(false);
        _signOut();
      }

      shredprefUser(user.uid);

      _toggleLoadingStatus(false);
    } else {
      _showSnackBar('Please try again');
      _toggleLoadingStatus(false);
    }
  }

  Future<void> shredprefUser(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUserId', uid);
  }

  createUserInFirestore(FirebaseUser user) async {
    DocumentSnapshot documentSnapshot = await userRef.document(user.uid).get();
    //go to createAccount page - only for first reigstration
    if (!documentSnapshot.exists) {
      _toggleLoadingStatus(false);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => CreateAccount(
                dispUser: user,
              )));
    } else {
      _toggleLoadingStatus(false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Telehealth()));
    }
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await _auth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('loggedUserId');
    _toggleLoadingStatus(false);
  }
}
