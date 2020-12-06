import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:Shrine/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../components/bottom_bar.dart';
import '../components/bottom_home_botton.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

@override
class ChatMessage extends StatelessWidget {
  ChatMessage({
    this.senderName,
    this.senderPhotoUrl,
    this.text,
    this.imageUrl,
    this.isMe,
  });

  final String senderName;
  final String senderPhotoUrl;
  final String text;
  final String imageUrl;
  final bool isMe;

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              senderName,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black54,
              ),
            ),
            Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
              elevation: 0,
              color: isMe ? kPrimaryColor : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Container(
            //       margin: const EdgeInsets.only(right: 16.0),
            //       child: senderPhotoUrl != null
            //           ? CircleAvatar(backgroundImage: NetworkImage(senderPhotoUrl))
            //           : CircleAvatar(child: Text(loggedInUser.uid[0])),
            //     ),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(senderName,
            //               style: Theme.of(context).textTheme.headline4),
            //           Container(
            //             margin: EdgeInsets.only(top: 5.0),
            //             child: imageUrl != null
            //                 ? Image.network(
            //                     imageUrl,
            //                     width: 250.0,
            //                   )
            //                 : Text(text),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isComposing = false;

  String messageText;

  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: Container(
          child: Column(children: [
            Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('created', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                    );
                  }
                  final messages = snapshot.data.docs.reversed;
                  List<ChatMessage> messageBubbles = [];
                  for (var message in messages) {
                    final messageSender = message.get('senderName');
                    final messageSenderPhotoUrl = message.get('senderPhotoUrl');
                    final messageText = message.get('text');
                    final messageImageUrl = message.get('imageUrl');
                    final currentUser = loggedInUser.uid;

                    final messageBubble = ChatMessage(
                      senderName: messageSender,
                      senderPhotoUrl: messageSenderPhotoUrl,
                      text: messageText,
                      imageUrl: messageImageUrl,
                      isMe: currentUser == messageSender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(8.0),
                      reverse: true,
                      children: messageBubbles,
                    ),
                  );
                },
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ]),
        ));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.photo_camera),
                  onPressed: () async {
                    var pickedFile = await ImagePicker()
                        .getImage(source: ImageSource.camera);
                    File imageFile;
                    setState(() {
                      if (pickedFile != null) {
                        imageFile = File(pickedFile.path);
                      } else {
                        print('No image selected.');
                      }
                    });
                    int random = Random().nextInt(100000);
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child("image_$random.jpg");
                    ref.putFile(imageFile);
                    String downloadUrl = await ref.getDownloadURL();
                    _sendMessage(imageUrl: downloadUrl);
                  }),
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Theme.of(context).platform == TargetPlatform.iOS
                    ? CupertinoButton(
                        child: Text("Send"),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )
                    : IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _isComposing
                            ? () => _handleSubmitted(_textController.text)
                            : null,
                      )),
          ]),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200])))
              : null),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    _sendMessage(text: text);
  }

  void _sendMessage({String text, String imageUrl}) {
    _firestore.collection('messages').add({
      'senderName': loggedInUser.uid,
      'senderPhotoUrl': loggedInUser.photoURL,
      'text': text,
      'imageUrl': imageUrl,
      'created': FieldValue.serverTimestamp(),
    });
  }
}
