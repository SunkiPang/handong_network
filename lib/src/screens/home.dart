import 'package:Shrine/colors.dart';
import 'package:Shrine/src/components/bottom_bar.dart';
import 'package:Shrine/src/components/bottom_home_botton.dart';
import 'package:Shrine/src/components/left_drawer.dart';
import 'package:Shrine/src/models/posts.dart';
import 'package:Shrine/src/providers/post_provider.dart';
import 'package:Shrine/src/providers/post_provider.dart';
import 'package:Shrine/src/screens/add_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_screen.dart';
import 'search/recent/DateSearch.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: MaterialApp(
        home: HomeBody(),
        theme: ThemeData(
          fontFamily: 'Nanum Square Round',
          primaryColor: kPrimaryColor,
        ),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  // String dropdownValue = 'ASC';

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          centerTitle: true,
          title: Text(
            'Handong People',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 24.0,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                semanticLabel: 'search',
              ),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "도움 요청",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "기도 요청",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "구인구직",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // drawer: NavDrawer(),
        bottomNavigationBar: BottomBar(),
        floatingActionButton: BottomHomeButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Post>>(
                    stream: postProvider.posts,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return (CircularProgressIndicator());
                      else {
                        Iterable<Post> filter = snapshot.data
                            .where((post) => post.category.contains("도움요청"));
                        return ListView(
                          children: buildGridCards(context, filter),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Post>>(
                    stream: postProvider.posts,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return (CircularProgressIndicator());
                      else {
                        Iterable<Post> filter = snapshot.data
                            .where((post) => post.category.contains("기도요청"));
                        return ListView(
                          children: buildGridCards(context, filter),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<Post>>(
                    stream: postProvider.posts,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: (CircularProgressIndicator()));
                      else {
                        Iterable<Post> filter = snapshot.data
                            .where((post) => post.category.contains("구인구직"));
                        return ListView(
                          children: buildGridCards(context, filter),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  data.userName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
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
}
