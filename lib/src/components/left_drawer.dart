import 'package:flutter/material.dart';

import '../../colors.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 32.0),
        children: <Widget>[
          // DrawerHeader(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         'Category',
          //         style: TextStyle(color: Colors.white, fontSize: 25),
          //       ),
          //       Text(" - 이 곳에 메인 화면을 카테고리화",
          //           style: TextStyle(color: Colors.white, fontSize: 15)),
          //       Text(" - 날짜순 (최신순, 오래된 순) ",
          //           style: TextStyle(color: Colors.white, fontSize: 15)),
          //       Text(" - 카테고리 별 (지역, 분야, 전공) ",
          //           style: TextStyle(color: Colors.white, fontSize: 15)),
          //     ],
          //   ),
          //   decoration: BoxDecoration(
          //     color: kPrimaryColor,
          //     // image: DecorationImage(
          //     //     fit: BoxFit.fill,
          //     //     image: AssetImage('assets/images/cover.jpg')),
          //   ),
          // ),

          ListTile(
            leading: Icon(Icons.live_help),
            title: Text('도움'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('기도 요청'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('구인구직'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
