import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/organization/data/models/organization_model.dart';

class OrganizationService {

  Future<OrganizationModel> getSingle(int orgId) async {
    final url = Uri.parse("${ApiRoutes.organization}/$orgId/single");

    try {
      final response = await http.get(
        url,
        headers: {
          "X-API-KEY": dotenv.env['MOBILE_API_KEY'] ?? '',
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        
        return OrganizationModel.fromJson(data);
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Single organization fetch error: $e");
    }
  }

  Future<List<OrganizationModel>> getOrganizations({
    int? categoryId,
    bool? highlight,
    bool? isActive,
    int? villageId,
    bool? subCategoryInfo,
    List<int>? ids,
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

    if (ids != null && ids.isNotEmpty) {
      queryParams["ids"] = ids.join(',');
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
