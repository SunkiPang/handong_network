import 'package:flutter/material.dart';

class Users {
  final String userMemoId;
  final String uId;

  Users({@required this.userMemoId, this.uId});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(uId: json['uId'], userMemoId: json['userId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'userMemoId': userMemoId,
    };
  }
}
