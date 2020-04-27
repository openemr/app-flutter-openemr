import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:openemr/models/patient.dart';
import 'package:openemr/presenter/patient_list_presenter.dart';

class PatientList extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<PatientList> implements PatientListContract {
  TextEditingController editingController = TextEditingController();
  PatientListPresenter _presenter;
  String filterQuery = "";
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Patient> patientList = new List<Patient>();

  _MyAppState() {
    _presenter = new PatientListPresenter(this);
    _presenter.getAllPatients();
  }
  bool contains(text, query) {
    if (text
        .toString()
        .trim()
        .toLowerCase()
        .contains(query.toString().trim().toLowerCase())) {
      return true;
    }
    return false;
  }

  List<List<Patient>> filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Patient> dummyListData = List<Patient>();
      patientList.forEach((item) {
        var name = item.fname +
            (item.fname == "" ? "" : " ") +
            item.mname +
            (item.mname == "" ? "" : " ") +
            item.lname;
        if (contains(name, query) ||
            contains(item.phone_contact, query) ||
            contains(item.dob, query)) {
          dummyListData.add(item);
        }
      });
      return [[], [], dummyListData];
    } else {
      return [[], [], patientList];
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    List<List<Patient>> filteredList = filterSearchResults(filterQuery);
    List<Patient> pinnedRecord = filteredList[0];
    List<Patient> recentlyActive = filteredList[1];
    List<Patient> allRecord = filteredList[2];
    var l1 = pinnedRecord.length,
        l2 = recentlyActive.length,
        l3 = allRecord.length;
    var tl = l1 + l2 + l3;
    var s3 = tl - l3;
    var s2 = s3 - l2;
    var s1 = s2 - l1;
    return new GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            key: scaffoldKey,
            appBar: new AppBar(
              automaticallyImplyLeading: true,
              title: new Text('Patient List'),
            ),
            body: Container(
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        filterQuery = value;
                      });
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)))),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tl,
                    itemBuilder: (context, index) {
                      Patient pat = allRecord[index];
                      return Column(children: <Widget>[
                        if (l1 != 0 && s1 == index)
                          Text("Pinned Records",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                        if (l2 != 0 && s2 == index)
                          Text("Recently Active",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                        if (l3 != 0 && s3 == index)
                          Text("All Records",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24)),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                FaIcon(
                                  pat.sex == "Female"
                                      ? FontAwesomeIcons.female
                                      : FontAwesomeIcons.male,
                                  color: Theme.of(context).disabledColor,
                                  size: 70.0,
                                  semanticLabel: 'Patient List',
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 5.0, 0.0, 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          pat.fname + " " + pat.lname,
                                          style: TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Tooltip(
                                            padding: EdgeInsets.all(10.0),
                                            message:
                                                "Home Phone\nClick to call",
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                      width: 30,
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .phoneAlt,
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        size: Theme.of(context)
                                                            .iconTheme
                                                            .size,
                                                        semanticLabel:
                                                            'Home Phone',
                                                      )),
                                                  Text(
                                                    pat.phone_contact != ''
                                                        ? pat.phone_contact
                                                        : "Not Found",
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )
                                                ],
                                              ),
                                            )),
                                        Tooltip(
                                            padding: EdgeInsets.all(10.0),
                                            message: "Date of Birth",
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                      width: 30,
                                                      child: FaIcon(
                                                        FontAwesomeIcons
                                                            .calendar,
                                                        color: Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                        size: Theme.of(context)
                                                            .iconTheme
                                                            .size,
                                                        semanticLabel:
                                                            'Date of Birth',
                                                      )),
                                                  Text(
                                                    pat.dob != ""
                                                        ? pat.dob
                                                        : "Not Found",
                                                    style: TextStyle(
                                                        fontSize: 18.0),
                                                  )
                                                ],
                                              ),
                                            )),
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        )
                      ]);
                    },
                  ),
                ),
              ]),
            )));
  }

  @override
  void mapData(List<Patient> list) async {
    setState(() {
      patientList = list;
    });
  }

  void onError(String errorTxt) {
    _showSnackBar(errorTxt);
  }
}
