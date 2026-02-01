import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';
import '../models/place_activity_distance_model.dart';

class PlaceActivityDistanceService {
  Future<List<PlaceActivityDistanceModel>> getNearestActivities({ required int placeId}) async {
    final url = Uri.parse("${ApiRoutes.place}/$placeId/nearest-activity");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List distances = data['distances'] ?? [];

        return distances
            .map((e) => PlaceActivityDistanceModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Place Actvitiy Distance Error: $e");
    }
  }
}
