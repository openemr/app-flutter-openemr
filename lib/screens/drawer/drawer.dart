import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import '../../screens/drawer/webview.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) => GFDrawer(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [Color(0xFFD685FF), Color(0xFF7466CC)])),
              height: 250,
              child: GFDrawerHeader(
                closeButton: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    color: GFColors.SUCCESS,
                  ),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xFFD685FF), Color(0xFF7466CC)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GFAvatar(
                      backgroundColor: GFColors.DARK,
                      shape: GFAvatarShape.square,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      backgroundImage: AssetImage(
                        'lib/assets/images/gflogo.png',
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'OpenEMR',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'open-emr.org',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
              ),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const WebViews(
                              url: 'https://github.com/openemr/openemr'),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: GFListTile(
                        avatar: Icon(Icons.store),
                        title: Text('Main Repository',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const WebViews(
                              url:
                                  'https://github.com/openemr/app-flutter-openemr/blob/master/README.md'),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: GFListTile(
                        avatar: Icon(CupertinoIcons.eye_solid),
                        title: Text('Documentation',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                    ),
                  ),
                  Divider(color: GFColors.FOCUS, indent: 20, endIndent: 30),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text("Last update: 04/08/21"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text("v2.2"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
