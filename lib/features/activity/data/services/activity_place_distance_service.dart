import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';
import '../models/activity_place_distance_model.dart';

class ActivityPlaceDistanceService {
  Future<List<ActivityPlaceDistanceModel>> getNearestPlace({ required int activityId}) async {
    final url = Uri.parse("${ApiRoutes.activity}/$activityId/nearest-places");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List distances = data['distances'] ?? [];

        return distances
            .map((e) => ActivityPlaceDistanceModel.fromJson(e))
            .toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Beach fetch error: $e");
    }
  }
}
