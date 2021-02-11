import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openemr/screens/telehealth/local_widgets/profileShimmer.dart';
import 'package:openemr/screens/telehealth/profile.dart';
import 'package:openemr/screens/telehealth/screens/chats.dart';
import 'package:openemr/screens/telehealth/screens/directory.dart';
import 'package:openemr/screens/telehealth/signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:openemr/utils/system_padding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Telehealth extends StatefulWidget {
  @override
  _TelehealthState createState() => _TelehealthState();
}

class _TelehealthState extends State<Telehealth>
    with SingleTickerProviderStateMixin {
  Signaling _signaling;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _inCalling = false;
  String serverIP = "";
  List<dynamic> _peers;
  FirebaseUser user;
  String userId;
  TabController tabController;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void initState() {
    super.initState();
    getInfo();
    tabController = TabController(length: 4, vsync: this);
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    if (!(serverIP == null || serverIP == "")) {
      _localRenderer.dispose();
      _remoteRenderer.dispose();
    }
    if (_signaling != null) _signaling.close();
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = Signaling(serverIP, userId)..connect(user.displayName);

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
            });
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _peers = event['peers'];
        });
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  getInfo() async {
    userId = "";
    user = await _auth.currentUser();
    final prefs = await SharedPreferences.getInstance();
    serverIP =
        prefs.getString("webrtcIP") == null ? "" : prefs.getString("webrtcIP");
    this.setState(() {
      serverIP = serverIP;
      user = user;
      userId = userId;
    });
    if (serverIP != null && serverIP != "") {
      _connect();
      initRenderers();
    }
  }

  @override
  void dispose() {
    if (tabController != null) {
      tabController.dispose();
    }
    super.dispose();
  }

  String tempIp = "";

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  _switchCamera() {
    _signaling.switchCamera();
  }

  _invitePeer(context, peerId) async {
    print("hello");
    if (_signaling != null && peerId != userId) {
      _signaling.invite(peerId, 'video');
    }
  }

  _updateServerIp() async {
    await showDialog<String>(
      context: context,
      child: new SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  onChanged: (value) {
                    this.setState(() {
                      tempIp = value;
                    });
                  },
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Server IP', hintText: 'eg. 10.0.0.1'),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('Update'),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setString("webrtcIP", tempIp);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Telehealth()),
                  );
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _inCalling ? _inCallOptions() : null,
      body: _inCalling
          ? _inCallScreen()
          : Container(
              height: MediaQuery.of(context).size.height,
              child: user == null
                  ? profileShimmer(context)
                  : GFTabBarView(
                      controller: tabController,
                      children: <Widget>[
                        _profile(),
                        Chats(user),
                        _calls(),
                        Directory(user, _showSnackBar),
                      ],
                    ),
            ),
      bottomNavigationBar: _inCalling ? null : _tabBar(),
    );
  }

  Widget _inCallOptions() {
    return SizedBox(
      width: 200.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FloatingActionButton(
            child: const Icon(Icons.switch_camera),
            onPressed: _switchCamera,
          ),
          FloatingActionButton(
            onPressed: _hangUp,
            tooltip: 'Hangup',
            child: Icon(Icons.call_end),
            backgroundColor: Colors.pink,
          )
        ],
      ),
    );
  }

  Widget _inCallScreen() {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: RTCVideoView(_remoteRenderer),
                  decoration: BoxDecoration(color: Colors.black54),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                child: RTCVideoView(_localRenderer),
                decoration: BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _profile() {
    return Container(
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
                backgroundImage: AssetImage('lib/assets/images/avatar8.png'),
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
          GFCard(
            boxFit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.67), BlendMode.darken),
            titlePosition: GFPosition.end,
            title: GFListTile(
              titleText: "WebRTC endpoint",
              subtitleText: (serverIP == null || serverIP == "")
                  ? "Not Configured\n(Telehealth restarts on IP change)"
                  : serverIP,
              icon: GFIconButton(
                onPressed: _updateServerIp,
                icon: Icon(
                  Icons.settings,
                  color: GFColors.DANGER,
                ),
                type: GFButtonType.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calls() {
    return (_peers == null || _peers.length == 0)
        ? Center(
            child: Text(
              "Invalid Server IP\nPlease fix it under profile tab",
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: _peers.length,
            itemBuilder: (context, i) {
              var peer = _peers[i];
              var self = (peer['id'] == userId);
              return GFListTile(
                avatar: GFAvatar(
                  shape: GFAvatarShape.circle,
                  backgroundImage: AssetImage('lib/assets/images/avatar11.png'),
                ),
                titleText: peer['name'],
                subtitleText: peer['id'],
                icon: self
                    ? Text("Connected")
                    : GFIconButton(
                        onPressed: () => _invitePeer(context, peer['id']),
                        icon: Icon(
                          Icons.call,
                          color: GFColors.PRIMARY,
                        ),
                        type: GFButtonType.transparent,
                      ),
              );
            },
          );
  }

  Widget _tabBar() {
    return Container(
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
    );
  }
}
