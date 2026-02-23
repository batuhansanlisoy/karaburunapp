import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/featured/data/models/featured_organization_model.dart';

class FeaturedOrganizationService {
  Future<List<FeaturedOrganizationModel>> getFeaturedOrgs({ int? organizationId, bool orgInfo = false }) async {

    final Map<String, String> queryParams = {};

    if (organizationId != null) {
      queryParams["organization_id"] = organizationId.toString();
    }

    if (orgInfo == true) {
      queryParams["org_info"] = "true";
    }

    final url = Uri.parse("${ApiRoutes.organization}/featured")
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
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => FeaturedOrganizationModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Featured Organization fetch error: $e");
    }
  }
}
