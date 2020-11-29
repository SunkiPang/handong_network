import 'package:flutter/material.dart';

class HeaderMoreWidget extends StatelessWidget {
  final String subtitle;
  final Widget route;

  const HeaderMoreWidget({
    Key key,
    @required this.subtitle, this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          subtitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ButtonTheme(
          minWidth: 10,
          child: FlatButton(
            child: Text(
              "더보기",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return route;
                }),
              );
            },
            padding: EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
