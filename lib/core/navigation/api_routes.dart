import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  static String get scheme => dotenv.env['SCHEME']!;
  static String get host => dotenv.env['HOST']!;
  static String get prefix => dotenv.env['API_PREFIX']!;
  
  static String get _portStr {
    final port = dotenv.env['PORT'];
    if (port == null || port.isEmpty || port == '80' || port == '443') {
      return "";
    }
    return ":$port";
  }

  static String get _rawBase => "$scheme://$host$_portStr";

  static String get baseUrl => "$_rawBase/$prefix";
  static String get fileUrl => _rawBase;

  static String get explore =>
    "$baseUrl/${dotenv.env['EXPLORE_PATH'] ?? 'explore'}";

  static String get upload =>
    "$_rawBase/${dotenv.env['UPLOAD_PATH'] ?? 'upload'}";

  static String get organization =>
    "$baseUrl/${dotenv.env['ORGANIZATION_PATH'] ?? 'organization'}";

  static String get beach =>
    "$baseUrl/${dotenv.env['BEACH_PATH'] ?? 'beach'}";

  static String get notification =>
    "$baseUrl/${dotenv.env['NOTIFICATION_PATH'] ?? 'notification'}";

  static String get localProducer =>
    "$baseUrl/${dotenv.env['LOCAL_PRODUCER_PATH'] ?? 'local_producer'}";

  static String get place =>
    "$baseUrl/${dotenv.env['PLACE_PATH'] ?? 'place'}";

  static String get village =>
    "$baseUrl/${dotenv.env['VILLAGE_PATH'] ?? 'village'}";

  static String get activity =>
    "$baseUrl/${dotenv.env['ACTIVITY_PATH'] ?? 'activity'}";
  
  static String get config =>
    "$baseUrl/${dotenv.env['CONFIG_PATH'] ?? 'config'}";

  static String get feedback =>
    "$_rawBase/${dotenv.env['FEEDBACK_PATH'] ?? 'feedback'}";

  static String get request =>
    "$_rawBase/${dotenv.env['REQUEST_PATH'] ?? 'request'}";
}