import 'dart:convert';

class Predictions {
  Predictions({
    this.id,
    this.title,
    this.message,
    this.datePrediction,
    this.type,
    this.favorite,
    this.createdAt,
    //this.updatedAt,
    //this.customerId,
  });

  int id;
  String title;
  String message;
  DateTime datePrediction;
  int type;
  bool favorite;
  DateTime createdAt;
  //DateTime updatedAt;
  //int customerId;


/*  id: json["id"],
  title: json["title"],
  message: json["message"],
  datePrediction: DateTime.parse(json["datePrediction"]),
  type: json["type"],
  favorite: json["favorite"],*/
  factory Predictions.fromJson(Map<String, dynamic> json) => Predictions(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        datePrediction: DateTime.parse(json["datePrediction"]),
        type: json["type"],
        favorite: (json["favorite"] as String) == '1',
        createdAt: DateTime.parse(json["datePrediction"]),
        //updatedAt: DateTime.parse(json["updatedAt"]),
        //customerId: json["customerId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "datePrediction": datePrediction.toIso8601String(),
        "type": type,
        "favorite": favorite,
        "createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
        //"customerId": customerId,
      };

  static List<Predictions> predictionsFromJson(String str) =>
      List<Predictions>.from(
          json.decode(str).map((x) => Predictions.fromJson(x)));
}
