import 'package:Shrine/src/screens/add_screen.dart';
import 'package:flutter/material.dart';

class BottomHomeButton extends StatelessWidget {
  const BottomHomeButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      child: const Icon(
        Icons.create_rounded,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddScreen()));
      },
    );
  }
}
