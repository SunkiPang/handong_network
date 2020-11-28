import 'package:Shrine/src/models/product.dart';
import 'package:Shrine/src/providers/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'add_screen.dart';

class DetailScreen extends StatefulWidget {
  final Product product;

  DetailScreen({this.product});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  CollectionReference users = FirebaseFirestore.instance.collection('product').;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  File _image;
  final picker = ImagePicker();
  bool flag = false;

  void nameDispose() {
    nameController.dispose();
    super.dispose();
  }

  void disposeDescription() {
    descriptionController.dispose();
    super.dispose();
  }

  void priceDescription() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    if (widget.product != null) {
      //Edit
      nameController.text = widget.product.name;
      descriptionController.text = widget.product.description;
      priceController.text = widget.product.price.toString();

      productProvider.loadAll(widget.product);
    } else {
      //Add
      productProvider.loadAll(null);
    }
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Detail",
            style: TextStyle(color: Colors.white),
          ),
          leading: BackButton(
            color: Colors.white,
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.create_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                if (productProvider.userUid == auth.currentUser.uid) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddScreen(product: widget.product),
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
                color: Colors.white,
              ),
              onPressed: () {
                if (productProvider.userUid == auth.currentUser.uid) {
                  productProvider.removeProduct(widget.product.productId);
                  Navigator.of(context).pop();
                }
                else {
                  _showDialog("삭제 할 권한이 없습니다.");
                }
              },
            ),
          ],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  productProvider.imageUrl == null
                      ? Padding(
                          padding: const EdgeInsets.all(80.0),
                          child: Image.asset("assets/logo.png"),
                        )
                      : Image.network(productProvider.imageUrl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productProvider.name,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$ ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        productProvider.price.toString(),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                if (productProvider.id ==
                                    auth.currentUser.uid) {
                                  final snackBar = SnackBar(
                                    content: Text('You can only do it once !!'),
                                  );
                                  Scaffold.of(context).showSnackBar(snackBar);
                                } else {
                                  final snackBar = SnackBar(
                                    content: Text('I LIKE IT !'),
                                  );
                                  setState(() {
                                    flag = true;
                                  });
                                  Scaffold.of(context).showSnackBar(snackBar);
                                  productProvider.changeUId =
                                      auth.currentUser.uid;
                                  productProvider.likeUp();
                                  productProvider.changeId =
                                      auth.currentUser.uid;
//                                  productProvider
//                                      .addLikeUser(auth.currentUser.uid);
                                  productProvider.saveProduct();
//                                  productProvider.saveUsers();
//                                  print(productProvider.checkLikeUsers(auth.currentUser.uid));
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.thumb_up_sharp,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    productProvider.like.toString(),
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          productProvider.description,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          'creater : ${productProvider.userUid}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          formatDate(DateTime.parse(widget.product.date), [
                            yyyy,
                            '.',
                            mm,
                            '.',
                            d,
                            ' ',
                            HH,
                            ':',
                            mm,
                            ':',
                            ss,
                            ' Created'
                          ]),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          formatDate(
                              DateTime.parse(widget.product.modifyDate), [
                            yyyy,
                            '.',
                            mm,
                            '.',
                            d,
                            ' ',
                            HH,
                            ':',
                            mm,
                            ':',
                            ss,
                            ' Modified'
                          ]),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
//                    Text(
//                      '${widget.product.date} created',
//                      style: TextStyle(color: Colors.grey),
//                    ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<DateTime> _pickDate(
      BuildContext context, ProductProvider productProvider) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: productProvider.date,
        firstDate: DateTime(2019),
        lastDate: DateTime(2050));

    if (picked != null) return picked;
  }
}
