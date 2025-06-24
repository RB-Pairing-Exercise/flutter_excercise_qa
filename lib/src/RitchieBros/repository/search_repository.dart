import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:flutter_excercise/src/RitchieBros/services/rb_api_service.dart';

class SearchtRepository {
  final RbApiService rbApiService;

  SearchtRepository(this.rbApiService);

  Future<List<RBItem>> getSearchResult({int from = 0, int size = 20}) async {
    List<RBItem> result = await rbApiService.fetchAssets(
      from: from,
      size: size,
    );
    return result;
  }
}
