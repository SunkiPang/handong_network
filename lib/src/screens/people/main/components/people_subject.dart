import 'package:Shrine/src/components/header_more_widget.dart';
import 'package:Shrine/src/components/text_field_container.dart';
import 'package:Shrine/src/screens/people/people_subject_screen/people_subject_screens.dart';
import 'package:flutter/material.dart';

class PeopleSubject extends StatelessWidget {
  const PeopleSubject({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HeaderMoreWidget(subtitle: "전공별", route: PeopleSubjectScreen()),
        DoubleRoundTextField(
          text1: "GLS",
          text2: "국제어문",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "경영경제",
          text2: "법",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "커뮤니케이션",
          text2: "공간환경시스템",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "기계제어",
          text2: "콘융디",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "생명",
          text2: "전산전자",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "상담사복",
          text2: "ICT창업",
          height1: 10.0,
          height2: 10.0,
        ),
        DoubleRoundTextField(
          text1: "창의융합교육원",
          text2: "학생설계",
          height1: 10.0,
          height2: 10.0,
        ),
      ],
    );
  }
}
