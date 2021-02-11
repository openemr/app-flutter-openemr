import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/screens/telehealth/chat.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';

class Directory extends StatelessWidget {
  final FirebaseUser user;
  final Function showSnackbarMessage;

  Directory(this.user, this.showSnackbarMessage);

  static final _db = Firestore.instance;
  final _stream = _db.collection('username').snapshots();

  void _startChat(context, targetUser) async {
    var messagesId = "";
    var chatDocumentId = "";
    QuerySnapshot chats = await _db
        .collection('chats')
        .where(user.uid, isEqualTo: true)
        .where(targetUser["id"], isEqualTo: true)
        .snapshots()
        .first;

    if (chats.documents.isEmpty) {
      DocumentReference mesref = await _db.collection('messages').add({});
      DocumentReference chatref = await _db.collection('chats').add({
        user.uid: true,
        targetUser["id"]: true,
        "messageId": mesref.documentID,
        "names": {
          user.uid: user.displayName,
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
            userId: user.uid,
            userName: user.displayName,
            chatDocumentId: chatDocumentId,
          ),
        ),
      );
    } else {
      showSnackbarMessage("Chat id can't be generated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customListLoadingShimmer(context, listLength: 5);
        }
        if (!snapshot.hasData) {
          return Container();
        }
        var directory = [];
        final docs = snapshot.data.documents;
        docs.forEach((element) {
          if (element.documentID != user.uid) {
            directory.add(element.data);
          }
        });
        return ListView.builder(
          itemCount: directory.length,
          itemBuilder: (context, i) {
            var targetUser = directory[i];
            return GFListTile(
              avatar: GFAvatar(
                shape: GFAvatarShape.circle,
                backgroundImage: AssetImage('lib/assets/images/avatar11.png'),
              ),
              titleText: targetUser["name"],
              subtitleText: targetUser["id"],
              icon: GFIconButton(
                onPressed: () => _startChat(context, targetUser),
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
