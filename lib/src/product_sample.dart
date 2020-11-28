import 'package:Shrine/src/providers/product_provider.dart';
import 'package:Shrine/src/screens/product_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
          home: ProductHome(),
          theme: ThemeData(
            accentColor: Colors.pinkAccent,
            primaryColor: Colors.grey,
          )),
    );
  }
}
