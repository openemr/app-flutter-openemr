import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/utils/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  User user;

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _fname, _lname, _mname, _title = "Mr.", _dob, _sex = "Male";

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
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      ListTile(
                        title: const Text('Mr.'),
                        leading: Radio(
                          value: "Mr.",
                          groupValue: _title,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Mrs.'),
                        leading: Radio(
                          value: "Mrs.",
                          groupValue: _title,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Ms.'),
                        leading: Radio(
                          value: "Ms.",
                          groupValue: _title,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Dr.'),
                        leading: Radio(
                          value: "Dr.",
                          groupValue: _title,
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter first name';
                            }
                            return null;
                          },
                          onSaved: (val) => _fname = val,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'First Name'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter middle name';
                            }
                            return null;
                          },
                          onSaved: (val) => _mname = val,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Middle Name'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter middle name';
                            }
                            return null;
                          },
                          onSaved: (val) => _lname = val,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Last Name'),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        child: TextFormField(
                          validator: (value) {
                            final dobFormat = RegExp(
                                r'[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]');
                            if (value.isEmpty) {
                              return 'Please enter date of birth';
                            }
                            if (!dobFormat.hasMatch(value)) {
                              return "Invalid date of birth, use (YYYY-DD-MM)";
                            }
                            return null;
                          },
                          onSaved: (val) => _dob = val,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'DOB',
                              hintText: "1999-08-09"),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ListTile(
                        title: const Text('Male'),
                        leading: Radio(
                          value: "Male",
                          groupValue: _sex,
                          onChanged: (value) {
                            setState(() {
                              _sex = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Female'),
                        leading: Radio(
                          value: "Female",
                          groupValue: _sex,
                          onChanged: (value) {
                            setState(() {
                              _sex = value;
                            });
                          },
                        ),
                      ),
                      GFButton(
                        onPressed: () => submit(context),
                        text: 'Add Patient',
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

  void submit(context) async {
    final prefs = await SharedPreferences.getInstance();
    final form = formKey.currentState;
    RestDatasource api = new RestDatasource();
    if (form.validate()) {
      form.save();
      var baseUrl = prefs.getString('baseUrl');
      var token = prefs.getString('token');
      api
          .addPatient(baseUrl, token, _title.trim(), _fname.trim(),
              _mname.trim(), _lname.trim(), _dob.trim(), _sex.trim())
          .then((res) {
        if (res != null && res["pid"] != null) {
          form.reset();
          _showSnackBar("Patient has been added");
        } else {
          _showSnackBar("Some error occured");
        }
      }).catchError((Object error) => _showSnackBar(error.toString()));
    }
  }
}
