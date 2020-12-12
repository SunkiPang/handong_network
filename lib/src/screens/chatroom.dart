import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../colors.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(this.myID, this.myName, this.selectedUserID, this.chatID,
      this.selectedUserName, this.selectedUserThumbnail);

  String myID;
  String myName;
  String selectedUserID;
  String chatID;
  String selectedUserName;
  String selectedUserThumbnail;

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _textController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String messageType = 'text';
  bool showSpinner = false;
  int messageListLength = 20;
  double _scrollPosition = 560;
  final picker = ImagePicker();
  File _image;
  var _pickedFile;

  @override
  void initState() {
    // setCurrentChatRoomID(widget.chatID); //?
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _scrollListener() {
    setState(() {
      if (_scrollPosition < _scrollController.position.pixels) {
        _scrollPosition = _scrollPosition + 560;
        messageListLength = messageListLength + 20;
      }
    });
  }

  Future getImage() async {
    _pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (_pickedFile != null) {
        _image = File(_pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String> uploadFile() async {
    var imageFileName = DateTime.now().microsecondsSinceEpoch.toString();

    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() => null);

    return await storageSnapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedUserName),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatID)
            .collection(widget.chatID)
            .orderBy('timestamp', descending: true)
            .limit(messageListLength)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                        reverse: true,
                        shrinkWrap: true,
                        padding:
                            const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 10.0),
                        controller: _scrollController,
                        children: snapshot.data.docs.map((data) {
                          return data['sender'] == widget.selectedUserID
                              ? _buildMessageList(
                                  context,
                                  false,
                                  widget.selectedUserName,
                                  widget.selectedUserThumbnail,
                                  data['content'],
                                  returnTimeStamp(data['timestamp']),
                                  data['type'])
                              : _buildMessageList(
                                  context,
                                  true,
                                  null,
                                  null,
                                  data['content'],
                                  returnTimeStamp(data['timestamp']),
                                  data['type']);
                        }).toList()),
                  ),
                  _buildTextComposer(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, bool isMe, String name,
      String thumbnail, String message, String time, String type) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      // padding: EdgeInsets.only(top: 2.0, right: 8.0),
      child: isMe
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 14.0, right: 4.0, left: 8.0),
                  child: Text(
                    time,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: size.width - size.width * 0.26),
                        decoration: BoxDecoration(
                          color: type == 'text'
                              ? kPrimaryColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(type == 'text' ? 10.0 : 0),
                          child: Container(
                            child: type == 'text'
                                ? Text(
                                    message,
                                    style: TextStyle(color: Colors.white),
                                  )
                                : _buildImageTypeMessage(message),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(radius: 30, child: Text(name[0])),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
                              child: Container(
                                constraints:
                                    BoxConstraints(maxWidth: size.width - 150),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(type == 'text' ? 10.0 : 0),
                                  child: Container(
                                      child: type == 'text'
                                          ? Text(
                                              message,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          : _buildImageTypeMessage(
                                              messageType)),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 14.0, left: 4),
                              child: Text(
                                time,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildImageTypeMessage(String url) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        // onTap: () {
        //   Navigator.push(context,
        //       MaterialPageRoute(builder: (context) => FullPhoto(url: url)));
        // },
        child: Image.network(
          url,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                icon: Icon(
                  Icons.photo,
                  color: kPrimaryColor,
                ),
                onPressed: () async {
                  _pickedFile = null;
                  getImage();
                  if (_pickedFile != null) {
                    setState(() {
                      messageType = 'image';
                      showSpinner = true;
                    });
                    String imageUrl = await uploadFile();
                    _handleSubmitted(imageUrl);
                  } else {
                    _showDialog('Pick Image error');
                  }
                },
              ),
            ),
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      messageType = 'text';
                    });
                    _handleSubmitted(_textController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmitted(String text) async {
    try {
      setState(() {
        showSpinner = true;
      });

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatID)
          .collection(widget.chatID)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        'sender': widget.myID,
        'recipient': widget.selectedUserID,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'content': text,
        'type': messageType,
        'isRead': false,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.selectedUserID)
          .collection('chatlist')
          .doc(widget.chatID)
          .set({
        'chatID': widget.chatID,
        'targetUid': widget.selectedUserID == widget.myID
            ? widget.selectedUserID
            : widget.myID,
        'lastMessage': messageType == 'text' ? text : '(Photo)',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.myID)
          .collection('chatlist')
          .doc(widget.chatID)
          .set({
        'chatID': widget.chatID,
        'targetUid':
            widget.myID == widget.myID ? widget.selectedUserID : widget.myID,
        'lastMessage': messageType == 'text' ? text : '(Photo)',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      });

      // _getUnreadMSGCountThenSendMessage();
    } catch (e) {
      _showDialog('Error user information to database');
      _resetTextFieldAndLoading();
    }
  }

  String returnTimeStamp(int messageTimeStamp) {
    String resultString = '';
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(messageTimeStamp);
    resultString = format.format(date);
    return resultString;
  }
  // Future<void> _getUnreadMSGCountThenSendMessage() async {
  //   try {
  //     int unReadMSGCount = await FirebaseController.instanace
  //         .getUnreadMSGCount(widget.selectedUserID);
  //     await NotificationController.instance.sendNotificationMessageToPeerUser(
  //         unReadMSGCount,
  //         messageType,
  //         _msgTextController.text,
  //         widget.myName,
  //         widget.chatID,
  //         widget.selectedUserToken);
  //   } catch (e) {
  //     print(e.message);
  //   }
  //   _resetTextFieldAndLoading();
  // }

  _resetTextFieldAndLoading() {
    FocusScope.of(context).requestFocus(FocusNode());
    _textController.text = '';
    setState(() {
      showSpinner = false;
    });
  }

  _showDialog(String msg) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(msg),
          );
        });
  }
}
