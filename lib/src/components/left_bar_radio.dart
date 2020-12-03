import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


enum Category { helps, prayers, jobs }

/// This is the stateful widget that the main application instantiates.
class RadioWidget extends StatefulWidget {
  RadioWidget({Key key}) : super(key: key);

  @override
  _RadioWidgetState createState() => _RadioWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RadioWidgetState extends State<RadioWidget> {
  Category _character = Category.helps;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('도움요청'),
          leading: Radio(
            value: Category.helps,
            groupValue: _character,
            onChanged: (Category value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('기도요청'),
          leading: Radio(
            value: Category.prayers,
            groupValue: _character,
            onChanged: (Category value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('구인구직'),
          leading: Radio(
            value: Category.jobs,
            groupValue: _character,
            onChanged: (Category value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
