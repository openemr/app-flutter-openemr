import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openemr/screens/telehealth/chat.dart';
import 'package:openemr/screens/telehealth/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Telehealth extends StatefulWidget {
  @override
  _TelehealthState createState() => _TelehealthState();
}

class _TelehealthState extends State<Telehealth>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _store = Firestore.instance;

  FirebaseUser user;
  String userId;
  var listToShow = [
    'T 0',
    'T 1',
    'T 2',
    'T 3',
    'T 4',
    'T 5',
    'T 6',
    'T 7',
    'T 8',
    'T 9',
    'T 10',
    'T 11',
    'T 12',
    'T 13',
    'T 14',
    'T 15',
    'T 16',
    'T 17',
    'T 18',
    'T 19',
  ];

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  List directory;
  List activeChats;

  TabController tabController;

  @override
  void initState() {
    super.initState();
    getInfo();
    tabController = TabController(length: 4, vsync: this);
  }

  getInfo() async {
    directory = [];
    activeChats = [];
    userId = "";
    user = await _auth.currentUser();
    QuerySnapshot docs = await _store.collection('username').getDocuments();
    docs.documents.forEach((element) {
      if (element.documentID == user.uid) {
        userId = element["id"];
      } else {
        directory.add(element.data);
      }
    });

    QuerySnapshot fetchedChats = await _store
        .collection('chats')
        .where(userId, isEqualTo: true)
        .getDocuments();
    if (fetchedChats != null) {
      fetchedChats.documents.forEach((element) {
        var x = element.data;
        element.data["names"].forEach((key, value) {
          if (key != userId) {
            x["targetName"] = value;
          }
        });
        x["documentId"] = element.documentID;
        activeChats.add(x);
      });
    }

    this.setState(() {
      activeChats = activeChats;
      directory = directory;
      user = user;
      userId = userId;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool fav = false;

  startChat(context, targetUser) async {
    var messagesId = "";
    var chatDocumentId = "";
    QuerySnapshot chats = await _store
        .collection('chats')
        .where(userId, isEqualTo: true)
        .where(targetUser["id"], isEqualTo: true)
        .snapshots()
        .first;

    if (chats.documents.isEmpty) {
      DocumentReference mesref = await _store.collection('messages').add({});
      DocumentReference chatref = await _store.collection('chats').add({
        userId: true,
        targetUser["id"]: true,
        "messageId": mesref.documentID,
        "names": {
          userId: user.displayName,
          targetUser["id"]: targetUser["name"]
        }
      });
      messagesId = mesref.documentID;
      chatDocumentId = chatref.documentID;
    } else {
      messagesId = chats.documents[0].data["messageId"];
      chatDocumentId = chats.documents[0].documentID;
    }
    if (messagesId != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChatScreen(
                  messagesId: messagesId,
                  heading: targetUser["name"],
                  userId: userId,
                  userName: user.displayName,
                  chatDocumentId: chatDocumentId,
                )),
      );
    } else {
      _showSnackBar("Chat id can't be generated");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: GFColors.DARK,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              CupertinoIcons.back,
              color: GFColors.SUCCESS,
            ),
          ),
          title: const Text(
            'Telehealth',
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: getInfo,
              icon: Icon(
                Icons.refresh,
                color: GFColors.PRIMARY,
              ),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              tooltip: "Logout",
              color: GFColors.DANGER,
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              },
            ),
          ],
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: GFTabBarView(
              controller: tabController,
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      GFCard(
                        boxFit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.67), BlendMode.darken),
                        image: Image.asset(
                          'lib/assets/images/image1.png',
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitWidth,
                        ),
                        titlePosition: GFPosition.end,
                        title: GFListTile(
                          avatar: const GFAvatar(
                            backgroundImage:
                                AssetImage('lib/assets/images/avatar8.png'),
                          ),
                          titleText: user != null
                              ? user.displayName != null
                                  ? user.displayName
                                  : "Use edit icon on left to update"
                              : "Invalid User",
                          icon: GFIconButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FirebaseProfileScreen()),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: GFColors.DANGER,
                            ),
                            type: GFButtonType.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  itemCount: activeChats.length,
                  itemBuilder: (context, i) {
                    var chatDetail = activeChats[i];
                    return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundImage:
                            AssetImage('lib/assets/images/avatar11.png'),
                      ),
                      titleText: chatDetail["targetName"],
                      subtitleText: chatDetail["lastMessage"] == null
                          ? ""
                          : chatDetail["lastMessage"],
                      icon: GFIconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => ChatScreen(
                                      messagesId: chatDetail["messageId"],
                                      heading: chatDetail["targetName"],
                                      userId: userId,
                                      userName: user.displayName,
                                      chatDocumentId: chatDetail["documentId"],
                                    )),
                          );
                        },
                        icon: Icon(
                          Icons.message,
                          color: GFColors.FOCUS,
                        ),
                        type: GFButtonType.transparent,
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: listToShow.length,
                  itemBuilder: (context, i) {
                    return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundImage:
                            AssetImage('lib/assets/images/avatar11.png'),
                      ),
                      titleText: 'Title',
                      subtitleText: '2 minute',
                      icon: GFIconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.call,
                          color: GFColors.PRIMARY,
                        ),
                        type: GFButtonType.transparent,
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: directory.length,
                  itemBuilder: (context, i) {
                    var targetUser = directory[i];
                    return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundImage:
                            AssetImage('lib/assets/images/avatar11.png'),
                      ),
                      titleText: targetUser["name"],
                      subtitleText: targetUser["id"],
                      icon: GFIconButton(
                        onPressed: () => startChat(context, targetUser),
                        icon: Icon(
                          Icons.message,
                          color: GFColors.FOCUS,
                        ),
                        type: GFButtonType.transparent,
                      ),
                    );
                  },
                )
              ],
            )),
        bottomNavigationBar: Container(
          child: GFTabBar(
            length: 1,
            controller: tabController,
            tabs: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person,
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.chat,
                  ),
                  const Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.call,
                  ),
                  const Text(
                    'Calls',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.contacts,
                  ),
                  const Text(
                    'Directory',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ],
            indicatorColor: GFColors.SUCCESS,
            labelColor: GFColors.SUCCESS,
            labelPadding: const EdgeInsets.all(8),
            tabBarColor: GFColors.DARK,
            unselectedLabelColor: GFColors.WHITE,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.white,
              fontFamily: 'OpenSansBold',
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.black,
              fontFamily: 'OpenSansBold',
            ),
          ),
        ),
      );
}
