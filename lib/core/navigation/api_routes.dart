import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {

  static String get scheme => dotenv.env['SCHEME'] ?? 'http';
  static String get host => dotenv.env['HOST'] ?? 'localhost';
  static String get prefix => dotenv.env['API_PREFIX'] ?? 'api';
  static int get port => int.tryParse(dotenv.env['PORT'] ?? '3000') ?? 3000;

  static String get baseUrl => "$scheme://$host:$port/$prefix";
  static String get fileUrl => "$scheme://$host:$port";

  static String get upload =>
    "$scheme://$host:$port/${dotenv.env['UPLOAD_PATH'] ?? 'upload'}";

  static String get organization =>
    "$baseUrl/${dotenv.env['ORGANIZATION_PATH'] ?? 'organization'}";

  static String get beach =>
    "$baseUrl/${dotenv.env['BEACH_PATH'] ?? 'beach'}";

  static String get localProducer =>
    "$baseUrl/${dotenv.env['LOCAL_PRODUCER_PATH'] ?? 'local_producer'}";

  static String get place =>
    "$baseUrl/${dotenv.env['PLACE_PATH'] ?? 'place'}";

  static String get village =>
    "$baseUrl/${dotenv.env['VILLAGE_PATH'] ?? 'village'}";

  static String get activity =>
    "$baseUrl/${dotenv.env['ACTIVITY_PATH'] ?? 'activity'}";

  //form olan kısımın bir headera ihtiyacı yok o0 yüzden base url de api var buda header istiyor burda kullanmıyorum
  static String get feedback =>
    "$scheme://$host:$port/${dotenv.env['FEEDBACK_PATH'] ?? 'feedback'}";
}