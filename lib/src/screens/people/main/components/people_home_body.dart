import 'package:Shrine/src/components/header_more_widget.dart';
import 'package:Shrine/src/screens/people/job_screen/people_channel_screen.dart';
import 'package:flutter/material.dart';

import 'people_subject.dart';

class PeopleHomeBody extends StatelessWidget {
  const PeopleHomeBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 5),
          child: PeopleSubject(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 13, horizontal: 5),
          child: Column(
            children: <Widget>[
              HeaderMoreWidget(
                subtitle: "채널",
                route: PeopleChannelScreen(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
