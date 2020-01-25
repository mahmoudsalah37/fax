// To parse this JSON data, do
//
//     final rankModel = rankModelFromJson(jsonString);

import 'dart:convert';

List<RankModel> rankModelFromJson(String str) => List<RankModel>.from(json.decode(str).map((x) => RankModel.fromJson(x)));

String rankModelToJson(List<RankModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RankModel {
    int id;
    String name;
    String description;

    RankModel({
        this.id,
        this.name,
        this.description,
    });

    factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
    };
}
