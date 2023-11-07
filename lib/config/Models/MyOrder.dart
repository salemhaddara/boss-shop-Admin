import 'package:bossshopadmin/config/Models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrder {
  Product product;
  DateTime time;
  String status;
  String paymentMethod;
  String orderId;
  String phoneNumber;
  String state;
  String zipcode;
  String name;
  String userId;
  int quantity;
  MyOrder(
      {Key? key,
      required this.product,
      required this.time,
      required this.status,
      required this.paymentMethod,
      required this.quantity,
      required this.state,
      required this.name,
      required this.userId,
      required this.zipcode,
      required this.phoneNumber,
      required this.orderId});
  MyOrder.fromMap(Map<String, dynamic> map)
      : product = Product.fromMap(map['product']),
        time = (map['time'] as Timestamp).toDate(),
        status = map['status'],
        paymentMethod = map['paymentMethod'],
        orderId = map['orderId'],
        phoneNumber = map['phoneNumber'],
        state = map['state'],
        zipcode = map['zipcode'],
        name = map['name'],
        userId = map['userId'],
        quantity = (map['quantity']);
  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'time': time.toUtc(),
      'status': status,
      'paymentMethod': paymentMethod,
      'orderId': orderId,
      'phoneNumber': phoneNumber,
      'state': state,
      'zipcode': zipcode,
      'name': name,
      'userId': userId,
      'quantity': quantity,
    };
  }
}
