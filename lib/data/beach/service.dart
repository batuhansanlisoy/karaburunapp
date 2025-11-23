import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_routes.dart';
import 'model.dart';

class BeachService {
  Future<List<Beach>> getBeach() async {
    final url = Uri.parse("${ApiRoutes.beach}/list");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Beach.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Beach fetch error: $e");
    }
  }
}
