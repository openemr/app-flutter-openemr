import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/models/user.dart';
import 'package:openemr/screens/codescanner/codescanner.dart';
import 'package:openemr/screens/medicine/medicine_recognition.dart';
import 'package:openemr/screens/patientList/patient_list.dart';
import 'package:openemr/screens/ppg/heartRate.dart';
import 'package:openemr/screens/telehealth/chat.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import 'package:openemr/utils/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/drawer/drawer.dart';
import '../screens/shimmer/shimmer.dart';
import 'login/login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List gfComponents = [
    {'icon': CupertinoIcons.heart_solid, 'title': 'PPG', 'route': PPG()},
    {'icon': Icons.video_call, 'title': 'Telehealth', 'route': Telehealth()},
    {
      'icon': const IconData(
        0xe901,
        fontFamily: 'GFFontIcons',
      ),
      'title': 'Chats',
      'route': Chat()
    },
    {
      'icon': Icons.people,
      'title': 'Patient List',
      'route': PatientListPage(),
      'authentication': true,
      'failRoute': LoginScreen()
    },
    {
      'icon': Icons.info,
      'title': 'Medicine',
      'route': MedicineRecognitionPage()
    },
    {'icon': Icons.scanner, 'title': 'Code scanner', 'route': CodeScanner()},
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          backgroundColor: GFColors.DARK,
          title: Image.asset(
            'lib/assets/icons/gflogo.png',
            width: 150,
          ),
          centerTitle: true,
        ),
        body: ListView(
          physics: const ScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  left: 15, bottom: 20, top: 20, right: 15),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: gfComponents.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemBuilder: (BuildContext context, int index) =>
                      buildSquareTile(
                          gfComponents[index]['title'],
                          gfComponents[index]['icon'],
                          gfComponents[index]['route'],
                          gfComponents[index]['authentication'],
                          gfComponents[index]['failRoute'])),
            ),
          ],
        ),
      );

  Widget buildSquareTile(String title, IconData icon, Widget route, bool auth,
          Widget failRoute) =>
      InkWell(
        onTap: () async {
          if (auth == true) {
            final prefs = await SharedPreferences.getInstance();
            var username = prefs.getString('username');
            var password = prefs.getString('password');
            var url = prefs.getString('baseUrl');
            RestDatasource api = new RestDatasource();
            api.login(username, password, url).then((User user) {
              prefs.setString('token', user.tokenType + " " + user.accessToken);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => route),
              );
            }).catchError((Object error) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => failRoute),
              );
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => route),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.61),
                  blurRadius: 6,
                  spreadRadius: 0),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                icon,
                color: GFColors.SUCCESS,
                size: 30,
              ),
//            Icon((icon),),
              Text(
                title,
                style: const TextStyle(color: GFColors.WHITE, fontSize: 20),
              )
            ],
          ),
        ),
      );
}
