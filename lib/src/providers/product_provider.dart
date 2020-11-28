import 'package:Shrine/src/models/product.dart';
import 'package:Shrine/src/services/product_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:core';

class ProductProvider with ChangeNotifier {
  final productFireStore = ProductFireStore();
  DateTime _date;
  String _name;
  String _productId;
  num _price;
  String _description;
  String _id;
  String _imageUrl;
  num _like = 0;
  bool _likeCheck;
  DateTime _modifyDate;
  String _userUid;
  List<String> _likeUsers = List<String>();


  //users
  String _userMemoId;
  String _uId;

  var uuid = Uuid();

  //Getters
  DateTime get date => _date;

  String get name => _name;

  num get price => _price;

  String get id => _id;

  String get description => _description;

  String get imageUrl => _imageUrl;

  num get like => _like;

  bool get likeCheck => _likeCheck;

  DateTime get modifyDate => _modifyDate;

  String get userUid => _userUid;

  List<String> get likeUsers => _likeUsers;




  //Stream<List<Product>> get products => productFireStore.getProducts();
  Stream<List<Product>> get productsASC => productFireStore.getProductsASC();

  Stream<List<Product>> get productsDESC => productFireStore.getProductsDESC();

  List<String> get userUidList => productFireStore.getUsersUid(_productId);

  //Setters
  set changeDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  set changeName(String name) {
    _name = name;
    notifyListeners();
  }

  set changePrice(num price) {
    _price = price;
    notifyListeners();
  }

  set changeDescription(String description) {
    _description = description;
    notifyListeners();
  }

  set changeImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  set changeId(String id) {
    _id = id;
    notifyListeners();
  }

  set changeLike(num like) {
    _like = like;
    notifyListeners();
  }

  set changeLikeCheck(bool likeCheck) {
    _likeCheck = likeCheck;
    notifyListeners();
  }

  set changeModifyDate(DateTime modifyDate) {
    _modifyDate = modifyDate;
    notifyListeners();
  }

  set changeUserUid(String userUid) {
    _userUid = userUid;
    notifyListeners();
  }

  void addLikeUser(String userUid) {
    print(userUid);
    likeUsers.add(userUid);
    notifyListeners();
  }

  void likeUp() {
    _like++;
    notifyListeners();
  }

  //Functions
  loadAll(Product product) {
    if (product != null) {
      _date = DateTime.parse(product.date);
      _name = product.name;
      _price = product.price;
      _description = product.description;
      _productId = product.productId;
      _imageUrl = product.imageUrl;
      _like = product.like;
      _likeCheck = product.likeCheck;
      _userUid = product.userUid;
      _id = product.id;
//      _likeUsers = List.from(product.likeUsers);
      _likeUsers = product.likeUsers;
      _modifyDate = DateTime.now();
    } else {
      _date = DateTime.now();
      _name = null;
      _price = null;
      _description = null;
      _productId = null;
      _imageUrl = null;
      _like = 0;
      _likeCheck = false;
      _userUid = null;
      _id = null;
      _likeUsers = List<String>();
      _modifyDate = DateTime.now();
    }
  }


  saveProduct() {
    if (_productId == null) {
      //Add
      var newProduct = Product(
        date: _date.toIso8601String(),
        name: _name,
        price: _price,
        description: _description,
        productId: uuid.v1(),
        imageUrl: _imageUrl,
        userUid: _userUid,
        id: _id,
        like: 0,
        likeCheck: false,
        likeUsers: _likeUsers,
        modifyDate: _modifyDate.toIso8601String(),
      );
      print(newProduct.name);
      productFireStore.setProduct(newProduct);
    } else {
      //Edit
      var updatedProduct = Product(
        date: _date.toIso8601String(),
        name: _name,
        price: _price,
        description: _description,
        productId: _productId,
        imageUrl: _imageUrl,
        like: _like,
        userUid: _userUid,
        id: _id,
        likeCheck: _likeCheck,
        likeUsers: _likeUsers,
        modifyDate: _modifyDate.toIso8601String(),
      );
      productFireStore.setProduct(updatedProduct);
    }
  }

  removeProduct(String productId) {
    productFireStore.removeProduct(productId);
  }

//users

  String get userMemoId => _userMemoId;

  String get uId => _uId;

  set changeUserMemoId(String userMemoId) {
    _userMemoId = userMemoId;
    notifyListeners();
  }

  set changeUId(String uId) {
    _uId = uId;
    notifyListeners();
  }

}
