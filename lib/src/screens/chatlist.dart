import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';

class ChatList extends StatefulWidget {
  ChatList(this.uid);

  String uid;
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  String name;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메신저',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.7),
            );
          return ListView(
            children: snapshot.data.docs.map(
              (data) {
                if (data['uid'] == widget.uid) {
                  name = data['name'];
                  return Container();
                } else {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.uid)
                        .collection('chatlist')
                        .where('targetUid', isEqualTo: data['uid'])
                        .snapshots(),
                    builder: (context, chatlistSnapshot) {
                      return InkWell(
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                          leading: Container(
                            child: CircleAvatar(
                              child: Text(
                                data['name'][0],
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              radius: 25.0,
                            ),
                          ),
                          title: Text(
                            data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text((chatlistSnapshot.hasData &&
                                  chatlistSnapshot.data.docs.length > 0)
                              ? chatlistSnapshot.data.docs[0]['lastMessage']
                              : ''),
                        ),
                        onTap: () {
                          _NavigateToChatRoom(data['uid'], data['name'],
                              data['profilePictureUrl']);
                        },
                      );
                    },
                  );
                }
              },
            ).toList(),
          );
        },
      ),
    );
  }

  Future<void> _NavigateToChatRoom(
      selectedUid, selectedUserName, selectedUserPicture) async {
    try {
      String chatID = generateChatId(widget.uid, selectedUid);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(widget.uid, name, selectedUid,
                  chatID, selectedUserName, selectedUserPicture)));
    } catch (e) {
      print(e.message);
    }
  }
}

String generateChatId(uid, selectedUid) {
  String chatID;
  if (uid.hashCode > selectedUid.hashCode) {
    chatID = '$selectedUid-$uid';
  } else {
    chatID = '$uid-$selectedUid';
  }
  return chatID;
}
