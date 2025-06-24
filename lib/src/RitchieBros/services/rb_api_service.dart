import 'dart:convert';
import 'package:flutter_excercise/src/RitchieBros/models/rb_item.dart';
import 'package:http/http.dart' as http;

class RbApiService {
  static const String _baseUrl =
      'https://api.marketplace.ritchiebros.com/marketplace-listings-service/v1/api';

  Future<List<RBItem>> fetchAssets({int from = 0, int size = 20}) async {
    final url = Uri.parse('$_baseUrl/search');

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'from': from,
      'size': size,
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return (data['records'] as List)
          .map((item) => RBItem.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load items: ${response.statusCode}');
    }
  }
}
