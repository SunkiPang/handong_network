import 'package:Shrine/src/screens/search/search_bar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'people_list_view_channel.dart';

class PeopleChannelBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SearchBarWidget(),
          SizedBox(
            height: 20,
          ),
          Text(
            "채널 목록",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: PeopleListViewChannel(),
          ),
        ],
      ),
    );
  }
}
