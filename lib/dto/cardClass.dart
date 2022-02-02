import 'package:flutter/cupertino.dart';

class cardClass{
  final int id;
  final String title;
  final String message;
  final DateTime dateTime;
  final Color color;
  final bool favorite;
  final String type;

  cardClass(this.id, this.title, this.message, this.dateTime, this.color, this.favorite, this.type);

  factory cardClass.fromJson(Map<String, dynamic> json)=>cardClass(
      json['id'],
      json['title'],
      json['message'],
      DateTime.parse(json['datePrediction']),
      Color.fromARGB(1, 1, 1, 1),
    json['favorite'],
    json['type']
  );
}