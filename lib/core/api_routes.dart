import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  // sadece base url
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? "http://localhost:3000";

  // base + organization birleşmiş hali
  static String get organization =>
      "$baseUrl/${dotenv.env['ORGANIZATION_PATH'] ?? "organization"}";

  // diğer endpointler de aynı mantıkla
  static String get user => "$baseUrl/user";
  static String get product => "$baseUrl/product";
}
