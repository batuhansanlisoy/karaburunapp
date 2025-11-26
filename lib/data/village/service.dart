import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_routes.dart';
import 'model.dart';

class VillageService {
  Future<List<Village>> getVillages() async {
    final url = Uri.parse("${ApiRoutes.village}/list");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Village.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Place fetch error: $e");
    }
  }
}
