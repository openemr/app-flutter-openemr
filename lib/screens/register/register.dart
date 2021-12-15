import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:openemr/screens/login/create_account.dart';
import 'package:openemr/screens/login/login2.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userRef = Firestore.instance.collection('username');
  User user;
  bool _isLoading = false;

  final formKey = new GlobalKey<FormState>();
  String _email, _password, _name, _userid;

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => LoginFirebaseScreen()),
    );
  }

  void handleRegister(context) async {
    FirebaseUser user;
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _toggleLoadingStatus(true);
      QuerySnapshot ref = await _store
          .collection('username')
          .where("id", isEqualTo: _userid)
          .snapshots()
          .first;
      if (ref.documentChanges.isNotEmpty) {
        _toggleLoadingStatus(false);
        _showSnackBar("Username already exist");
        return null;
      }
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
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
    await _store
        .collection('username')
        .document(user.uid)
        .setData({"id": _userid, "name": _name});
    try {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = _name;
      await user.updateProfile(updateInfo);
    } catch (error) {
      if (error.message != null) {
        _showSnackBar(error.message);
      } else {
        _showSnackBar('An unexpected error occured!');
      }
      return null;
    }
    await user.sendEmailVerification();
    await _auth.signOut();
    _toggleLoadingStatus(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LoginFirebaseScreen(
            snackBarMessage:
                'A verification link has been sent to your e-mail account'),
      ),
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
