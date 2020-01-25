import 'package:fax/models/pages/user_model.dart';
import 'package:fax/controllers/al_v2/controllers.dart';

const String strPath = 'Users';

Future<List<UsersModel>> getDataUsers() async {
  var data = await getData(strPath);
  return usersModelFromJson(data);
}

String permissionSwitch(int permission) {
  String value = 'قراءة';
  if (permission >= 3) {
    value = 'أدمن';
    return value;
  }
  if (permission >= 1) value = '$value, إضافة';
  if (permission == 2) value = '$value, تعديل';
  return value;
}

List<UsersModel> getDataSearch(List<UsersModel> snapshot, String strSearch) {
  List<UsersModel> dataSearch = List<UsersModel>();
  snapshot.forEach((UsersModel data) {
    String id = data.id?.toString() ?? '';
    String userName = data.userName ?? '';
    String password = data.password ?? '';
    String permissions = permissionSwitch(data.permission);
    if (id.toLowerCase().contains(strSearch) ||
        userName.toLowerCase().contains(strSearch) ||
        password.toLowerCase().contains(strSearch) ||
        permissions.contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}
