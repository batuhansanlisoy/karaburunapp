import '../models/activity_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';

class ActivityService {
    Future<List<Activity>> getActivity({int? villageId, int? categoryId}) async {

        final Map<String, String> queryParams = {};

        if (villageId != null) {
          queryParams["village_id"] = villageId.toString();
        }

        if (categoryId != null) {
          queryParams["category_id"] = categoryId.toString();
        }

        final url = Uri.parse("${ApiRoutes.activity}/list")
        .replace(queryParameters: queryParams);

        try {
            final response = await http.get(url);

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
