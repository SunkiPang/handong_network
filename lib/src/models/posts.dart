import 'package:flutter/material.dart';

class Post {
  final String category;
  final String postId;
  final String userName;
  final String userImageUrl;
  final String date;
  final String modifyDate;
  final String title;
  final String content;
  final String imageUrl;
  final num like;
  final bool likeCheck;
  final String userUid;

  Post({
    this.category,
    @required this.postId,
    this.userName,
    this.date,
    this.userImageUrl,
    this.modifyDate,
    this.title,
    this.content,
    this.imageUrl,
    this.like,
    this.likeCheck,
    this.userUid,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      category: json['category'],
      postId: json['postId'],
      userName: json['userName'],
      userImageUrl: json['userImageUrl'],
      title: json['title'],
      content: json['content'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      like: json['like'],
      likeCheck: json['likeCheck'],
      modifyDate: json['modifyDate'],
      userUid: json['userUid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'postId': postId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'date': date,
      'modifyDate': modifyDate,
      'title': title,
      'content': content, //description
      'imageUrl': imageUrl,
      'like': like,
      'likeCheck': likeCheck,
      'userUid': userUid,
    };
  }
}
