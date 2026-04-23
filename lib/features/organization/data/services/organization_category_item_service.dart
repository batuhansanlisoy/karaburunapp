import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/organization/data/models/organization_category_item_model.dart';

class OrganizationCategoryItemService {
  Future<List<OrganizationCategoryItemModel>> getOrganizationCategoryItem() async {
    final url = "${ApiRoutes.organization}/category/item/list";

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
        return data.map((e) => OrganizationCategoryItemModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Organization Category Item fetch error: $e");
    }
  }
}