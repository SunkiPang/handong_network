import 'package:Shrine/src/components/bottom_bar.dart';
import 'package:Shrine/src/components/bottom_home_botton.dart';
import 'package:Shrine/src/screens/search/search_bar_widget.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "검색 결과",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
            tabs: <Tab>[
              new Tab(
                child: Text(
                  "통합 검색",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              new Tab(
                child: Text(
                  "과목",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              new Tab(
                child: Text(
                  "강사",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Icon(Icons.directions_car),
            Center(
              child: Text(
                "검색결과가 없습니다.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Center(
              child: Text(
                "검색결과가 없습니다.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BottomHomeButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}

class SearchResultBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBarWidget(),
//        Divider(
//          thickness: 3,
//        ),
      ],
    );
  }
}
