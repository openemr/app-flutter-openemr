import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';

class Telehealth extends StatefulWidget {
  @override
  _TelehealthState createState() => _TelehealthState();
}

class _TelehealthState extends State<Telehealth>
    with SingleTickerProviderStateMixin {
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

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool fav = false;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                          titleText: 'Amit Meena',
                          subtitleText: 'Nurse',
                        ),
                      ),
                    ],
                  ),
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
                      subtitleText: 'Hello world',
                      icon: GFIconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.cancel,
                          color: GFColors.DANGER,
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
                  itemCount: listToShow.length,
                  itemBuilder: (context, i) {
                    return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundImage:
                            AssetImage('lib/assets/images/avatar11.png'),
                      ),
                      titleText: 'Title',
                      subtitleText: 'Hello world',
                      icon: GFIconButton(
                        onPressed: null,
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
