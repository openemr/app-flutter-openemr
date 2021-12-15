import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/utils/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import './local_widgets/custom_dropdown_field.dart';

class AddPatientScreen extends StatefulWidget {
  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  User user;

  final formKey = new GlobalKey<FormState>();
  String _title = "Mr.",
      _fname,
      _mname,
      _lname,
      _dob,
      _sex = "Male",
      _street,
      _postalCode,
      _city,
      _state,
      _countryCode,
      _phoneContact,
      _race,
      _ethnicity;

  int currentStep = 0;
  bool complete = false;

  next() {
    if (currentStep + 1 != 3) {
      goTo(currentStep + 1);
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
    if (currentStep == 2) {
      setState(() => complete = true);
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Patient'),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        backgroundColor: GFColors.LIGHT,
        body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stepper(
                  currentStep: currentStep,
                  onStepContinue: next,
                  onStepTapped: (step) => goTo(step),
                  onStepCancel: cancel,
                  steps: [
                    Step(
                      title: Text('Primary Info'),
                      isActive: currentStep == 0,
                      content: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          CustomDropdownField(
                            label: 'Title',
                            options: ['Mr.', 'Mrs.', 'Ms.', 'Dr.'],
                            updateValue: (text) {
                              _title = text;
                            },
                            value: _title,
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
                          CustomDropdownField(
                            label: 'Gender',
                            options: ['Male', 'Female'],
                            updateValue: (text) {
                              _sex = text;
                            },
                            value: _sex,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: Text('Address'),
                      isActive: currentStep == 1,
                      content: Column(
                        children: [
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter street name';
                                }
                                return null;
                              },
                              onSaved: (val) => _street = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Street',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter postal code';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              onSaved: (val) => _postalCode = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Postal Code',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter city name';
                                }
                                return null;
                              },
                              onSaved: (val) => _city = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'City',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter state name';
                                }
                                return null;
                              },
                              onSaved: (val) => _state = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'State',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter country code';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              onSaved: (val) => _countryCode = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Country Code',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                return null;
                              },
                              onSaved: (val) => _phoneContact = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Phone Number',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      state: StepState.complete,
                      isActive: currentStep == 2,
                      title: Text('Other Details'),
                      content: Column(
                        children: [
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter race';
                                }
                                return null;
                              },
                              onSaved: (val) => _race = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Race',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter ethnicity';
                                }
                                return null;
                              },
                              onSaved: (val) => _ethnicity = val,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ethnicity',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GFButton(
                onPressed: !complete ? null : () => submit(context),
                text: 'Add Patient',
                color: GFColors.DARK,
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
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
          .addPatient(
        baseUrl: baseUrl,
        token: token,
        title: _title.trim(),
        fname: _fname.trim(),
        mname: _mname.trim(),
        lname: _lname.trim(),
        dob: _dob.trim(),
        sex: _sex.trim(),
        street: _street.trim(),
        postalcode: _postalCode.trim(),
        city: _city.trim(),
        state: _state.trim(),
        countrycode: _countryCode.trim(),
        phonecontact: _phoneContact.trim(),
        race: _race.trim(),
        ethnicity: _ethnicity.trim(),
      )
          .then(
        (res) {
          if (res != null && res["pid"] != null) {
            form.reset();
            _showSnackBar("Patient has been added");
          } else {
            _showSnackBar("Some error occured");
          }
        },
      ).catchError((Object error) => _showSnackBar(error.toString()));
    }
  }
}
