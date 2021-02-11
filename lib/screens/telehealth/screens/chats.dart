import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/screens/telehealth/chat.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';

class Chats extends StatefulWidget {
  final FirebaseUser user;

  Chats(this.user);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _db
          .collection('chats')
          .where(widget.user.uid, isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customListLoadingShimmer(context, listLength: 5);
        }
        if (!snapshot.hasData) {
          return Container();
        }
        var chats = [];
        final docs = snapshot.data.documents;
        docs.forEach((element) {
          var x = element.data;
          element.data["names"].forEach((key, value) {
            if (key != widget.user.uid) {
              x["targetName"] = value;
            }
          });
          x["documentId"] = element.documentID;
          chats.add(x);
        });
        return ListView.builder(
          itemCount: chats.length,
          itemBuilder: (context, i) {
            var chatDetail = chats[i];
            return GFListTile(
              avatar: GFAvatar(
                shape: GFAvatarShape.circle,
                backgroundImage: AssetImage('lib/assets/images/avatar11.png'),
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
                        userId: widget.user.uid,
                        userName: widget.user.displayName,
                        chatDocumentId: chatDetail["documentId"],
                      ),
                    ),
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
        );
      },
    );
  }
}
