import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/models/user.dart';
import 'package:openemr/screens/codescanner/codescanner.dart';
import 'package:openemr/screens/login/login2.dart';
import 'package:openemr/screens/medicine/medicine_recognition_ML_Kit.dart';
import 'package:openemr/screens/patientList/patient_list.dart';
import 'package:openemr/screens/ppg/heartRate.dart';
import 'package:openemr/screens/telehealth/telehealth.dart';
import 'package:openemr/utils/rest_ds.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/drawer/drawer.dart';
import 'login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userRef = Firestore.instance.collection('username');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firebaseFlag = false;
  List gfComponents = [
    {
      'icon': CupertinoIcons.heart_solid,
      'title': 'PPG',
      'route': PPG(),
    },
    {
      'icon': Icons.video_call,
      'title': 'Telehealth',
      'authentication': "firebase",
      'failRoute': LoginFirebaseScreen(),
      'route': Telehealth(),
    },
    {
      'icon': Icons.people,
      'title': 'Patient List',
      'route': PatientListPage(),
      'authentication': "webapp",
      'failRoute': LoginScreen(),
    },
    {
      'icon': Icons.translate,
      'title': 'Medicine Recognition',
      'route': MedicineRecognitionMLKit(),
    },
    {
      'icon': Icons.scanner,
      'title': 'Code scanner',
      'route': CodeScanner(),
    },
  ];

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

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
                left: 15,
                bottom: 20,
                top: 20,
                right: 15,
              ),
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
                  gfComponents[index]['failRoute'],
                  gfComponents[index]['disabled'] ?? false,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildSquareTile(
    String title,
    IconData icon,
    Widget route,
    String auth,
    Widget failRoute,
    bool disabled,
  ) =>
      InkWell(
        onTap: !disabled
            ? () async {
                if (auth == "webapp") {
                  final prefs = await SharedPreferences.getInstance();
                  var username = prefs.getString('username');
                  var password = prefs.getString('password');
                  var url = prefs.getString('baseUrl');
                  RestDatasource api = new RestDatasource();
                  api.login(username, password, url).then((User user) {
                    prefs.setString(
                        'token', user.tokenType + " " + user.accessToken);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => route),
                    );
                  }).catchError((Object error) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => failRoute),
                    );
                  });
                } else if (auth == "firebase") {
                  if (firebaseFlag) {
                    var user = await _auth.currentUser();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var loggedUserId = prefs.getString('loggedUserId');

                    if (user != null && user.isEmailVerified) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => route),
                      );
                    } else if (user != null && loggedUserId != null) {
                      DocumentSnapshot documentSnapshot =
                          await userRef.document(loggedUserId).get();
                      if (documentSnapshot.exists) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => route),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => failRoute),
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => failRoute),
                      );
                    }
                  } else {
                    _showSnackBar("Check readme to enable firebase");
                  }
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => route),
                  );
                }
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
            color: !disabled ? Color(0xFF333333) : Colors.grey[500],
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.61),
                blurRadius: 6,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(
                icon,
                color: !disabled
                    ? GFColors.SUCCESS
                    : Colors.white.withOpacity(0.7),
                size: 30,
              ),
//            Icon((icon),),
              Text(title,
                  style: const TextStyle(color: GFColors.WHITE, fontSize: 20),
                  textAlign: TextAlign.center)
            ],
          ),
        ),
      );
}
