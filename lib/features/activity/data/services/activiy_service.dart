import '../models/activity_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ActivityService {

  Future<Activity> getSingle(int activityId) async {
    final url = Uri.parse("${ApiRoutes.activity}/$activityId/single");

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
        return Activity.fromJson(data);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Single activity fetch error: $e");
    }
  }

  Future<List<Activity>> getActivity({
    int? villageId,
    int? categoryId,
    List<int>? ids,
    bool? onlyUpcoming
  }) async {
    final Map<String, String> queryParams = {};

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    if (categoryId != null) {
      queryParams["category_id"] = categoryId.toString();
    }

    if (ids != null && ids.isNotEmpty) {
      queryParams["ids"] = ids.join(',');
    }

    if (onlyUpcoming != null) {
      queryParams["onlyUpcoming"] = onlyUpcoming.toString();
    }

    final url = Uri.parse("${ApiRoutes.activity}/list")
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
        return data.map((e) => Activity.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Activity fetch error: $e");
    }
  }
}