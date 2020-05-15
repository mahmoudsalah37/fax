import 'dart:async';
import 'dart:html' as html;
import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/fax_model.dart';

const String strPath = 'Faxes';
Future<List<FaxModel>> getDataFax() async {
  var data = await getData(strPath);
  return faxModelFromJson(data);
}

List<FaxModel> filterTable(List<FaxModel> faxes, int index, bool isAscending) {
  switch (index) {
    case 0:
      faxes?.sort(
          (a, b) => a.title?.toLowerCase()?.compareTo(b.title?.toLowerCase()));
      break;
    case 1:
      faxes?.sort((a, b) =>
          a.nameSend?.toLowerCase()?.compareTo(b.nameSend?.toLowerCase()));
      break;
    case 2:
      faxes?.sort((a, b) => a.nameRecieve
          ?.toLowerCase()
          ?.compareTo(b.nameRecieve?.toLowerCase()));
      break;
    case 3:
      faxes?.sort((a, b) =>
          a.fromDate?.toLowerCase()?.compareTo(b.fromDate?.toLowerCase()));
      break;
    case 4:
      faxes?.sort((a, b) =>
          a.toDate?.toLowerCase()?.compareTo(b.toDate?.toLowerCase()));
      break;
    case 5:
      faxes?.sort((a, b) =>
          a.serialFax?.toLowerCase()?.compareTo(b.serialFax?.toLowerCase()));
      break;
    case 6:
      faxes?.sort((a, b) => a.serialFaxInitial
          ?.toLowerCase()
          ?.compareTo(b.serialFaxInitial?.toLowerCase()));
      break;
    case 7:
      faxes?.sort((a, b) => a.certificationNumber
          ?.toLowerCase()
          ?.compareTo(b.certificationNumber?.toLowerCase()));
      break;
    case 8:
      faxes?.sort((a, b) =>
          a.subClass?.toLowerCase()?.compareTo(b.subClass?.toLowerCase()));
      break;
    case 9:
      faxes?.sort((a, b) =>
          a.personSend?.toLowerCase()?.compareTo(b.personSend?.toLowerCase()));
      break;
    case 10:
      faxes?.sort((a, b) => a.personRecieve
          ?.toLowerCase()
          ?.compareTo(b.personRecieve?.toLowerCase()));
      break;
    case 11:
      faxes?.sort((a, b) => a.personSubRecieve?.compareTo(b.personSubRecieve));
      break;
    case 12:
      faxes?.sort((a, b) => a.isExport?.compareTo(b.isExport));
      break;
    default:
      return faxes;
  }

  if (!isAscending) faxes = faxes.reversed.toList();
  return faxes;
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

// Future<List<String>> uploadFile() async {
//   Completer<List<String>> completer = Completer<List<String>>();
//   html.InputElement uploadInput = html.FileUploadInputElement();
//   uploadInput.multiple = false;
//   uploadInput.accept = 'application/msword, application/vnd.openxmlformats-officedocument.wordprocessingml.document';
//   uploadInput.click();
//   List<html.File> files = List<html.File>();
//   //* onChange doesn't work on mobile safari
//   uploadInput.addEventListener('change', (e) async {
//     // read file content as dataURL
//     files = uploadInput.files;
//     Iterable<Future<String>> resultsFutures = files.map((file) {
//       html.FileReader reader = html.FileReader();
//       // reader.result;
//       reader.readAsDataUrl(file);
//       reader.onError.listen((error) => completer.completeError(error));
//       return reader.onLoad.first.then((_) => reader.result);
//     });

//     final results = await Future.wait(resultsFutures);
//     completer.complete(results);
//   });
//   //* need to append on mobile safari
//   html.document.body.append(uploadInput);
//   final List<String> data = await completer.future;
//   uploadInput.remove();
//   return data;
//   //* this also works
//   // final completer = Completer<List<String>>();
//   // final InputElement input = document.createElement('input');
//   // input
//   //   ..type = 'file'
//   //   ..multiple = true
//   //   ..accept = 'image/*';
//   // input.click();
//   //* onChange doesn't work on mobile safari
//   // input.addEventListener('change', (e) async {
//   //   final List<File> files = input.files;
//   //   Iterable<Future<String>> resultsFutures = files.map((file) {
//   //     final reader = FileReader();
//   //     reader.readAsDataUrl(file);
//   //     reader.onError.listen((error) => completer.completeError(error));
//   //     return reader.onLoad.first.then((_) => reader.result as String);
//   //   });
//   //   final results = await Future.wait(resultsFutures);
//   //   completer.complete(results);
//   // });
//   //* need to append on mobile safari
//   // document.body.append(input);
//   // // input.click(); can be here
//   // final List<String> images = await completer.future;
//   // setState(() {
//   //   _uploadedImages = images;
//   // });
//   // input.remove();
// }

// // void _upload(List<String> images) {
// //   String base64Image = images.first;
// //   String fileName = file.name;

// //   http.post('phpEndPoint', body: {
// //     "image": base64Image,
// //     "name": fileName,
// //   }).then((res) {
// //     print(res.statusCode);
// //   }).catchError((err) {
// //     print(err);
// //   });
// // }
// String image64Data(String bytes, int begin) {
//   for (int i = 0; i < bytes.toString()?.length; i++) {
//     if (bytes[i].contains(';')) {
//       begin = ++i;
//       begin += 7;
//       break;
//     }
//   }
//   if (bytes.isNotEmpty) bytes = bytes.substring(begin, bytes.length);
//   return bytes;
// }

// void downloudImage(String path) {
//   var a = html.document.createElement('a');
//   a.setAttribute('href', '$mainDomin/data/$path');
//   a.setAttribute('download', 'file.docx');
//   html.document.body.append(a);
//   a.click();
//   a.remove();
// }