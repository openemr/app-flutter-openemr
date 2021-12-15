import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:getwidget/getwidget.dart';
import 'package:openemr/utils/customlistloadingshimmer.dart';

class ChatScreen extends StatefulWidget {
  final String messagesId;
  final String chatDocumentId;
  final String heading;
  final String userId;
  final String userName;

  ChatScreen(
      {Key key,
      @required this.messagesId,
      @required this.heading,
      @required this.userId,
      @required this.userName,
      @required this.chatDocumentId})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();
  final Firestore _store = Firestore.instance;
  ChatUser chatUser;
  final picker = ImagePicker();

  List<ChatMessage> messages = List<ChatMessage>.empty(growable: true);
  var m = List<ChatMessage>.empty(growable: true);

  var i = 0;

  @override
  void initState() {
    chatUser = ChatUser(
      name: widget.userName,
      uid: widget.userId,
    );
    this.setState(() {
      chatUser = chatUser;
    });
    super.initState();
  }

  void systemMessage() {
    Timer(Duration(milliseconds: 300), () {
      if (i < 6) {
        setState(() {
          messages = [...messages, m[i]];
        });
        i++;
      }
      Timer(Duration(milliseconds: 300), () {
        _chatViewKey.currentState.scrollController
          ..animateTo(
            _chatViewKey.currentState.scrollController.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
      });
    });
  }

  void onSend(ChatMessage message) async {
    print(message.toJson());
    await _store.collection('messages').document(widget.messagesId).updateData({
      "messages": FieldValue.arrayUnion([message.toJson()])
    });
    if (message.text != null && message.text != "") {
      _store
          .collection('chats')
          .document(widget.chatDocumentId)
          .updateData({"lastMessage": message.text});
    }
  }

  void uploadImage(result) async {
    final StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child(widget.userId + "-" + DateTime.now().toString());

    StorageUploadTask uploadTask = storageRef.putFile(
      result,
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
    StorageTaskSnapshot download = await uploadTask.onComplete;

    String url = await download.ref.getDownloadURL();

    ChatMessage message = ChatMessage(text: "", user: chatUser, image: url);
    onSend(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          title: Text(
            widget.heading,
            style: TextStyle(fontSize: 17),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('messages')
                .document(widget.messagesId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return Center(
                  child: customListLoadingShimmer(context,
                      loadingMessage: 'Loading your Messages...',
                      listLength: 6),
                );
              } else {
                DocumentSnapshot items = snapshot.data;
                List msg = items.data["messages"] == null
                    ? []
                    : items.data["messages"];
                List<ChatMessage> messages = [];
                msg.forEach((item) => messages.add(ChatMessage.fromJson(item)));
                return DashChat(
                  key: _chatViewKey,
                  inverted: false,
                  onSend: onSend,
                  sendOnEnter: true,
                  textInputAction: TextInputAction.send,
                  user: chatUser,
                  inputDecoration: InputDecoration.collapsed(
                      hintText: "Add message here..."),
                  dateFormat: DateFormat('yyyy-MMM-dd'),
                  timeFormat: DateFormat('HH:mm'),
                  messages: messages,
                  showUserAvatar: true,
                  showAvatarForEveryMessage: true,
                  scrollToBottom: true,
                  onPressAvatar: (ChatUser user) {
                    print("OnPressAvatar: ${user.name}");
                  },
                  onLongPressAvatar: (ChatUser user) {
                    print("OnLongPressAvatar: ${user.name}");
                  },
                  inputMaxLines: 5,
                  messageContainerPadding:
                      EdgeInsets.only(left: 5.0, right: 5.0),
                  alwaysShowSend: false,
                  inputTextStyle: TextStyle(fontSize: 16.0),
                  inputContainerStyle: BoxDecoration(
                    border: Border.all(width: 0.0),
                    color: Colors.white,
                  ),
                  onLoadEarlier: () {
                    print("laoding...");
                  },
                  shouldShowLoadEarlier: false,
                  showTraillingBeforeSend: true,
                  trailing: <Widget>[
                    IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: () async {
                        final pickedFile = await picker.getImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                          maxHeight: 400,
                          maxWidth: 400,
                        );

                        if (pickedFile != null) {
                          File result = File(pickedFile.path);
                          uploadImage(result);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () async {
                        final pickedFile = await picker.getImage(
                          source: ImageSource.gallery,
                          imageQuality: 80,
                          maxHeight: 400,
                          maxWidth: 400,
                        );

                        if (pickedFile != null) {
                          File result = File(pickedFile.path);
                          uploadImage(result);
                        }
                      },
                    ),
                  ],
                );
              }
            }));
  }
}
