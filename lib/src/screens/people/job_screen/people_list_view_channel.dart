import 'package:flutter/material.dart';

class PeopleListViewChannel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => EntryItem(data[index]),
      itemCount: data.length,
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Ted Ed',
    <Entry>[
      Entry('English'),
      Entry('French'),
      Entry('Korean'),
    ],
  ),
  Entry(
    'Coursera',
    <Entry>[
      Entry('Chemistry'),
      Entry('Physics'),
      Entry('Biology'),
      Entry('Earth science'),
    ],
  ),
  Entry(
    'Khan Academy',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2'),
    ],
  ),
  Entry(
    'Udemy',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2'),
    ],
  ),
  Entry(
    'GCF',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2'),
    ],
  ),
  Entry(
    'Alsion',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2'),
    ],
  ),
  Entry(
    'Mega Study',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry('Section C2'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
