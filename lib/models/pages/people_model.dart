// To parse this JSON data, do
//
//     final peopleModel = peopleModelFromJson(jsonString);

import 'dart:convert';

List<PeopleModel> peopleModelFromJson(String str) => List<PeopleModel>.from(json.decode(str).map((x) => PeopleModel.fromJson(x)));

String peopleModelToJson(List<PeopleModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PeopleModel {
    Rank rank;
    int id;
    int idRank;
    String name;
    String description;

    PeopleModel({
        this.rank,
        this.id,
        this.idRank,
        this.name,
        this.description,
    });

    factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        rank: Rank.fromJson(json["rank"]),
        id: json["id"],
        idRank: json["id_rank"],
        name: json["name"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "rank": rank.toJson(),
        "id": id,
        "id_rank": idRank,
        "name": name,
        "description": description,
    };
}

class Rank {
    int id;
    String name;
    String description;

    Rank({
        this.id,
        this.name,
        this.description,
    });

    factory Rank.fromJson(Map<String, dynamic> json) => Rank(
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
