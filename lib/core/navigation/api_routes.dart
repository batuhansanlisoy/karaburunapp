import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {

    static final String scheme = dotenv.env['SCHEME']!;
    static final String host = dotenv.env['HOST']!;
    static final int port = int.tryParse(dotenv.env['PORT']!)!;

    static String get baseUrl =>
        dotenv.env['BASE_URL']!;

    static String get upload =>
        "$baseUrl/${dotenv.env['UPLOAD_PATH']}";

    static String get organization =>
        "$baseUrl/${dotenv.env['ORGANIZATION_PATH']}";

    static String get beach =>
        "$baseUrl/${dotenv.env['BEACH_PATH']}";

    static String get place =>
        "$baseUrl/${dotenv.env['PLACE_PATH']}";

    static String get village =>
        "$baseUrl/${dotenv.env['VILLAGE_PATH']}";

    static String get activity =>
        "$baseUrl/${dotenv.env['ACTIVITY_PATH']}";
}
