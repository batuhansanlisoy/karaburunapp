import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/features/place/data/models/place_model.dart';

class PlaceService {

  Future<Place> getSingle(int placeId) async {
    final url = Uri.parse("${ApiRoutes.place}/$placeId/single");

    try {
      final response = await http.get(
        url,
        headers: {
          "X-API-KEY": dotenv.env['MOBILE_API_KEY'] ?? '',
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Place.fromJson(data);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Single place fetch error: $e");
    }
  }

  Future<List<Place>> getPlaces({int? villageId, List<int>? ids}) async {
    final Map<String, String> queryParams = {};

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    if (ids != null && ids.isNotEmpty) {
      queryParams["ids"] = ids.join(',');
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