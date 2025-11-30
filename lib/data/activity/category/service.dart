import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/api_routes.dart';
import 'model.dart';

class ActivityCategoryService {
  Future<List<ActivityCategory>> getCategories() async {
    final url = Uri.parse("${ApiRoutes.activity}/category/list");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ActivityCategory.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Activity fetch error: $e");
    }
  }
}
