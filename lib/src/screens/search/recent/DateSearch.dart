import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final recommended = [
    "상담심리사회복지학부",
    "미국",
    "캄보디아",
    "선교사",
    "베트남",
    "코트디부아",
    "Africa",
    "USA",
    "Mission",
    "HGU",
    "Test",
    "Good Tree International School",
  ];

  final recent = [
    "HGU",
    "Africa",
    "USA",
    "Good Tree International School",
    "상담심리사회복지학부",
    "미국",
    "캄보디아",
    "선교사",
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
          onTap: () {
            query = suggestionList[index];
          },
          // leading: Icon(Icons.restore_outlined),
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
