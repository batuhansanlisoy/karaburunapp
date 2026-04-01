import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

class MapLauncher {
  static Future<void> openMap(BuildContext context, double? lat, double? lng) async {
    
    // 1. KONTROL: Koordinat yoksa mesajı burada çakıyoruz
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bu mekanın konum bilgisi henüz eklenmemiş."),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Uri url = Platform.isAndroid
        ? Uri.parse("google.navigation:q=$lat,$lng&mode=d")
        : Uri.parse("http://maps.apple.com/?daddr=$lat,$lng");

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        // Alternatif Web Linki
        final Uri googleUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");
        await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Hata durumunda da kullanıcıyı bilgilendirebilirsin
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harita uygulaması başlatılamadı.")),
      );
    }
  }
}