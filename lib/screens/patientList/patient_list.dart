import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:openemr/models/patient.dart';
import 'package:openemr/screens/addpatient/add_patient.dart';
import 'package:openemr/utils/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientListPage extends StatefulWidget {
  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  @override
  void initState() {
    fetchList();
    super.initState();
  }

  fetchList() async {
    historyPatientId = [];
    starredPatientId = [];

    patientList = [];
    historyPatientList = [];
    starredPatientList = [];

    RestDatasource api = new RestDatasource();
    final prefs = await SharedPreferences.getInstance();
    historyPatientId = prefs.getStringList("historyPatient") == null
        ? []
        : prefs.getStringList("historyPatient");
    starredPatientId = prefs.getStringList("starredPatient") == null
        ? []
        : prefs.getStringList("starredPatient");
    api
        .getPatientList(prefs.getString('baseUrl'), prefs.getString('token'))
        .then((List<Patient> list) {
      list.forEach((element) {
        if (historyPatientId.indexOf(element.pid) != -1) {
          historyPatientList.add(element);
        }
        if (starredPatientId.indexOf(element.pid) != -1) {
          starredPatientList.add(element);
        }
      });
      setState(() {
        starredPatientList = starredPatientList;
        historyPatientList = historyPatientList;
        patientList = list;
      });
    }).catchError((Object error) => print(error.toString()));
  }

  List<String> historyPatientId = [];
  List<String> starredPatientId = [];

  List patientList = [];
  List historyPatientList = [];
  List starredPatientList = [];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: GFAppBar(
          backgroundColor: GFColors.DARK,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(
                  CupertinoIcons.back,
                  color: GFColors.SUCCESS,
                ),
              )),
          title: const Text(
            'Patient List',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              tooltip: "Refresh",
              color: GFColors.SUCCESS,
              onPressed: fetchList,
            ),
            IconButton(
              icon: Icon(Icons.add),
              tooltip: "Add Patient",
              color: GFColors.SUCCESS,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AddPatientScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Logout",
              color: GFColors.DANGER,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                prefs.remove('username');
                prefs.remove('password');
                prefs.remove('baseUrl');
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            )
          ],
        ),
        body: ListView(
          physics: const ScrollPhysics(),
          children: <Widget>[
            GFSearchBar(
                searchList: patientList,
                searchQueryBuilder: (query, list) => list
                    .where((item) =>
                        item.fname.toLowerCase().contains(query.toLowerCase()))
                    .toList(),
                overlaySearchListItemBuilder: (item) => Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.fname,
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                onItemSelected: (item) async {
                  if (item != null) {
                    final prefs = await SharedPreferences.getInstance();
                    historyPatientId.remove(item.pid.toString());
                    historyPatientId.insert(0, item.pid.toString());
                    historyPatientList.remove(item);
                    historyPatientList.insert(0, item);
                    prefs.setStringList("historyPatient", historyPatientId);
                    if (historyPatientList.length > 10) {
                      historyPatientList.removeLast();
                    }
                  }
                  this.setState(() {
                    historyPatientList = historyPatientList;
                  });
                }),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
              child: GFTypography(
                text: 'Starred Patient',
                type: GFTypographyType.typo5,
                dividerWidth: 25,
                dividerColor: Color(0xFF19CA4B),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: starredPatientList.length,
              itemBuilder: (item, i) {
                Patient p = starredPatientList[i];
                return GFListTile(
                  titleText: p.fname + " " + p.lname,
                  subtitleText: p.sex,
                  icon: GFIconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      starredPatientId.remove(p.pid.toString());
                      starredPatientList.remove(p);
                      prefs.setStringList("starredPatient", starredPatientId);
                      this.setState(() {
                        starredPatientList = starredPatientList;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: GFColors.DANGER,
                    ),
                    type: GFButtonType.transparent,
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
              child: GFTypography(
                text: 'History',
                type: GFTypographyType.typo5,
                dividerWidth: 25,
                dividerColor: Color(0xFF19CA4B),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: historyPatientList.length,
              itemBuilder: (item, i) {
                Patient p = historyPatientList[i];
                return GFListTile(
                  titleText: (p.fname != null ? p.fname + " " : "") +
                      (p.mname != null ? p.mname + " " : "") +
                      (p.lname != null ? p.lname + " " : ""),
                  subtitleText: p.sex,
                  icon: GFIconButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      starredPatientId.insert(0, p.pid.toString());
                      starredPatientList.insert(0, p);
                      prefs.setStringList("starredPatient", starredPatientId);
                      this.setState(() {
                        starredPatientList = starredPatientList;
                      });
                    },
                    icon: Icon(
                      Icons.star_border,
                      color: GFColors.DANGER,
                    ),
                    type: GFButtonType.transparent,
                  ),
                );
              },
            ),
          ],
        ),
      );
}
