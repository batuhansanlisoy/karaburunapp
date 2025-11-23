import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_routes.dart';
import 'model.dart';

class PlaceService {
  Future<List<Place>> getPlaces() async {
    final url = Uri.parse("${ApiRoutes.place}/list");

    try {
      final response = await http.get(url);

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
