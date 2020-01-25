import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/people_model.dart';

const String strPath = 'Person';
Future<List<PeopleModel>> getDataPeople() async {
  var data = await getData(strPath);
  return peopleModelFromJson(data);
}

List<PeopleModel> getDataSearch(List<PeopleModel> snapshot, String strSearch) {
  List<PeopleModel> dataSearch = List<PeopleModel>();
  snapshot.forEach((PeopleModel data) {
    String id = data.id?.toString() ?? '';
    String rank = data.rank.name ?? '';
    String name = data.name ?? '';
    String description = data.description ?? '';
    if (id.toLowerCase().contains(strSearch) ||
        rank.toLowerCase().contains(strSearch) ||
        name.toLowerCase().contains(strSearch) ||
        description.toLowerCase().contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}
