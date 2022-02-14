import 'package:flutter/cupertino.dart';

class CardModel {
  CardModel(this.id, this.title, this.message, this.dateTime, this.color,
      this.favorite, this.type);

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
      json['id'],
      json['title'],
      json['message'],
      DateTime.parse(json['datePrediction']),
      const Color.fromARGB(1, 1, 1, 1),
      json['favorite'],
      json['type']);
  final int id;
  final String title;
  final String message;
  final DateTime dateTime;
  final Color color;
  final bool favorite;
  final String type;
}
