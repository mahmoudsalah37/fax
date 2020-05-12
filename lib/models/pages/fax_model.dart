// To parse this JSON data, do
//
//     final faxModel = faxModelFromJson(jsonString);

import 'dart:convert';

List<FaxModel> faxModelFromJson(String str) =>
    List<FaxModel>.from(json.decode(str).map((x) => FaxModel.fromJson(x)));

String faxModelToJson(List<FaxModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FaxModel {
  int id;
  String title;
  String nameSend;
  String nameRecieve;
  String fromDate;
  String toDate;
  String serialFax;
  String serialFaxInitial;
  String certificationNumber;
  String subClass;
  String personSend;
  String personRecieve;
  String personSubRecieve;
  int isExport;
  String images;

  FaxModel({
    this.id,
    this.title,
    this.nameSend,
    this.nameRecieve,
    this.fromDate,
    this.toDate,
    this.serialFax,
    this.serialFaxInitial,
    this.certificationNumber,
    this.subClass,
    this.personSend,
    this.personRecieve,
    this.personSubRecieve,
    this.isExport,
    this.images,
  });

  factory FaxModel.fromJson(Map<String, dynamic> json) => FaxModel(
        id: json["id"],
        title: json["title"],
        nameSend: json["name_send"],
        nameRecieve: json["name_recieve"],
        fromDate: json["from_date"],
        toDate: json["to_date"],
        serialFax: json["serial_fax"],
        serialFaxInitial: json["serial_fax_initial"],
        certificationNumber: json["certification_number"],
        subClass: json["sub_class"],
        personSend: json["person_send"],
        personRecieve: json["person_recieve"],
        personSubRecieve: json["person_sub_recieve"],
        isExport: json["is_export"],
        images: json["images"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "name_send": nameSend,
        "name_recieve": nameRecieve,
        "from_date": fromDate,
        "to_date": toDate,
        "serial_fax": serialFax,
        "serial_fax_initial": serialFaxInitial,
        "certification_number": certificationNumber,
        "sub_class": subClass,
        "person_send": personSend,
        "person_recieve": personRecieve,
        "person_sub_recieve": personSubRecieve,
        "is_export": isExport,
        "images": images,
      };
}
