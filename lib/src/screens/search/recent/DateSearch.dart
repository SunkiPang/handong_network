import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final recommended = [
    "Khan",
    "Udemy",
    "IT",
    "Academy",
    "Excel",
    "Power Point",
    "방구",
    "곰돌이푸",
    "현남지",
    "보름달",
  ];

  final recent = [
    "방구",
    "곰돌이푸",
    "현남지",
    "보름달",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recent
        : recommended.where((p) => p.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          onTap: () {},
//          leading: Icon(Icons.person_outline),
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
