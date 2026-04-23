import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';

class OrganizationService {
  Future<List<OrganizationModel>> getOrganizations({
    int? categoryId,
    bool? highlight,
    bool? isActive,
    int? villageId,
    bool? subCategoryInfo
  }) async {
    
    final Map<String, String> queryParams = {};

    if (categoryId != null) {
      queryParams["category_id"] = categoryId.toString();
    }

    if (highlight != null) {
      queryParams["highlight"] = highlight.toString();
    }

    if (isActive != null) {
      queryParams["is_active"] = isActive.toString();
    }

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    if (subCategoryInfo != null) {
      queryParams["sub_category_info"] = subCategoryInfo.toString();
    }
    
    final url = Uri.parse("${ApiRoutes.organization}/list")
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
        return data.map((e) => OrganizationModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Organization fetch error: $e");
    }
  }
}
