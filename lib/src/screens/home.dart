import 'package:Shrine/src/components/bottom_bar.dart';
import 'package:Shrine/src/components/bottom_home_botton.dart';
import 'package:Shrine/src/components/left_drawer.dart';
import 'package:Shrine/src/models/product.dart';
import 'package:Shrine/src/providers/product_provider.dart';
import 'package:Shrine/src/screens/add_screen.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'detail_screen.dart';
import 'search/recent/DateSearch.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // String dropdownValue = 'ASC';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.category,
        //     semanticLabel: 'category',
        //   ),
        //   onPressed: () {
        //     // Navigator.of(context).push(
        //     //   MaterialPageRoute(
        //     //     builder: (context) => ProfileScreen(),
        //     //   ),
        //     // );
        //   },
        // ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          ),
        ],
      ),
      drawer: NavDrawer(),
      bottomNavigationBar: BottomBar(),
      floatingActionButton: BottomHomeButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: productProvider.products,
              // (dropdownValue == 'ASC')
              // ? productProvider.productsASC
              // : productProvider.productsDESC,
              builder: (context, snapshot) {
                return GridView.count(
                  crossAxisCount: 1,
                  padding: EdgeInsets.all(10.0),
                  // childAspectRatio: 8.0 / 8.0,
                  children: _buildGridCards(context, snapshot),
                ); //ListViewStore(context: context, snapshot: snapshot,);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
//          title: new Text("권한이 없습니다."),
          content: Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  List<Card> _buildGridCards(BuildContext context, snapshot) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return snapshot.data.map<Card>((data) {
      var index = snapshot.data.indexOf(data);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(product: snapshot.data[index])
                  //AddScreen(product: snapshot.data[index]),
                  ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/anonymous.png", width: 50),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            formatDate(
                                DateTime.parse(data.date), [HH, ':', mm]),
                            style: TextStyle(
                              color: Colors.grey,
                              // fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.create_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (data.userUid == auth.currentUser.uid) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddScreen(product: data),
                              ),
                            );
                          } else {
                            _showDialog("수정 할 권한이 없습니다.");
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (data.userUid == auth.currentUser.uid) {
                            data.removeProduct(data.productId);
                            Navigator.of(context).pop();
                          } else {
                            _showDialog("삭제 할 권한이 없습니다.");
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(data.description),
              ),
              // (data.imageUrl != null)
              //     ? Image.network(data.imageUrl)
              //     : Image.asset("assets/logo.png"),
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(16.0, 2.0, 16.0, 0.0),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12.0, horizontal: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
// //                        "NAME",
//                           data.name,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           maxLines: 1,
//                         ),
//                         SizedBox(height: 4.0),
//                         Row(
//                           children: [
//                             Text("\$ "),
//                             Text(
// //                        "price",
//                               data.price.toString(),
//                               style: TextStyle(
//                                 fontSize: 11,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
