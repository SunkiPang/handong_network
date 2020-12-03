import 'package:Shrine/src/components/bottom_bar.dart';
import 'package:Shrine/src/components/bottom_home_botton.dart';
import 'package:flutter/material.dart';

import 'people_country_body.dart';

class PeopleChannelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "국가별 연락처",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: PeopleCountryBody(),
      floatingActionButton: BottomHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(),
    );
  }
}
