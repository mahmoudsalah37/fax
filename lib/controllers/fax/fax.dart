import 'dart:async';
// import 'dart:convert';
import 'dart:html' as html;
// import 'dart:io';
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/fax_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

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

Future<List<String>> setImage() async {
  Completer<List<String>> completer = Completer<List<String>>();
  html.InputElement uploadInput = html.FileUploadInputElement();
  uploadInput.multiple = false;
  uploadInput.accept = 'image/*';
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
  final List<String> images = await completer.future;
  uploadInput.remove();
  return images;
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
