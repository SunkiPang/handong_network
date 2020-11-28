import 'package:Shrine/src/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductFireStore {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Product>> getProducts() {
    return _db.collection('products').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  Stream<List<Product>> getProductsASC() {
    return _db
        .collection('products')
        .orderBy('price', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }

  Stream<List<Product>> getProductsDESC() {
    return _db
        .collection('products')
        .orderBy('price', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());
  }



  List<String> getUsersUid(String _productId) {
    List<String> list;
    list.add(_db
        .collection('products')
        .document(_productId)
        .collection('users')
        .toString());
    return list;
  }

  //Upsert
  Future<void> setProduct(Product product) {
    var options = SetOptions(merge: true);

    return _db
        .collection('products')
        .doc(product.productId)
        .set(product.toMap(), options);
  }


  //Delete
  Future<void> removeProduct(String productId) {
    return _db.collection('products').doc(productId).delete();
  }

  Future<void> removeUser(String userMemoId, String _productId) {
    return _db
        .collection('products')
        .document(_productId)
        .collection('user')
        .doc(userMemoId)
        .delete();
  }
}
