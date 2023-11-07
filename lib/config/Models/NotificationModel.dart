import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationModel {
  String NotificationText;
  DateTime NotificationTime;
  NotificationModel({
    Key? key,
    required this.NotificationText,
    required this.NotificationTime,
  });
// Convert a NotificationModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'NotificationText': NotificationText,
      'NotificationTime':
          NotificationTime.toUtc(), // Convert DateTime to UTC for Firestore
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      NotificationText: json['NotificationText'] ?? '',
      NotificationTime: (json['NotificationTime'] as Timestamp).toDate(),
    );
  }
}
