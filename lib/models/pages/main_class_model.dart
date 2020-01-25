// To parse this JSON data, do
//
//     final mainClassModel = mainClassModelFromJson(jsonString);

import 'dart:convert';

List<MainClassModel> mainClassModelFromJson(String str) => List<MainClassModel>.from(json.decode(str).map((x) => MainClassModel.fromJson(x)));

String mainClassModelToJson(List<MainClassModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MainClassModel {
    int id;
    String name;

    MainClassModel({
        this.id,
        this.name,
    });

    factory MainClassModel.fromJson(Map<String, dynamic> json) => MainClassModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
