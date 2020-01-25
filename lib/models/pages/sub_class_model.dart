// To parse this JSON data, do
//
//     final subClassModel = subClassModelFromJson(jsonString);

import 'dart:convert';

List<SubClassModel> subClassModelFromJson(String str) => List<SubClassModel>.from(json.decode(str).map((x) => SubClassModel.fromJson(x)));

String subClassModelToJson(List<SubClassModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubClassModel {
    MainClass mainClass;
    int id;
    String name;
    int idMainClass;

    SubClassModel({
        this.mainClass,
        this.id,
        this.name,
        this.idMainClass,
    });

    factory SubClassModel.fromJson(Map<String, dynamic> json) => SubClassModel(
        mainClass: MainClass.fromJson(json["main_class"]),
        id: json["id"],
        name: json["name"],
        idMainClass: json["id_main_class"],
    );

    Map<String, dynamic> toJson() => {
        "main_class": mainClass.toJson(),
        "id": id,
        "name": name,
        "id_main_class": idMainClass,
    };
}

class MainClass {
    int id;
    String name;

    MainClass({
        this.id,
        this.name,
    });

    factory MainClass.fromJson(Map<String, dynamic> json) => MainClass(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
