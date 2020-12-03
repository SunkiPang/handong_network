import 'package:flutter/material.dart';

class PeopleListViewCountry extends StatelessWidget {
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
    '미국',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '유럽',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '중국',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '일본',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '동남아시아',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '중동',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '북부 아프리카',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
    ],
  ),
  Entry(
    '남부 아프리카',
    <Entry>[
      Entry('대학원생'),
      Entry('직장인'),
      Entry('선교사'),
      Entry('기타'),
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
