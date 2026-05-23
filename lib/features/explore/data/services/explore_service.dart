import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/explore/data/models/explore_model.dart';

class ExploreService {
  Future<List<ExploreModel>> getExploreFeed({
    bool? shuffle,
    bool? isActive,
    String? itemType,
    int? itemId,
  }) async {
    final Map<String, String> queryParams = {};

    if (shuffle != null) {
      queryParams["shuffle"] = shuffle.toString();
    }

    if (isActive != null) {
      queryParams["is_active"] = isActive.toString();
    }

    if (itemType != null) {
      queryParams["item_type"] = itemType.toString();
    }

    if (itemId != null) {
      queryParams["item_id"] = itemId.toString();
    }

    final url = Uri.parse("${ApiRoutes.explore}/list")
      .replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: {
          "X-API-KEY": dotenv.env['MOBILE_API_KEY'] ?? '',
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ExploreModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Explore Feed data fetch error: $e");
    }
  }
}