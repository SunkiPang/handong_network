import 'package:flutter/material.dart';
import 'dart:io';

class Product {
  final String productId;
  final String name;
  final num price;
  final String date;
  final String description;
  final String id;
  final String imageUrl;
  final num like;
  final bool likeCheck;
  final String modifyDate;
  final String userUid;
  final List<String> likeUsers;

  Product({
    this.name,
    this.price,
    this.description,
    @required this.productId,
    this.id,
    this.date,
    this.imageUrl,
    this.like,
    this.likeCheck,
    this.modifyDate,
    this.userUid,
    this.likeUsers,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      productId: json['productId'],
      id: json['id'],
      date: json['date'],
      imageUrl: json['imageUrl'],
      like: json['like'],
      likeCheck: json['likeCheck'],
      modifyDate: json['modifyDate'],
      userUid: json['userUid'],
//      likeUsers: json['likeUsers'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'name': name,
      'description': description,
      'productId': productId,
      'id': id,
      'date': date,
      'imageUrl': imageUrl,
      'like': like,
      'likeCheck': likeCheck,
      'modifyDate': modifyDate,
      'userUid': userUid,
      'likeUsers': likeUsers,
    };
  }
}
