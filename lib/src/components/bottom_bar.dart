import 'package:Shrine/colors.dart';
import 'package:Shrine/src/screens/chat_screen.dart';
import 'package:Shrine/src/screens/chatlist.dart';
import 'package:Shrine/src/screens/people/main/people_main_screen.dart';
import 'package:Shrine/src/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomBar extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final ValueChanged<String> onChanged;

  BottomBar({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        color: kPrimaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(
                  Icons.message,
                  size: 30.0,
                ),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatList(_auth.currentUser.uid);
                      },
                    ),
                  );
                },
              ),
            ),
            Icon(null),
            IconButton(
              icon: Icon(
                Icons.people,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return PeopleMainScreen();
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.person,
                size: 30.0,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }
}
