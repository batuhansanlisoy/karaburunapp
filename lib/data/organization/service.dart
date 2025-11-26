import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_routes.dart';
import 'model.dart';

class OrganizationService {
  Future<List<Organization>> getOrganizations({int? categoryId}) async {
    
    final base = "${ApiRoutes.organization}/list";
    final url = categoryId != null 
        ? Uri.parse(base).replace(queryParameters: {"category_id": categoryId.toString()})
        : Uri.parse(base);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => Organization.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Organization fetch error: $e");
    }
  }
}
