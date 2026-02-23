import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MapLauncher {
  static Future<void> openMap(double lat, double lng) async {
    Uri url;

    if (Platform.isAndroid) {
      // Android için en temiz Google Maps formatı
      url = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
    } else {
      // iOS için Apple Maps formatı
      url = Uri.parse("http://maps.apple.com/?daddr=$lat,$lng");
    }

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Eğer yukarıdaki özel linkler çalışmazsa (tarayıcıdan açmayı dene)
      final Uri googleUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Harita açılamadı.';
      }
    }
  }
}