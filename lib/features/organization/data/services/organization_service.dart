import '../models/organization_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:karaburun/core/navigation/api_routes.dart';

class OrganizationService {
  Future<List<OrganizationModel>> getOrganizations({ int? categoryId }) async {
    
    final Map<String, String> queryParams = {};

    if (categoryId != null) {
      queryParams["category_id"] = categoryId.toString();
    }
    
    final url = Uri.parse("${ApiRoutes.organization}/list")
      .replace(queryParameters: queryParams);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => OrganizationModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Organization fetch error: $e");
    }
  }
}
