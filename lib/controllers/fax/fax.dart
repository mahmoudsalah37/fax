import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/fax_model.dart';
import 'package:flutter/material.dart';

const String strPath = 'Faxes';
Future<List<FaxModel>> getDataFax() async {
  var data = await getData(strPath);
  return faxModelFromJson(data);
}

List<FaxModel> getDataSearchFax(List<FaxModel> snapshot, String strSearch) {
  List<FaxModel> dataSearch = List<FaxModel>();
  String id,
      title,
      nameSend,
      nameRecieve,
      fromDate,
      toDate,
      serialFax,
      serialFaxIntial,
      certificationNumber,
      subClass,
      personSend,
      personRecieve,
      type;
  snapshot.forEach((FaxModel data) {
    id = data.id?.toString() ?? '';
    title = data.title ?? '';
    nameSend = data.nameSend ?? '';
    nameRecieve = data.nameRecieve ?? '';
    fromDate = data.fromDate ?? '';
    toDate = data.toDate ?? '';
    serialFax = data.serialFax ?? '';
    serialFaxIntial = data.serialFaxInitial ?? '';
    certificationNumber = data.certificationNumber ?? '';
    subClass = data.subClass ?? '';
    personSend = data.personSend ?? '';
    personRecieve = data.personRecieve ?? '';
    type = data.isExport == 0 ? 'صادرات' : 'واردات';
    if (id.toLowerCase().contains(strSearch) ||
        title.toLowerCase().contains(strSearch) ||
        nameSend.toLowerCase().contains(strSearch) ||
        nameRecieve.toLowerCase().contains(strSearch) ||
        fromDate.toLowerCase().contains(strSearch) ||
        toDate.toLowerCase().contains(strSearch) ||
        serialFax.toLowerCase().contains(strSearch) ||
        serialFaxIntial.toLowerCase().contains(strSearch) ||
        certificationNumber.toLowerCase().contains(strSearch) ||
        subClass.toLowerCase().contains(strSearch) ||
        personSend.toLowerCase().contains(strSearch) ||
        personRecieve.toLowerCase().contains(strSearch) ||
        type.contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}

Future<List<String>> uploadFile() async {
  Completer<List<String>> completer = Completer<List<String>>();
  html.InputElement uploadInput = html.FileUploadInputElement();
  uploadInput.multiple = false;
  uploadInput.accept = 'application/msword, application/vnd.openxmlformats-officedocument.wordprocessingml.document';
  uploadInput.click();
  List<html.File> files = List<html.File>();
  //* onChange doesn't work on mobile safari
  uploadInput.addEventListener('change', (e) async {
    // read file content as dataURL
    files = uploadInput.files;
    Iterable<Future<String>> resultsFutures = files.map((file) {
      html.FileReader reader = html.FileReader();
      // reader.result;
      reader.readAsDataUrl(file);
      reader.onError.listen((error) => completer.completeError(error));
      return reader.onLoad.first.then((_) => reader.result);
    });

    final results = await Future.wait(resultsFutures);
    completer.complete(results);
  });
  //* need to append on mobile safari
  html.document.body.append(uploadInput);
  final List<String> data = await completer.future;
  uploadInput.remove();
  return data;
  //* this also works
  // final completer = Completer<List<String>>();
  // final InputElement input = document.createElement('input');
  // input
  //   ..type = 'file'
  //   ..multiple = true
  //   ..accept = 'image/*';
  // input.click();
  //* onChange doesn't work on mobile safari
  // input.addEventListener('change', (e) async {
  //   final List<File> files = input.files;
  //   Iterable<Future<String>> resultsFutures = files.map((file) {
  //     final reader = FileReader();
  //     reader.readAsDataUrl(file);
  //     reader.onError.listen((error) => completer.completeError(error));
  //     return reader.onLoad.first.then((_) => reader.result as String);
  //   });
  //   final results = await Future.wait(resultsFutures);
  //   completer.complete(results);
  // });
  //* need to append on mobile safari
  // document.body.append(input);
  // // input.click(); can be here
  // final List<String> images = await completer.future;
  // setState(() {
  //   _uploadedImages = images;
  // });
  // input.remove();
}

// void _upload(List<String> images) {
//   String base64Image = images.first;
//   String fileName = file.name;

//   http.post('phpEndPoint', body: {
//     "image": base64Image,
//     "name": fileName,
//   }).then((res) {
//     print(res.statusCode);
//   }).catchError((err) {
//     print(err);
//   });
// }
String image64Data(String bytes, int begin) {
  for (int i = 0; i < bytes.toString()?.length; i++) {
    if (bytes[i].contains(';')) {
      begin = ++i;
      begin += 7;
      break;
    }
  }
  if (bytes.isNotEmpty) bytes = bytes.substring(begin, bytes.length);
  return bytes;
}

// imageFromBase64String(String base64String) {
//   Uint8List bytes = Base64Codec().decode(base64String);
//   // Uint8List uint8list = base64Url.decode(
//   //     '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');
//   return Image.memory(bytes);
// }

void downloudImage(String path) {
  var a = html.document.createElement('a');
  a.setAttribute('href', '$mainDomin/data/$path');
  a.setAttribute('download', 'file.docx');
  html.document.body.append(a);
  a.click();
  a.remove();
}