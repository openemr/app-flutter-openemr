import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:openemr/interface/home/navigationMenu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isCollapsed = true;
  double screenHight, screenWidth;
  final Duration duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHight = size.height;
    screenWidth = size.width;
    return new Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFcb2d3e), Color(0xFFef473a)]),
      ),
      child: Stack(
        children: <Widget>[
          NavigationMenu(context),
          Dashboard(context),
        ],
      ),
    ));
  }

  Widget NavigationMenu(context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/patientList");
              },
              child: FaIcon(
                FontAwesomeIcons.plusCircle,
                color: Colors.white,
                size: 60.0,
              ),
            ),
            SizedBox(height: 30),
            FaIcon(
              FontAwesomeIcons.userAstronaut,
              color: Colors.white,
              size: 60.0,
            ),
            SizedBox(height: 30),
            FaIcon(
              FontAwesomeIcons.comment,
              color: Colors.white,
              size: 60.0,
            ),
            SizedBox(height: 30),
            FaIcon(
              FontAwesomeIcons.qrcode,
              color: Colors.white,
              size: 60.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget Dashboard(context) {
    return AnimatedPositioned(
      duration: duration,
      top: isCollapsed ? 0 : 0.075 * screenHight,
      bottom: isCollapsed ? 0 : 0.075 * screenWidth,
      left: isCollapsed ? 0 : 0.250 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 8,
        color: Colors.white,
        child: Container(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                AppBar(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  leading: InkWell(
                      child: Icon(
                        Icons.menu,
                      ),
                      onTap: () {
                        setState(() {
                          isCollapsed = !isCollapsed;
                        });
                      }),
                  title: Text("OpenEMR"),
                  centerTitle: true,
                ),
                Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 10.0),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Manage Patient",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Container(
                              height: 125.0,
                              child: new ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Card(
                                      elevation: 5,
                                      child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons.plusCircle,
                                                  color: Colors.pink,
                                                  size: 70.0,
                                                  semanticLabel:
                                                      'Add New Patient',
                                                ),
                                                Text("Add New Patient",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ))),
                                  Card(
                                      elevation: 5,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed("/patientList");
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons
                                                      .userAstronaut,
                                                  color: Colors.pink,
                                                  size: 70.0,
                                                  semanticLabel: 'Patient List',
                                                ),
                                                Text("Patient List",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ))),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ))),
                Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 10.0),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Teleheath",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Container(
                              height: 125.0,
                              child: new ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.comment,
                                              color: Colors.pink,
                                              size: 70.0,
                                              semanticLabel: 'Chat',
                                            ),
                                            Text("Chat",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ))),
                Card(
                    elevation: 5,
                    margin: EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 10.0),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Tools",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Container(
                              height: 125.0,
                              child: new ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  Card(
                                      elevation: 5,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed("/qrCode");
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Column(
                                              children: <Widget>[
                                                FaIcon(
                                                  FontAwesomeIcons.qrcode,
                                                  color: Colors.pink,
                                                  size: 70.0,
                                                  semanticLabel:
                                                      'Scan QR/Barcode',
                                                ),
                                                Text("Scan QR/Barcode",
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ],
                                            ),
                                          ))),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                  Card(
                                      elevation: 5,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.waze,
                                              color: Colors.grey,
                                              size: 70.0,
                                              semanticLabel: 'Coming Soon',
                                            ),
                                            Text("Coming soon",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ))),
              ]),
        ),
      ),
    );
  }
}
