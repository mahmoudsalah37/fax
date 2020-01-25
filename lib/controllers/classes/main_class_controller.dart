import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/main_class_model.dart';

const String strPath = 'MainCLass';
Future<List<MainClassModel>> getDataMaimClasses() async {
  var data = await getData(strPath);
  return mainClassModelFromJson(data);
}

List<MainClassModel> getDataSearch(
    List<MainClassModel> snapshot, String strSearch) {
  List<MainClassModel> dataSearch = List<MainClassModel>();
  snapshot.forEach((MainClassModel data) {
    String id = data.id?.toString() ?? '';
    String region = data.name ?? '';
    if (id.toLowerCase().contains(strSearch) ||
        region.toLowerCase().contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}
