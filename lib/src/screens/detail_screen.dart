import 'package:Shrine/src/models/posts.dart';
import 'package:Shrine/src/providers/post_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'add_screen.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  DetailScreen({this.post});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  CollectionReference users = FirebaseFirestore.instance.collection('post').;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  bool flag = false;

  void titleDispose() {
    titleController.dispose();
    super.dispose();
  }

  void disposeDescription() {
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    if (widget.post != null) {
      //Edit
      titleController.text = widget.post.title;
      contentController.text = widget.post.content;

      postProvider.loadAll(widget.post);
    } else {
      //Add
      postProvider.loadAll(null);
    }
    super.initState();
  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
//          title: new Text("권한이 없습니다."),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Detail",
            style: TextStyle(color: Colors.white),
          ),
          leading: BackButton(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.create_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                if (postProvider.userUid == auth.currentUser.uid) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddScreen(post: widget.post),
                    ),
                  );
                } else {
                  _showDialog("수정 할 권한이 없습니다.");
                }
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                if (postProvider.userUid == auth.currentUser.uid) {
                  postProvider.removePost(widget.post.postId);
                  Navigator.of(context).pop();
                } else {
                  _showDialog("삭제 할 권한이 없습니다.");
                }
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  postProvider.imageUrl == null
                      ? Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Image.asset("assets/logo.png"),
                        )
                      : Image.network(postProvider.imageUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    postProvider.title,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$ ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                      // Text(
                                      //   postProvider.price.toString(),
                                      //   style: TextStyle(
                                      //     color: Colors.blue,
                                      //     fontSize: 20,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
//                             FlatButton(
//                               onPressed: () {
//                                 if (postProvider.id == auth.currentUser.uid) {
//                                   final snackBar = SnackBar(
//                                     content: Text('You can only do it once !!'),
//                                   );
//                                   Scaffold.of(context).showSnackBar(snackBar);
//                                 } else {
//                                   final snackBar = SnackBar(
//                                     content: Text('I LIKE IT !'),
//                                   );
//                                   setState(() {
//                                     flag = true;
//                                   });
//                                   Scaffold.of(context).showSnackBar(snackBar);
//                                   postProvider.changeUId = auth.currentUser.uid;
//                                   postProvider.likeUp();
//                                   postProvider.changeId = auth.currentUser.uid;
// //                                  postProvider
// //                                      .addLikeUser(auth.currentUser.uid);
//                                   postProvider.savePost();
// //                                  postProvider.saveUsers();
// //                                  print(postProvider.checkLikeUsers(auth.currentUser.uid));
//                                 }
//                               },
//                               child: Row(
//                                 children: [
//                                   Icon(
//                                     Icons.thumb_up_sharp,
//                                     color: Colors.red,
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   Text(
//                                     postProvider.like.toString(),
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          postProvider.content,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          'creater : ${postProvider.userUid}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          formatDate(DateTime.parse(widget.post.date), [
                            yyyy,
                            '.',
                            mm,
                            '.',
                            d,
                            ' ',
                            HH,
                            ':',
                            mm,
                            ':',
                            ss,
                            ' Created'
                          ]),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          formatDate(DateTime.parse(widget.post.modifyDate), [
                            yyyy,
                            '.',
                            mm,
                            '.',
                            d,
                            ' ',
                            HH,
                            ':',
                            mm,
                            ':',
                            ss,
                            ' Modified'
                          ]),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
//                    Text(
//                      '${widget.post.date} created',
//                      style: TextStyle(color: Colors.grey),
//                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<DateTime> _pickDate(
      BuildContext context, PostProvider postProvider) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: postProvider.date,
        firstDate: DateTime(2019),
        lastDate: DateTime(2050));

    if (picked != null) return picked;
  }
}
