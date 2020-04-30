import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                                              semanticLabel: 'Add New Patient',
                                            ),
                                            Text("Add New Patient",
                                                style: TextStyle(fontSize: 16)),
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
                                              FontAwesomeIcons.userAstronaut,
                                              color: Colors.pink,
                                              size: 70.0,
                                              semanticLabel: 'Patient List',
                                            ),
                                            Text("Patient List",
                                                style: TextStyle(fontSize: 16)),
                                          ],
                                        ),
                                      ))),
                              Card(
                                  elevation: 5,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("/heartRate");
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          children: <Widget>[
                                            FaIcon(
                                              FontAwesomeIcons.heartbeat,
                                              color: Colors.pink,
                                              size: 70.0,
                                              semanticLabel: 'Heart Rate',
                                            ),
                                            Text("Heart Rate",
                                                style: TextStyle(fontSize: 16)),
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
                                              semanticLabel: 'Scan QR/Barcode',
                                            ),
                                            Text("Scan QR/Barcode",
                                                style: TextStyle(fontSize: 16)),
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
    );
  }
}
