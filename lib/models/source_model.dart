import 'package:kisisel_asistan/models/news_model.dart';
class Source {
  String? id;
  String? name;

  Source ({required this.id, required this.name});

  factory Source.fromJson(Map<String,dynamic> json) {
    return Source(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}