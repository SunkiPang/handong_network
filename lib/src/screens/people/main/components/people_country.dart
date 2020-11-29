import 'package:Shrine/src/components/header_more_widget.dart';
import 'package:Shrine/src/components/text_field_container.dart';
import 'package:Shrine/src/screens/people/job_screen/people_channel_screen.dart';
import 'package:Shrine/src/screens/people/people_subject_screen/people_subject_screens.dart';
import 'package:flutter/material.dart';

class PeopleCountry extends StatelessWidget {
  const PeopleCountry({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeaderMoreWidget(subtitle: "국가별", route: PeopleChannelScreen()),
        DoubleRoundTextField(
          text1: "미국",
          text2: "유럽",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "중국",
          text2: "일본",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "동남아시아",
          text2: "중동",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "북부 아프리카",
          text2: "남부 아프리카",
          height1: 10.0,
          height2: 10.0,
        ),
      ],
    );
  }
}
