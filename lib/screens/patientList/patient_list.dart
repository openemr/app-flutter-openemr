import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:openemr/models/patient.dart';
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
    RestDatasource api = new RestDatasource();
    final prefs = await SharedPreferences.getInstance();
    api
        .getPatientList(prefs.getString('baseUrl'), prefs.getString('token'))
        .then((List<Patient> list) {
      setState(() {
        patientList = list;
        historyPatient = prefs.getStringList("historyPatient") == null
            ? []
            : prefs.getStringList("historyPatient");
      });
    }).catchError((Object error) => print(error.toString()));
  }

  List patientList = [];
  List<String> historyPatient = ["1"];
  bool fav = false;
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
                  final prefs = await SharedPreferences.getInstance();
                  historyPatient.remove(item.pid.toString());
                  historyPatient.insert(0,item.pid.toString());
                  prefs.setStringList("historyPatient", historyPatient);
                  print(prefs.getStringList("historyPatient"));
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
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 30, bottom: 10),
              child: GFTypography(
                text: 'History',
                type: GFTypographyType.typo5,
                dividerWidth: 25,
                dividerColor: Color(0xFF19CA4B),
              ),
            ),
          ],
        ),
      );
}
