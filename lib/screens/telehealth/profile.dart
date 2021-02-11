import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProfileScreen extends StatefulWidget {
  @override
  _FirebaseProfileScreenState createState() => _FirebaseProfileScreenState();
}

class _FirebaseProfileScreenState extends State<FirebaseProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;
  User user;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _name;

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
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
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Display name can\'t be blank';
                            }
                            return null;
                          },
                          onSaved: (val) => _name = val,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Display name'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GFButton(
                        onPressed: () => updateProfile(context),
                        text: 'Update',
                        color: GFColors.DARK,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void updateProfile(context) async {
    FirebaseUser user;
    String errorMessage;
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        user = await _auth.currentUser();
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
            errorMessage = error.code == null
                ? "An undefined Error happened."
                : error.code;
        }
      }
    }
    if (errorMessage != null) {
      _showSnackBar(errorMessage);
      return null;
    }
    await _store
        .collection('username')
        .document(user.uid)
        .updateData({"name": _name});
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Telehealth()),(route)=>false);
  }
}
