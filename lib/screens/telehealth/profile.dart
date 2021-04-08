import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import '../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProfileScreen extends StatefulWidget {
  //user's current display name
  final String dispName;
  FirebaseProfileScreen({Key key, @required this.dispName}) : super(key: key);
  @override
  _FirebaseProfileScreenState createState() => _FirebaseProfileScreenState();
}

class _FirebaseProfileScreenState extends State<FirebaseProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;
  User user;

  final formKey = new GlobalKey<FormState>();
  String _name;

  //decides when to active/inactive spinner indicator
  bool showSpinner = false;

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context)
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
        backgroundColor: GFColors.LIGHT,
        body: ModalProgressHUD(
          // color: Colors.blueAccent,
          inAsyncCall: showSpinner,
          child: Padding(
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
                          //set initial value as the dispName
                          initialValue: widget.dispName,
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
          ),
        ),
      ),
    );
  }

  void updateProfile(context) async {
    //start showing the spinner
    setState(() {
      showSpinner = true;
    });
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
        //stop showing the spinner
        setState(() {
          showSpinner = false;
        });
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
      //stop showing the spinner
      setState(() {
        showSpinner = false;
      });
      _showSnackBar(errorMessage);
      return null;
    }
    await _store
        .collection('username')
        .document(user.uid)
        .updateData({"name": _name});
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Telehealth()),
        (route) => false);
    //stop showing the spinner
    setState(() {
      showSpinner = false;
    });
  }
}
