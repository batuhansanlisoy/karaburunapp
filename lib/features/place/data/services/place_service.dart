import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';

class PlaceService {
  Future<List<Place>> getPlaces({int? villageId}) async {
    final Map<String, String> queryParams = {};

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    final url = Uri.parse("${ApiRoutes.place}/list")
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
        return data.map((e) => Place.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Place fetch error: $e");
    }
  }
}