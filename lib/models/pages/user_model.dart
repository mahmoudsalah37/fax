// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

List<UsersModel> usersModelFromJson(String str) => List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromJson(x)));

String usersModelToJson(List<UsersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UsersModel {
    int id;
    String userName;
    String password;
    int permission;

    UsersModel({
        this.id,
        this.userName,
        this.password,
        this.permission,
    });

    factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        userName: json["user_name"],
        password: json["password"],
        permission: json["permission"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "password": password,
        "permission": permission,
    };
}
