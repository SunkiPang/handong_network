import 'package:Shrine/src/models/posts.dart';
import 'package:Shrine/src/providers/post_provider.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../add_screen.dart';

class DataSearch extends SearchDelegate<String> {
  final recommended = [
    "상담심리사회복지학부",
    "미국",
    "캄보디아",
    "선교사",
    "베트남",
    "코트디부아",
    "Africa",
    "USA",
    "Mission",
    "HGU",
    "Test",
    "Good Tree International School",
    "선교",
    "학부생",
    "학번",
    "도와주세요",
    "기도",
    "한동",
    "선교사",
  ];

  final recent = [
    "아프리카",
    "선교",
    "학부생",
    "학번",
    "도와주세요",
    "기도",
    "한동",
    "캄보디아",
    "선교사",
    "마다가스카르",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
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

    List<Card> buildGridCards(BuildContext context, filter) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      // if (category == snapshot.category)
      // Iterable<Post> filter = snapshot.data.where((post) => post.category.contains(category));
      return filter.map<Card>((data) {
        // var index = filter.indexOf(data);
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        data.userImageUrl == null
                            ? Image.asset("assets/anonymous.png", width: 50)
                            : Image.network(data.userImageUrl, width: 50),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            data.userName == null
                                ? Text(
                                    "User Name",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    data.userName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                            Text(
                              formatDate(DateTime.parse(data.date),
                                  [mm, '/', dd, '  ', HH, ':', mm]),
                              style: TextStyle(
                                color: Colors.grey,
                                // fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // (data.userUid == auth.currentUser.uid)
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.create_rounded,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (data.userUid == auth.currentUser.uid) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddScreen(post: data),
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
                            color: Colors.black,
                          ),
                          onPressed: () {
                            if (data.userUid == auth.currentUser.uid) {
                              postProvider.removePost(data.postId);
                              // Navigator.of(context).pop();
                            } else {
                              _showDialog("삭제 할 권한이 없습니다.");
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Text(data.content),
                ),
                (data.imageUrl != null)
                    ? Image.network(data.imageUrl)
                    : SizedBox(),
              ],
            ),
          ),
        );
      }).toList();
    }

    final postProvider = Provider.of<PostProvider>(context);
    // throw UnimplementedError();
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<Post>>(
            stream: postProvider.posts,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return (CircularProgressIndicator());
              else {
                Iterable<Post> filter =
                    snapshot.data.where((post) => post.content.contains(query));
                return ListView(
                  children: buildGridCards(context, filter),
                );
              }
            },
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recent
        : recommended.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          onTap: () {
            query = suggestionList[index];
          },
          // leading: Icon(Icons.restore_outlined),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
