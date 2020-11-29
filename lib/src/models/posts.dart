import 'package:flutter/material.dart';

class Post {
  final String postId;
  final String userName;
  final String date;
  final String modifyDate;
  final String title;
  final String content;
  final String imageUrl;
  final num like;
  final bool likeCheck;
  final String userUid;

  Post({
    @required this.postId,
    this.userName,
    this.date,
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
      postId: json['postId'],
      userName: json['userName'],
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
      'postId': postId,
      'userName': userName,
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
