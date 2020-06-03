import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'dart:async';
import 'package:http_parser/http_parser.dart';

const String mainDomin = 'https://localhost:44392';
// const String mainDomin = 'http://192.168.40.13';
const String domin = '$mainDomin/api';
List<int> selectedFile;
Uint8List _bytesData;
html.File file;
String namePageFile;
int idFile;
const Map<String, String> _headers = {
  'X-Requested-With': 'XMLHttpRequest',
  'Access-Controle-Allow-Origin': '*'
};
final List<ContentType> mimeTypes = [
  ContentType('.bmp', 'image/bmp'),
  ContentType('.gif', 'image/gif'),
  ContentType('.jpeg', 'image/jpeg'),
  ContentType('.jpg', 'image/jpeg'),
  ContentType('.png', 'image/png'),
  ContentType('.tif', 'image/tiff'),
  ContentType('.tiff', 'image/tiff'),
  ContentType('.doc', 'application/msword'),
  ContentType('.docx',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
  ContentType('.pdf', 'application/pdf'),
  ContentType('.ppt', 'application/vnd.ms-powerpoint'),
  ContentType('.pptx',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation'),
  ContentType('.xlsx',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  ContentType('.xls', 'application/vnd.ms-excel'),
  ContentType('.csv', 'text/csv'),
  ContentType('.xml', 'text/xml'),
  ContentType('.txt', 'text/plain'),
  ContentType('.zip', 'application/zip'),
  ContentType('.ogg', 'application/ogg'),
  ContentType('.mp3', 'audio/mpeg'),
  ContentType('.wma', 'audio/x-ms-wma'),
  ContentType('.wav', 'audio/x-wav'),
  ContentType('.wmv', 'audio/x-ms-wmv'),
  ContentType('.swf', 'application/x-shockwave-flash'),
  ContentType('.avi', 'video/avi'),
  ContentType('.mp4', 'video/mp4'),
  ContentType('.mpeg', 'video/mpeg'),
  ContentType('.mpg', 'video/mpeg'),
  ContentType('.qt', 'video/quicktime')
];
/*Data*/
//Get all data
int counter = 0;
Future<String> getData(String strPath) async {
  final http.Response response =
      await http.get('$domin/$strPath', headers: _headers);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load post');
  }
}

//Add data
Future<http.Response> postData(
    String strPath, Map<String, dynamic> mapData) async {
  http.Response response =
      await http.post('$domin/$strPath', body: mapData).catchError((onError) {
    print(onError.toString());
  });
  return response;
}

//Update data
Future<bool> putData(String strPath, Map<String, dynamic> mapData) async {
  bool done = false;

  await http
      .put('$domin/$strPath', headers: _headers, body: mapData)
      .whenComplete(() {
    done = true;
  }).catchError((onError) {
    print(onError.toString());
  });

  return done;
}

Future<http.Response> editData(
    String strPath, Map<String, dynamic> mapData) async {
  http.Response response = await http
      .put('$domin/$strPath', headers: _headers, body: mapData)
      .catchError((onError) {
    print(onError.toString());
  });

  return response;
}

//Delete data
Future<bool> deleteData(String strPath, List<int> ids) async {
  bool done = false;
  String query = '';
  ids.forEach((id) => query = '${query}id=$id&');
  await http.delete('$domin/$strPath/deleteList?$query').whenComplete(() {
    done = true;
  }).catchError((onError) {
    done = false;
    print(onError.toString());
  });
  return done;
}

Future<http.Response> removeData(String strPath, List<int> ids) async {
  String query = '';
  ids.forEach((id) => query = '${query}id=$id&');
  http.Response response = await http
      .delete('$domin/$strPath/deleteList?$query', headers: _headers)
      .catchError((onError) {
    print(onError.toString());
  });
  return response;
}

/*Side bar*/
/*Side Navigation bar*/
void popNavigationBarMenu(BuildContext context) async {
  if (MediaQuery.of(context).size.width < 1000.0) Navigator.pop(context);
}

void downloudFile(String fileName) {
  var a = html.document.createElement('a');

  a.setAttribute('href', '$mainDomin/data/$fileName');
  a.setAttribute('target', '_blank');
  a.setAttribute('download', 'file.docx');
  html.document.body.append(a);
  a.click();
  a.remove();
}

void _handleResult(Object result) {
  _bytesData = Base64Decoder().convert(result.toString().split(",").last);
  selectedFile = _bytesData;
}

startWebFilePicker(
    BuildContext context, GlobalKey<FormState> globalKeyloading) {
  html.InputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept =
      'image/*, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/pdf';
  uploadInput.multiple = false;
  uploadInput.draggable = true;
  uploadInput.click();
  // Dialogs.showLoadingDialog(context, globalKeyloading);
  uploadInput.onChange.listen((e) {
    final files = uploadInput.files;
    file = files[0];
    final reader = new html.FileReader();

    reader.onLoadEnd.listen((e) {
      if (file != null) _handleResult(reader.result);
      // Navigator.of(globalKeyloading.currentContext, rootNavigator: true).pop();
    });
    reader.readAsDataUrl(file);
  });
}

uploadFile() {
  var url = Uri.parse("$mainDomin/api/FileUpload?id=$idFile");
  var request = new http.MultipartRequest("POST", url);
  request.headers.addAll(_headers);
  request.files.add(http.MultipartFile.fromBytes('file', selectedFile,
      contentType: MediaType('application', 'octet-stream'),
      filename: 'upload${getContentType(file.type)}'));

  request.send().then((response) {
    print("test");
    print(response.statusCode);
    if (response.statusCode == 200) {
      print("Uploaded!");
    }
  });
  selectedFile = null;
}

class ContentType {
  String contentType;
  String type;
  ContentType(this.contentType, this.type);
}

getContentType(String type) {
  for (var x in mimeTypes) {
    if (x.type == type) return x.contentType;
  }
  return '';
}

String numberValidator(String value) {
  if (value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if (n == null) {
    return 'not a valid number';
  }
  return null;
}
