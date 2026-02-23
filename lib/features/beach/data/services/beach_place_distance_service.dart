import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/beach/data/models/beach_place_distance_model.dart';

class BeachPlaceDistanceService {
  Future<List<BeachPlaceDistanceModel>> getNearestPlaces({ required int beachId}) async {
    final url = Uri.parse("${ApiRoutes.beach}/$beachId/nearest-places");

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
        final List distances = data['distances'] ?? [];

        return distances
          .map((e) => BeachPlaceDistanceModel.fromJson(e))
          .toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Beach fetch error: $e");
    }
  }
}
