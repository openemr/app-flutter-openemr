import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openemr/models/patient.dart';
import 'package:openemr/presenter/patient_list_presenter.dart';

class PatientList extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<PatientList> implements PatientListContract {
  PatientListPresenter _presenter;
  
  List<Patient> patientList = new List<Patient>();
  _MyAppState() {
    _presenter = new PatientListPresenter(this);
    _presenter.getAllPatients();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        title: new Text('Patient List'),
      ),
      body: ListView.builder(
        itemCount: patientList.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          Patient pat = patientList[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.female,
                    color: Colors.grey,
                    size: 70.0,
                    semanticLabel: 'Patient List',
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            pat.fname + " " + pat.lname,
                            style: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                          Tooltip(
                              padding: EdgeInsets.all(10.0),
                              message: "Home Phone\nClick to call",
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 30,
                                        child: FaIcon(
                                          FontAwesomeIcons.phoneAlt,
                                          color: Colors.blue,
                                          size: 20.0,
                                          semanticLabel: 'Home Phone',
                                        )),
                                    Text(
                                      pat.phone_contact != ''
                                          ? pat.phone_contact
                                          : "Not Found",
                                      style: TextStyle(fontSize: 18.0),
                                    )
                                  ],
                                ),
                              )),
                          Tooltip(
                              padding: EdgeInsets.all(10.0),
                              message: "Date of Birth",
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width: 30,
                                        child: FaIcon(
                                          FontAwesomeIcons.calendar,
                                          color: Colors.blue,
                                          size: 20.0,
                                          semanticLabel: 'Date of Birth',
                                        )),
                                    Text(
                                      pat.dob,
                                      style: TextStyle(fontSize: 18.0),
                                    )
                                  ],
                                ),
                              )),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void mapData(List<Patient> list) async {
    setState(() {
      patientList = list;
    });
  }
}
