import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/village/data/models/village_model.dart';

class VillageService {
  Future<List<Village>> getVillages() async {
    final url = Uri.parse("${ApiRoutes.village}/list");

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
        return data.map((e) => Village.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Place fetch error: $e");
    }
  }
}
