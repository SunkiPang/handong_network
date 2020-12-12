import 'package:Shrine/src/models/posts.dart';
import 'package:Shrine/src/services/post_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:core';

enum Category {
  helps,
  prayers,
  jobs,
}

class PostProvider with ChangeNotifier {
  final postFireStore = PostFireStore();
  String _category;
  String _postId;
  String _userName;
  String _userImageUrl;
  DateTime _date;
  DateTime _modifyDate;
  String _title;
  String _content;
  String _imageUrl;
  num _like = 0;
  bool _likeCheck;
  String _userUid;

  var uuid = Uuid();

  //Getters
  String get category => _category;

  DateTime get date => _date;

  String get userName => _userName;

  String get userImageUrl => _userImageUrl;

  String get title => _title;

  String get content => _content;

  String get imageUrl => _imageUrl;

  num get like => _like;

  bool get likeCheck => _likeCheck;

  DateTime get modifyDate => _modifyDate;

  String get userUid => _userUid;

  Stream<List<Post>> get posts => postFireStore.getPosts();
  Stream<List<Post>> get postsASC => postFireStore.getPostsASC();
  Stream<List<Post>> get postsDESC => postFireStore.getPostsDESC();

  //Setters
  set changeCategory(String category) {
    _category = category;
    notifyListeners();
  }

  set changeUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  set changeUserImgUrl(String userImageUrl) {
    _userImageUrl = userImageUrl;
    notifyListeners();
  }

  set changeDate(DateTime date) {
    _date = date;
    notifyListeners();
  }

  set changeModifyDate(DateTime modifyDate) {
    _modifyDate = modifyDate;
    notifyListeners();
  }

  set changeTitle(String title) {
    _title = title;
    notifyListeners();
  }

  set changeContent(String content) {
    _content = content;
    notifyListeners();
  }

  set changeImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
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

  set changeUserUid(String userUid) {
    _userUid = userUid;
    notifyListeners();
  }

  void likeUp() {
    _like++;
    notifyListeners();
  }

  //Functions
  loadAll(Post post) {
    if (post != null) {
      _category = post.category;
      _date = DateTime.parse(post.date);
      _userName = post.userName;
      _userImageUrl = post.userImageUrl;
      _title = post.title;
      _content = post.content;
      _postId = post.postId;
      _imageUrl = post.imageUrl;
      _like = post.like;
      _likeCheck = post.likeCheck;
      _userUid = post.userUid;
      _modifyDate = DateTime.now();
    } else {
      _category = "도움요청";
      _date = DateTime.now();
      _userName = null;
      _userImageUrl = null;
      _title = null;
      _content = null;
      _postId = null;
      _imageUrl = null;
      _like = 0;
      _likeCheck = false;
      _userUid = null;
      _modifyDate = DateTime.now();
    }
  }

  savePost() {
    if (_postId == null) {
      //Add
      var newPost = Post(
        category: _category,
        date: _date.toIso8601String(),
        userName: _userName,
        userImageUrl: _userImageUrl,
        title: _title,
        content: _content,
        postId: uuid.v1(),
        imageUrl: _imageUrl,
        userUid: _userUid,
        like: 0,
        likeCheck: false,
        modifyDate: _modifyDate.toIso8601String(),
      );
      // print(newPost.userName);
      postFireStore.setPost(newPost);
    } else {
      //Edit
      var updatedPost = Post(
        category: _category,
        date: _date.toIso8601String(),
        userName: _userName,
        userImageUrl: _userImageUrl,
        title: _title,
        content: _content,
        postId: _postId,
        imageUrl: _imageUrl,
        like: _like,
        userUid: _userUid,
        likeCheck: _likeCheck,
        modifyDate: _modifyDate.toIso8601String(),
      );
      postFireStore.setPost(updatedPost);
    }
  }

  removePost(String postId) {
    postFireStore.removePost(postId);
  }
}
