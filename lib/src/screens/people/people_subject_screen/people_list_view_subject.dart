import 'package:flutter/material.dart';

class PeopleListViewSubject extends StatelessWidget {
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
    'GLS',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '국제어문',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '경영경제',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '법',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '커뮤니케이션',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '공간환경시스템',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '기계제어',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '콘텐츠융합디자인',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '생명',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '전산전자',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '상담심리사회복지학',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    'ICT창업',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),  Entry(
    '창의융합교육원',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
    ],
  ),
  Entry(
    '학생설계',
    <Entry>[
      Entry('미국'),
      Entry('캄보디아'),
      Entry('코트디부아르'),
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
