import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:karaburun/core/navigation/api_routes.dart';
import 'package:karaburun/features/notification/data/models/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotification({
    bool? isActive,
    List<int>? ids
  }) async {
    final Map<String, String> queryParams = {};

    if (isActive != null) {
      queryParams["is_active"] = isActive.toString();
    }

    if (ids != null && ids.isNotEmpty) {
      queryParams["ids"] = ids.join(',');
    }

    final url = Uri.parse("${ApiRoutes.notification}/list")
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
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Notification fetch error: $e");
    }
  }
}