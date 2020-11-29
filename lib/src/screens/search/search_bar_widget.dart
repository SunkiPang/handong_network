import 'package:Shrine/src/screens/search/recent/DateSearch.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      height: size.height * 0.05,
      child: TextField(
        onTap: () {
          showSearch(context: context, delegate: DataSearch());
        },
        maxLines: 1,
        style: TextStyle(
          fontSize: 13,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(239, 239, 239, 100),
          isDense: true,
          prefixIcon: Image.asset(
            "assets/images/search_icon.png",
            height: size.height * 0.01,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(60)),
            borderSide: BorderSide.none,
          ),
          border: InputBorder.none,
          hintText: "검색어를 입력해!",
        ),
      ),
    );
  }
}
