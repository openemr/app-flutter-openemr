import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';

class CreateAccount extends StatefulWidget {
  final FirebaseUser dispUser;

  CreateAccount({Key key, @required this.dispUser}) : super(key: key);
  @override
  _CreateAccountBuyerState createState() => _CreateAccountBuyerState();
}

class _CreateAccountBuyerState extends State<CreateAccount> {
  final userRef = Firestore.instance.collection('username');
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _userid;

  void _toggleLoadingStatus(bool newLoadingState) {
    setState(() {
      _isLoading = newLoadingState;
    });
  }

  handleRegister(context) async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _toggleLoadingStatus(true);
      await userRef.document(widget.dispUser.uid).setData({
        "id": _userid,
        "name": widget.dispUser.displayName,
      });

      _toggleLoadingStatus(false);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Telehealth()));
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: GFColors.LIGHT,
        body: Padding(
          padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                            loadingMessage: 'Creating Account', listLength: 4)
                        : Column(
                            children: [
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
                              GFButton(
                                onPressed: () => handleRegister(context),
                                text: 'Register',
                                color: GFColors.DARK,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
