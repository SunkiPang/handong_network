import 'package:flutter/material.dart';

import '../../colors.dart';
import 'left_bar_radio.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                Text(" - 이 곳에 메인 화면을 카테고리화",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                Text(" - 날짜순 (최신순, 오래된 순) ",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
                Text(" - 카테고리 별 (지역, 분야, 전공) ",
                    style: TextStyle(color: Colors.white, fontSize: 15)),
              ],
            ),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: AssetImage('assets/images/cover.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
          ),
          RadioWidget(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
