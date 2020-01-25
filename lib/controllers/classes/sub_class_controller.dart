import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/sub_class_model.dart';

const String strPath = 'SubClass';
Future<List<SubClassModel>> getDataSubClasses() async {
  var data = await getData(strPath);
  return subClassModelFromJson(data);
}

List<SubClassModel> getDataSearchSubClass(
    List<SubClassModel> snapshot, String strSearch) {
  List<SubClassModel> dataSearch = List<SubClassModel>();
  snapshot.forEach((SubClassModel data) {
    String id = data.id?.toString() ?? '';
    String name = data.name ?? '';
    String mainClassName = data.mainClass.name ?? '';
    if (id.toLowerCase().contains(strSearch) ||
        name.toLowerCase().contains(strSearch) ||
        mainClassName.toLowerCase().contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}
