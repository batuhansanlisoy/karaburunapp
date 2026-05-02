import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/beach/data/models/beach_model.dart';

class BeachService {
  Future<List<Beach>> getBeach({
    int? villageId,
    bool? highlight,
    List<int>? ids
  }) async {
    final Map<String, String> queryParams = {};

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    if (highlight != null) {
      queryParams["highlight"] = highlight.toString();
    }

    if (ids != null && ids.isNotEmpty) {
      queryParams["ids"] = ids.join(',');
    }

    final url = Uri.parse("${ApiRoutes.beach}/list")
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
        return data.map((e) => Beach.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Beach fetch error: $e");
    }
  }
}