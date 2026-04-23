import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/local_producer/data/models/local_producer_model.dart';

class LocalProducerService {
  Future<List<LocalProducerModel>> getLocalProducer({
    bool? isActive,
    bool? highlight,
    int? villageId
  }) async {
    final Map<String, String> queryParams = {};

    if (villageId != null) {
      queryParams["village_id"] = villageId.toString();
    }

    if (isActive != null) {
      queryParams["is_active"] = isActive.toString();
    }

    if (highlight != null) {
      queryParams["highlight"] = highlight.toString();
    }

    final url = Uri.parse("${ApiRoutes.localProducer}/list")
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
        return data.map((e) => LocalProducerModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Local Producer fetch error: $e");
    }
  }
}