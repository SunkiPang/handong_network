import 'package:Shrine/src/providers/product_provider.dart';
import 'package:Shrine/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../colors.dart';

class ProductSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
          home: Home(),
          theme: ThemeData(
            // accentColor: Colors.pinkAccent,
            primaryColor: Color(0xFF01579c),
          )),
    );
  }
}
