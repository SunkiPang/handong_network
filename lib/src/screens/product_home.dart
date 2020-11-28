import 'package:Shrine/src/components/drop_down.dart';
import 'package:Shrine/src/models/product.dart';
import 'package:Shrine/src/providers/product_provider.dart';
import 'package:Shrine/src/screens/add_screen.dart';
import 'package:Shrine/src/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_screen.dart';

class ProductHome extends StatefulWidget {
  @override
  _ProductHomeState createState() => _ProductHomeState();
}

class _ProductHomeState extends State<ProductHome> {
  String dropdownValue = 'ASC';
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        leading: IconButton(
          icon: Icon(
            Icons.person,
            semanticLabel: 'search',
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddScreen()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['ASC', 'DESC']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: (dropdownValue == 'ASC') ? productProvider.productsASC : productProvider.productsDESC,
              builder: (context, snapshot) {
                return GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(16.0),
                  childAspectRatio: 8.0 / 9.0,
                  children: _buildGridCards(context, snapshot),
                ); //ListViewStore(context: context, snapshot: snapshot,);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Card> _buildGridCards(BuildContext context, snapshot) {
    return snapshot.data.map<Card>((data) {
      var index = snapshot.data.indexOf(data);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            (data.imageUrl != null)
                ? Image.network(data.imageUrl)
                : Image.asset("assets/logo.png"),
//                ? Image.network(
//                    data.imageUrl,
//                    fit: BoxFit.fitWidth,
//                  )
//            : Image.asset("assets/logo.png"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 0.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
//                        "NAME",
                        data.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(height: 4.0),
                      Row(
                        children: [
                          Text("\$ "),
                          Text(
//                        "price",
                            data.price.toString(),
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      product: snapshot.data[index])
                                  //AddScreen(product: snapshot.data[index]),
                                  ),
                            );
                          },
                          padding: EdgeInsets.all(0),
                          minWidth: 0,
                          height: 0,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "more",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
