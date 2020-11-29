import 'package:Shrine/src/screens/search/search_bar_widget.dart';
import 'package:flutter/material.dart';

import 'people_country.dart';
import 'people_home_body.dart';

class PeopleMainBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              PeopleHomeBody(),
              //SearchSubjectBody(),
            ],
          ),
        ),
      ),
    );
  }
}
