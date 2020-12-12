import 'package:Shrine/src/models/posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostFireStore {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //Get Entries
  Stream<List<Post>> getPosts() {
    return _db.collection('posts').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }


  Stream<List<Post>> getPostsASC() {
    return _db
        .collection('posts')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }
  //
  Stream<List<Post>> getPostsDESC() {
    return _db
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
  }


  //Upsert
  Future<void> setPost(Post post) {
    var options = SetOptions(merge: true);

    return _db.collection('posts').doc(post.postId).set(post.toMap(), options);
  }

  //Delete
  Future<void> removePost(String postId) {
    return _db.collection('posts').doc(postId).delete();
  }

}
