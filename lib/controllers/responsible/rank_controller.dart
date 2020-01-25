import 'package:fax/controllers/al_v2/controllers.dart';
import 'package:fax/models/pages/rank_model.dart';

const String strPath = 'Rank';
Future<List<RankModel>> getDataRank() async {
  var data = await getData(strPath);
  return rankModelFromJson(data);
}

List<RankModel> getDataSearch(List<RankModel> snapshot, String strSearch) {
  List<RankModel> dataSearch = List<RankModel>();
  snapshot.forEach((RankModel data) {
    String id = data.id?.toString() ?? '';
    String name = data.name ?? '';
    String description = data.description ?? '';
    if (id.toLowerCase().contains(strSearch) ||
        name.toLowerCase().contains(strSearch) ||
        description.toLowerCase().contains(strSearch)) {
      dataSearch.add(data);
    }
  });
  return dataSearch;
}
