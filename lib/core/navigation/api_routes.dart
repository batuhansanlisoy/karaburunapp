import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {

  static String get scheme => dotenv.env['SCHEME'] ?? 'http';
  static String get host => dotenv.env['HOST'] ?? 'localhost';
  static int get port => int.tryParse(dotenv.env['PORT'] ?? '3000') ?? 3000;

  static String get baseUrl => "$scheme://$host:$port";

  static String get upload =>
      "$baseUrl/${dotenv.env['UPLOAD_PATH'] ?? 'upload'}";

  static String get organization =>
      "$baseUrl/${dotenv.env['ORGANIZATION_PATH'] ?? 'organization'}";

  static String get beach =>
      "$baseUrl/${dotenv.env['BEACH_PATH'] ?? 'beach'}";

  static String get place =>
      "$baseUrl/${dotenv.env['PLACE_PATH'] ?? 'place'}";

  static String get village =>
      "$baseUrl/${dotenv.env['VILLAGE_PATH'] ?? 'village'}";

  static String get activity =>
      "$baseUrl/${dotenv.env['ACTIVITY_PATH'] ?? 'activity'}";
}