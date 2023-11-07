import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Product {
  String imagePath, productName, productId, description, Category;
  List reviews;
  int purshases;
  double price;
  Product(
      {Key? key,
      required this.imagePath,
      required this.productName,
      required this.price,
      required this.productId,
      required this.description,
      required this.reviews,
      required this.purshases,
      required this.Category});
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'productName': productName,
      'price': price,
      'productId': productId,
      'description': description,
      'reviews': reviews,
      'purshases': purshases,
      'Category': Category,
    };
  }

  factory Product.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Product(
      imagePath: data['imagePath'],
      productName: data['productName'],
      price: data['price'].toDouble(),
      productId: data['productId'],
      reviews: data['reviews'],
      description: data['description'],
      purshases: data['purshases'],
      Category: data['Category'],
    );
  }
  Product.fromMap(Map<String, dynamic> map)
      : imagePath = map['imagePath'],
        productName = map['productName'],
        price = (map['price']) + 0.00,
        productId = map['productId'],
        description = map['description'],
        reviews = List.from(map['reviews']),
        purshases = map['purshases'],
        Category = map['Category'];
}
