import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
    static String get baseUrl =>
        dotenv.env['BASE_URL'] ?? "http://localhost:3000";

    static String get upload =>
        "$baseUrl/${dotenv.env['UPLOAD_PATH'] ?? "upload"}";

    static String get organization =>
        "$baseUrl/${dotenv.env['ORGANIZATION_PATH'] ?? "organization"}";

    static String get beach =>
        "$baseUrl/${dotenv.env['BEACH_PATH'] ?? "beach"}";

    static String get place =>
        "$baseUrl/${dotenv.env['PLACE_PATH'] ?? "place"}";
}
