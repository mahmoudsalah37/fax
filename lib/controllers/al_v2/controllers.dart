import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

const String mainDomin = 'http://192.168.40.13';
const String domin = '$mainDomin/api';

/*Data*/
//Get all data
int counter = 0;
Future<String> getData(String strPath) async {
  final http.Response response = await http.get('$domin/$strPath', headers: {
    'Access-Control-Allow-Origin': '*',
    // 'Access-Control-Allow-Credentials': 'true',
    // 'X-Requested-With': 'XMLHttpRequest'
  }).catchError((onError) => print);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load post');
  }
}

//Add data
Future<http.Response> postData(
    String strPath, Map<String, dynamic> mapData) async {
  http.Response response = await http
      .post('$domin/$strPath',
          headers: {
            'Access-Control-Allow-Origin': '*',
          },
          body: mapData)
      .catchError((onError) {
    print(onError.toString());
  });
  return response;
}

//Update data
Future<http.Response> putData(
    String strPath, Map<String, dynamic> mapData) async {
  http.Response response = await http
      .put('$domin/$strPath/${mapData["id"].toString()}',
          headers: {
            'Access-Control-Allow-Origin': '*',
          },
          body: mapData)
      .catchError((onError) => print);

  return response;
}

//Delete data
Future<bool> deleteData(String strPath, List<int> ids) async {
  bool done = false;
  String query = '';
  ids.forEach((id) => query = '${query}ids=$id&');
  await http
      .delete(
    '$domin/$strPath?$query',
  )
      .whenComplete(() {
    done = true;
  }).catchError((onError) {
    done = false;
    print(onError.toString());
  });
  return done;
}

/*Side bar*/
/*Side Navigation bar*/
void popNavigationBarMenu(BuildContext context) async {
  if (MediaQuery.of(context).size.width < 1000.0) Navigator.pop(context);
}
