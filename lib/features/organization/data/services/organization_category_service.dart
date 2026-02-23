import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/organization/data/models/organization_category_model.dart';

class OrganizationCategoryService {
  Future<List<OrganizationCategoryModel>> getOrganizationCategory() async {
    final url = "${ApiRoutes.organization}/category/list";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "X-API-KEY": dotenv.env['MOBILE_API_KEY'] ?? '',
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => OrganizationCategoryModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Organization Category fetch error: $e");
    }
  }
}